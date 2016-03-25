//
//  UIFont+SizeHelper.h
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/31/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (SizeHelper)

+(UIFont*)getFontTofitInRect:(CGRect) rect forText:(NSString*) text;

@end
