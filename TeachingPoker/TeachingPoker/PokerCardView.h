//
//  PokerCardView.h
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/8/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokerCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) BOOL faceUp;


@end
