//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Qiankun Xie on 2/17/16.
//  Copyright (c) 2016 Qiankun Xie. All rights reserved.
//


#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize serialNumberLabel;
@synthesize valueLabel;
@synthesize thumbnailView;
@synthesize nameLabel;
@synthesize controller;
@synthesize tableView;

- (IBAction)showImage:(id)sender 
{
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if(indexPath) {
        if([controller respondsToSelector:newSelector]) {
            [controller performSelector:newSelector withObject:sender 
                             withObject:indexPath];
        }
    }
}
@end
