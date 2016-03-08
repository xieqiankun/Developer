//
//  QStackGame.h
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Primus/Primus.h>
#import <Primus/SocketRocketClient.h>


@interface QStackGame : NSObject

@property (strong, nonatomic) Primus * primus;

+ (instancetype) sharedGame;
- (void)startSocket:(NSString *)gameServerIp withPort:(NSString *)gameServerPort withToken:(NSString *)gameToken completionHandler:(void (^)(NSDictionary *data))handler;
- (void)endSocket;
- (void)submitAnswer:(NSDictionary*) answer;
@end
