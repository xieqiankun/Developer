//
//  QStack.m
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "QStack.h"

@interface QStack()

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
    NSString *post = [NSString stringWithFormat:@"type=apiRegister&payload={\"appId\":%@,\"appKey\":\"%@\"}", myAppId, myAppKey];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"http://UserServerLB-672243361.us-west-2.elb.amazonaws.com/qstack/register"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
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
    
    NSString *post = [NSString stringWithFormat:@"type=getUserTournaments&payload={}"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://UserServerLB-672243361.us-west-2.elb.amazonaws.com/qstacks/gettournaments"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    completionHandler(error, data);
                    
                }] resume];
    
}

#pragma mark -start to play

- (void)connectGameServer:(NSString*)uuid completionHandler:(void (^)(NSError *error))completionHandler{
    NSString *post = [NSString stringWithFormat:@"type=clientStartGame&payload={\"gameMode\":{\"type\":\"tournament\",\"category\":\"General\",\"wager\":0,\"asyncChallenge\":null,\"uuid\":\"%@\",\"zone\":\"General Knowledge\"},\"teams\":[{\"displayName\":\"%@\",\"channel\":\"%@\",\"avatar\":\"%@\"}]}", uuid, self.displayName, self.channel, self.avatar];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://UserServerLB-672243361.us-west-2.elb.amazonaws.com/qstacks/startgame"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
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
                                    
//NSLog(@"Server IP : %@",self.gameServerIp);
//NSLog(@"Server prot : %@",self.gameServerPort);
                                    
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
                }] resume];
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






@end
