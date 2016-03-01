//
//  QStack.m
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "QStack.h"
#import "PusherSock.h"
#import "QStackGame.h"

@interface QStack()

@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appID;

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSString *token;

//using for start a game
@property (strong, nonatomic) NSString* gameServerIp;
@property (strong, nonatomic) NSString* gameServerPort;
@property (strong, nonatomic) NSString* gameToken;

@end

@implementation QStack

#pragma mark - init part

+ (instancetype) sharedQStack
{
    static QStack *qstack;
    
    if(!qstack){
        qstack = [[QStack alloc] initPrivate];
        // init server URL
        qstack.serverURL = @"http://UserServerLB-672243361.us-west-2.elb.amazonaws.com/";
        
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
    NSString *route = @"register";
    NSString *type = @"apiRegister";
    
    [self sendRequestRoute:route withType:type withPayload:payloadDic isPrivate:NO completionHander:^(NSData *data,
                                                                                                                      NSURLResponse *response,
                                                                                                                      NSError *error) {
        if (!error){
            NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Debug 1:%@",myDictionary);
            
            NSString* type = myDictionary[@"type"];
            if ([type isEqual: @"apiRegisterSuccess"]){
                self.channel = myDictionary[@"payload"][@"channel"];
                self.token = myDictionary[@"payload"][@"token"];
                
                [[PusherSock sharedPusher] startPusher:self.channel];
                
               // [self startPusher:self.channel];
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
    }];

  }

- (void)getTournaments:(void (^)(NSError *error, NSData *data))completionHandler{
    
    //set the payload && get post string
    NSDictionary *payloadDic = @{};
    
    NSString *route = @"gettournaments";
    NSString *type = @"getUserTournaments";
    
    [self sendRequestRoute:route withType:type withPayload:payloadDic isPrivate:YES completionHander:^(NSData *data,
                                                                                                       NSURLResponse *response,
                                                                                                       NSError *error) {
        
        NSArray *temp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.myTournaments = temp;
        
        [self setMyTraditionalT:self.myTournaments];
        [self setMyBracketT:self.myTournaments];

        completionHandler(error, data);
        
    }];
    
}

//override set my triditional tournament
-(void)setMyTraditionalT:(NSArray *)myTournament
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dic in myTournament){
        if([dic[@"style"] isEqualToString:@"traditional"]){
            [array addObject:dic];
        }
    }
    
    _myTraditionalT = array;
}

//override set my bracket tournament
-(void)setMyBracketT:(NSArray *)myTournament
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dic in myTournament){
        if([dic[@"style"] isEqualToString:@"shootout"]){
            [array addObject:dic];
        }
    }
    
    _myBracketT = array;
    
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
    
    NSString *route = @"startgame";
    NSString *type = @"clientStartGame";
    
    [self sendRequestRoute:route withType:type withPayload:payloadDic isPrivate:YES completionHander:^(NSData *data,
                                                                                                       NSURLResponse *response,
                                                                                                       NSError *error) {
        if (!error){
            NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSString* type = myDictionary[@"type"];
            
            NSLog(@"type for date: %@",myDictionary);
            
            if ([type isEqual: @"startGameSuccess"]){

                [[PusherSock sharedPusher] didReceiveEvent:@"newGameSuccess" completionHandler:^(PTPusherEvent *channelEvent){
                    NSDictionary *data = [channelEvent data];
                    
                    if([[channelEvent data][@"event"]  isEqual: @"newGameSuccess"]){
                        self.gameToken = data[@"token"];
                        self.gameServerIp = data[@"serverIp"];
                        self.gameServerPort = data[@"serverPort"];

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
}



- (void)startSocket:(void (^)(NSDictionary *data))handler {
    
    [[QStackGame sharedGame]startSocket:self.gameServerIp withPort:self.gameServerPort withToken:self.gameToken completionHandler:handler];
    
  }

- (void)endSocket {
    [[QStackGame sharedGame] endSocket];
}

- (void)submitAnswer:(NSDictionary*) answer {
    
    [[QStackGame sharedGame] submitAnswer:answer];
}




#pragma -mark send request

- (void) sendRequestRoute:(NSString *)route withType:(NSString *)type withPayload:(NSDictionary *)payload isPrivate:(BOOL)isPrivate completionHander: (void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler
{
    
    NSString* requestSuffex;
    
    if(isPrivate){
        requestSuffex = [NSString stringWithFormat:@"qstacks/%@",route];
    } else {
        requestSuffex = [NSString stringWithFormat:@"qstack/%@",route];
    }
    
    NSURL *url = [NSURL URLWithString:[self.serverURL stringByAppendingString:requestSuffex]];
    
    NSLog(@"%@", url);
    
    NSDictionary *payloadDic = payload;
    
    NSString *payloadStr = [self stringifyDic:payloadDic];
    
    NSDictionary *postDic = @{
                              @"type" : type,
                              @"payload" : payloadStr
                              };
    NSString * post =[self stringifyDic:postDic];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest: request
                                            completionHandler: completionHandler];
    
    [dataTask resume];
    
    
}

//stringify json
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
