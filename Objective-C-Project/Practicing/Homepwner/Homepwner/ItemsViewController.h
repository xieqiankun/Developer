//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Qiankun Xie on 2/17/16.
//  Copyright (c) 2016 Qiankun Xie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController 
    <UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end
