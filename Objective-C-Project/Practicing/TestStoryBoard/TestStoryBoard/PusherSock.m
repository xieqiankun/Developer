//
//  PusherSock.m
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PusherSock.h"

@implementation PusherSock


+ (instancetype) sharedPusher
{
    static PusherSock *pusher;
    
    if(!pusher){
        pusher = [[PusherSock alloc] initPrivate];
    }
    return pusher;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[PusherSock sharedPusher]"
                                 userInfo:nil];
    return nil;
}


- (instancetype) initPrivate
{
    self = [super init];
    return self;
    
}


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

- (void)didReceiveEvent:(NSString *)event completionHandler:(void (^)(PTPusherEvent *channelEvent))completionHandler
{
    if (self.pusherBinding) {
        [self.pusherClient removeBinding:self.pusherBinding];
    }
    self.pusherBinding = [self.pusherChannel bindToEventNamed:event handleWithBlock:completionHandler];
}



@end
