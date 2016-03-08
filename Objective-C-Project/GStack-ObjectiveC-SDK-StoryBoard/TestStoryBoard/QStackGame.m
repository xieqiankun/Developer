//
//  QStackGame.m
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "QStackGame.h"

@implementation QStackGame

+ (instancetype) sharedGame
{
    static QStackGame *game;
    
    if(!game){
        game = [[QStackGame alloc] initPrivate];
    }
    return game;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[QStackGame sharedGame]"
                                 userInfo:nil];
    return nil;
}


- (instancetype) initPrivate
{
    self = [super init];
    return self;
    
}


- (void)startSocket:(NSString *)gameServerIp withPort:(NSString *)gameServerPort withToken:(NSString *)gameToken completionHandler:(void (^)(NSDictionary *data))handler {
    NSString *address = [NSString stringWithFormat:@"ws://%@:%@/primus/websocket", gameServerIp, gameServerPort];
    NSLog(@"Trying to establish connection to %@", address);
    NSURL *url = [NSURL URLWithString: address];
    
    
    
    PrimusConnectOptions *options = [[PrimusConnectOptions alloc] init];
    
    options.transformerClass = SocketRocketClient.class;
    options.strategy = @[@(kPrimusReconnectionStrategyTimeout)];
    options.timeout = 5000;
    options.manual = YES;
    //options.pong = 5000;
    options.ping = 1000;
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
        [self.primus write: gameToken];
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

- (void)endSocket
{
    [self.primus end];
    self.primus = nil;
    
}

- (void)submitAnswer:(NSDictionary*) answer
{
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
