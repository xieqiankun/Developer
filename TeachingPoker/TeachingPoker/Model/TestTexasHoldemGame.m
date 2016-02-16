//
//  TestTexasHoldemGame.m
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "TestTexasHoldemGame.h"

@interface TestTexasHoldemGame()



@end

@implementation TestTexasHoldemGame
- (NSMutableArray *)cardss
{
    if(!_cardss) {
        
        _cardss = [[NSMutableArray alloc] init];
    }
    return _cardss;
}


- (instancetype)initWithDeck:(Deck *)deck
{
    self = [super init];
    
    if(self){
        for(int i = 0; i <= 6; i ++){
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cardss addObject:card];
            }else{
                self = nil;
                break;
            }
        }
    }
    
    self.gameStep = 0;
    
    return self;
}

- (void) reTakeFromDeck:(Deck *)deck
{
    for(int i = 0; i <= 6; i++){
        Card *card = [deck drawRandomCard];
        [self.cardss insertObject:card
                          atIndex:i];
    }
}


- (Card *) cardAtIndex:(NSInteger)index
{
    // Card *card = self.cardss[index];
    // NSLog(@"%@", card.content);
    
    return (index < [self.cardss count]) ? self.cardss[index] : nil;
    
}



@end
