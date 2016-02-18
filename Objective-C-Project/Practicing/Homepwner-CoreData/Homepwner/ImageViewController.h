//
//  ImageViewController.h
//  Homepwner
//
//  Created by Qiankun Xie on 2/17/16.
//  Copyright (c) 2016 Qiankun Xie. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, strong) UIImage *image;
@end
