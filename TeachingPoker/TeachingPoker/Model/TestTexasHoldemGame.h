//
//  TestTexasHoldemGame.h
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PokerDeck.h"

@interface TestTexasHoldemGame : PokerDeck

@property (nonatomic, strong) NSMutableArray *cardss;
@property (nonatomic) NSInteger gameStep;

- (instancetype)initWithDeck:(Deck *)deck;

- (Card *) cardAtIndex:(NSInteger)index;

- (void) reTakeFromDeck:(Deck *)deck;

@end
