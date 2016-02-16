//
//  LearningTexasHoledmGame.h
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PokerDeck.h"

@interface LearningTexasHoledmGame : PokerDeck

@property (nonatomic, strong) NSMutableArray *cardss;

- (instancetype)initWithDeck:(Deck *)deck;

- (Card *) cardAtIndex:(NSInteger)index;

- (void) reTakeFromDeck:(Deck *)deck;
@end
