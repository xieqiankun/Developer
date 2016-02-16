//
//  PokerDeck.m
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PokerDeck.h"

@implementation PokerDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        for (NSString *suit in [PokerCard validSuits]) {
            for (int rank = 1; rank <= [PokerCard maxRank]; rank++) {
                PokerCard *card = [[PokerCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
