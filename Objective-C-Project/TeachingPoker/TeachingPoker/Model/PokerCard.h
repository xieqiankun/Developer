//
//  PokerCard.h
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "Card.h"

@interface PokerCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;

@end
