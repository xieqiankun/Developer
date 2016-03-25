//
//  UIFont+SizeHelper.m
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/31/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

#import "UIFont+SizeHelper.h"

@implementation UIFont (SizeHelper)

+(UIFont*)getFontTofitInRect:(CGRect) rect forText:(NSString*) text {
    CGFloat baseFont=0;
    UIFont *myFont=[UIFont systemFontOfSize:baseFont];
    CGSize fSize=[text sizeWithAttributes:@{NSFontAttributeName: myFont}];
    CGFloat step=0.1f;
    
    BOOL stop=NO;
    CGFloat previousH = 0.0;
    while (!stop) {
        myFont=[UIFont systemFontOfSize:baseFont+step ];
//        fSize=[text sizeWithFont:myFont constrainedToSize:rect.size lineBreakMode:UILineBreakModeWordWrap];
        fSize = [text sizeWithAttributes:@{NSFontAttributeName: myFont}];
        
        if(fSize.height+myFont.lineHeight>rect.size.height){
            myFont=[UIFont systemFontOfSize:previousH];
            fSize=CGSizeMake(fSize.width, previousH);
            stop=YES;
        }else {
            previousH=baseFont+step;
        }
        
        step++;
    }
    return myFont;
}

@end
