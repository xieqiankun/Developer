//
//  QStack.m
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "QStack.h"

@interface QStack()

@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appID;

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSString *token;

//using for start the pusher
@property (strong, nonatomic) PTPusher *pusherClient;
@property (strong, nonatomic) PTPusherChannel *pusherChannel;
@property (strong, nonatomic) PTPusherEventBinding *pusherBinding;

//using for start a game
@property (strong, nonatomic) NSString* gameServerIp;
@property (strong, nonatomic) NSString* gameServerPort;
@property (strong, nonatomic) NSString* gameToken;

@property (strong, nonatomic) Primus * primus;

@end

@implementation QStack

#pragma mark - init part

+ (instancetype) sharedQStack
{
    static QStack *qstack;
    
    if(!qstack){
        qstack = [[QStack alloc] initPrivate];
        // init server URL
        qstack.serverURL = @"http://UserServerLB-672243361.us-west-2.elb.amazonaws.com";
        
    }
    return qstack;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[QStack sharedQStack]"
                                 userInfo:nil];
    return nil;
}


- (instancetype) initPrivate
{
    self = [super init];
    return self;
    
}


#pragma mark - dealing with pusher

- (void)startPusher:(NSString *)channelNumber
{
    self.pusherClient = [PTPusher pusherWithKey:@"4779f1bf61be1bc819da" delegate:self encrypted:YES];
    [self.pusherClient connect];
    self.pusherChannel = [self.pusherClient subscribeToChannelNamed:channelNumber];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect
{
    NSLog(@"%@", error);
}



#pragma mark - user login part

- (void)setUserInformation:(NSString*)myDisplayName
                withAvatar:(NSString*)myAvatar
{
    self.displayName = myDisplayName;
    self.avatar = myAvatar;
}

- (void)login:(NSString*)myAppId
      withKey:(NSString*)myAppKey
completionHandler:(void (^)(NSError *error))completionHandler
{
    
    //set the payload && get post string
    NSDictionary *payloadDic = @{
                                 @"appId" : myAppId,
                                 @"appKey" : myAppKey
                                 };
    NSString *payloadStr = [self stringifyDic:payloadDic];
    
    NSDictionary *postDic = @{
                              @"type" : @"apiRegister",
                              @"payload" : payloadStr
                              };
    NSString * post =[self stringifyDic:postDic];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[self.serverURL stringByAppendingString:@"/qstack/register"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    // like NSURLConnection
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (!error){
                        NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        //NSLog(@"Debug 1:%@",myDictionary);
                        
                        NSString* type = myDictionary[@"type"];
                        if ([type isEqual: @"apiRegisterSuccess"]){
                            self.channel = myDictionary[@"payload"][@"channel"];
                            self.token = myDictionary[@"payload"][@"token"];
                            
                            [self startPusher:self.channel];
                            completionHandler(nil);
                        }
                        else{
                            completionHandler([NSError errorWithDomain:type code:0 userInfo:myDictionary]);
                        }
                    }
                    else{
                        NSLog(@"%@", error);
                        completionHandler(error);
                    }
                }] resume];
    
}

- (void)getTournaments:(void (^)(NSError *error, NSData *data))completionHandler{
    
    //set the payload && get post string
    NSDictionary *payloadDic = @{};
    
    NSString *payloadStr = [self stringifyDic:payloadDic];
    
    NSDictionary *postDic = @{
                              @"type" : @"getUserTournaments",
                              @"payload" : payloadStr
                              };
    NSString * post =[self stringifyDic:postDic];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self.serverURL stringByAppendingString:@"/qstacks/gettournaments"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest: request
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                completionHandler(error, data);
                                                
                                            }];
    
    [dataTask resume];
    
}

#pragma mark -start to play

