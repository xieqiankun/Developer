//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Qiankun Xie on 2/17/16.
//  Copyright (c) 2016 Qiankun Xie. All rights reserved.
//


#import <Foundation/Foundation.h>
@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;

- (void)removeItem:(BNRItem *)p;

- (NSArray *)allItems;

- (BNRItem *)createItem;

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;

- (NSString *)itemArchivePath;

- (BOOL)saveChanges;

@end
