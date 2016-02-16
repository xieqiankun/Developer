//
//  QStack.h
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pusher/Pusher.h>
#import <Primus/Primus.h>
#import <Primus/SocketRocketClient.h>


@interface QStack : NSObject<PTPusherDelegate>

@property (strong, nonatomic) NSArray *myTournaments;


+ (instancetype) sharedQStack;

//For set user information
- (void)setUserInformation:(NSString *)newDisplayName
                withAvatar:(NSString *)newAvatar;

//For login
- (void)login:(NSString *)myAppId
      withKey:(NSString *)myAppKey
completionHandler:(void (^)(NSError *error))completionHandler;

- (void)getTournaments:(void (^)(NSError *error, NSData *data))completionHandler;

//For playing Game
- (void)connectGameServer:(NSString *)uuid completionHandler:(void (^)(NSError *error))completionHandler;
- (void)startSocket:(void (^)(NSDictionary *data))handler;
- (void)endSocket;
- (void)submitAnswer:(NSDictionary *) answer;





@end