- (void)connectGameServer:(NSString*)uuid completionHandler:(void (^)(NSError *error))completionHandler{
    
    //set the payload && get post string
    
    NSDictionary *gameModeDic = @{
                                  @"type" : @"tournament",
                                  @"category" : @"General",
                                  @"wager" : [NSNumber numberWithInt:0],
                                  @"asyncChallenge" : [NSNull null],
                                  @"uuid" : uuid,
                                  @"zone" :@"General Knowledge"
                                  };
    NSDictionary *teamDic = @{
                              @"displayName" : self.displayName,
                              @"channel" : self.channel,
                              @"avatar" : self.avatar
                              };
    
    NSDictionary *payloadDic = @{
                                 @"gameMode" : gameModeDic,
                                 @"teams" : @[teamDic]
                                 };
    
    NSString *payloadStr = [self stringifyDic:payloadDic];
    
    NSDictionary *postDic = @{
                              @"type" : @"clientStartGame",
                              @"payload" : payloadStr
                              };
    NSString * post =[self stringifyDic:postDic];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self.serverURL stringByAppendingString:@"/qstacks/startgame"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest: request
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                if (!error){
                                                    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                    
                                                    NSString* type = myDictionary[@"type"];
                                                    
                                                    NSLog(@"type for date: %@",myDictionary);
                                                    
                                                    if ([type isEqual: @"startGameSuccess"]){
                                                        
                                                        if (self.pusherBinding) {
                                                            [self.pusherClient removeBinding:self.pusherBinding];
                                                        }
                                                        self.pusherBinding = [self.pusherChannel bindToEventNamed:@"newGameSuccess" handleWithBlock:^(PTPusherEvent *channelEvent) {
                                                            
                                                            NSDictionary *data = [channelEvent data];
                                                            
                                                            if([[channelEvent data][@"event"]  isEqual: @"newGameSuccess"]){
                                                                self.gameToken = data[@"token"];
                                                                self.gameServerIp = data[@"serverIp"];
                                                                self.gameServerPort = data[@"serverPort"];
                                                                
                                                             //   NSLog(@"Server IP : %@",self.gameServerIp);
                                                             //  NSLog(@"Server prot : %@",self.gameServerPort);
                                                                completionHandler(nil);
                                                            }
                                                            else{
                                                                completionHandler([NSError errorWithDomain:@"Game Error" code:0 userInfo:nil]);
                                                            }
                                                        }];
                                                    }
                                                    else{
                                                        completionHandler([NSError errorWithDomain:type code:0 userInfo:myDictionary]);
                                                    }
                                                }
                                                else{
                                                    NSLog(@"%@", error);
                                                    completionHandler(error);
                                                }
                                            }];
    [dataTask resume];
}



- (void)startSocket:(void (^)(NSDictionary *data))handler {
    NSString *address = [NSString stringWithFormat:@"ws://%@:%@/primus/websocket", self.gameServerIp, self.gameServerPort];
    NSLog(@"Trying to establish connection to %@", address);
    NSURL *url = [NSURL URLWithString: address];
    
    PrimusConnectOptions *options = [[PrimusConnectOptions alloc] init];
    
    options.transformerClass = SocketRocketClient.class;
    options.strategy = @[@(kPrimusReconnectionStrategyTimeout)];
    //    options.timeout = 200;
    options.manual = YES;
    options.ping = 5000;
    options.autodetect = NO;
    
    self.primus = [[Primus alloc] initWithURL:url options:options];
    
    [self.primus on:@"reconnect" listener:^(PrimusReconnectOptions *options) {
        NSLog(@"[reconnect] - We are scheduling a new reconnect attempt");
    }];
    
    [self.primus on:@"online" listener:^{
        NSLog(@"[network] - We have regained control over our internet connection.");
    }];
    
    [self.primus on:@"offline" listener:^{
        NSLog(@"[network] - We lost our internet connection.");
    }];
    
    [self.primus on:@"open" listener:^{
        NSLog(@"[open] - The connection has been established.");
        [self.primus write: self.gameToken];
    }];
    
    [self.primus on:@"error" listener:^(NSError *error) {
        NSLog(@"[error] - Error: %@", error);
    }];
    
    [self.primus on:@"data" listener:^(NSDictionary *data, id raw) {
        NSLog(@"data: %@", data);
        handler(data);
    }];
    
    [self.primus on:@"end" listener:^{
        NSLog(@"[end] - The connection has ended.");
    }];
    
    [self.primus on:@"close" listener:^{
        NSLog(@"[close] - We've lost the connection to the server.");
    }];
    
    [self.primus open];
}

- (void)endSocket {
    [self.primus end];
    self.primus = nil;
}

- (void)submitAnswer:(NSDictionary*) answer {
    
    NSDictionary *data = @{
                           @"type" : @"clientSubmitAnswer",
                           @"payload" : answer,
                           };
    if (self.primus) {
        [self.primus write: data];
        NSLog(@"%@", data);
    }
}


- (NSString *) stringifyDic:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&error];
    NSString *jsonString = nil;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
    }
    return jsonString;
}

@end
