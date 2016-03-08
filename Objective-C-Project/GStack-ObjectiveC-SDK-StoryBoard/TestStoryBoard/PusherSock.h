//
//  PusherSock.h
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pusher/Pusher.h>

@interface PusherSock : NSObject<PTPusherDelegate>

@property (strong, nonatomic) PTPusher *pusherClient;
@property (strong, nonatomic) PTPusherChannel *pusherChannel;
@property (strong, nonatomic) PTPusherEventBinding *pusherBinding;

+ (instancetype) sharedPusher;

- (void)startPusher:(NSString *)channelNumber;

- (void)didReceiveEvent:(NSString *)event completionHandler:(void (^)(PTPusherEvent *channelEvent))completionHandler;

@end
