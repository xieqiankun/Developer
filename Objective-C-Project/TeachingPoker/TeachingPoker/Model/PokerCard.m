//
//  PokerCard.m
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PokerCard.h"

@implementation PokerCard

@synthesize suit = _suit;



- (NSString *)content
{
    
    
    NSArray *rankStrings = [PokerCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    
}


+ (NSArray *)validSuits
{
    
    
    return @[@"♠",@"♥", @"♦", @"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"k"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PokerCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}


+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSInteger)rank
{
    if (rank <= [PokerCard maxRank]) {
        _rank = rank;
    }
}


@end
