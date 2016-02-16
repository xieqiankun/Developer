//
//  TexasHoldemRegulation.m
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "TexasHoldemRegulation.h"
#import "PokerCard.h"

@implementation TexasHoldemRegulation


+ (NSString *) handRanking:(NSArray *)cards
{
   
    if([self isRoyalFlush:cards]){
        return @"royal flush";
    } else if([self isStraightFlush:cards]){
        return @"Straight Flush";
    } else if([self isFourOfAKind:cards]){
        return @"Four of a kind";
    } else if([self isFlush:cards]){
        return @"Flush";
    } else if([self isFullHouse:cards]){
        return @"Full house";
    } else if([self isStraight:cards]){
        return @"Straight";
    }else if([self isThreeOfAKind:cards]){
        return @"Three of a kind";
    } else if([self isTwoPair:cards]){
        return @"Two Pairs";
    } else if([self isOnePair:cards]){
        return @"One pair";
    } else{
        return @"HighCard";
    }
    
    
    
    return @"";
    
}

+ (NSString *) bestHandRanking:(NSArray *)cardsTotal
                     withIndex:(NSInteger)index
{
    int rank = 0;
    
    for(int i = 0; i <= 2 - (7 - index) ; i++){

        for(int j= 1; j <= 3 - (7 - index) ; j ++){
            for(int k = 2; k<= 4 - (7 - index); k++){
                
                if(i == j || j == k || i == k)
                    continue;
                
                NSMutableArray *cards = [[NSMutableArray alloc] init];
                
                [cards addObject:cardsTotal[i]];
                [cards addObject:cardsTotal[j]];
                [cards addObject:cardsTotal[k]];
                [cards addObject:cardsTotal[5]];
                [cards addObject:cardsTotal[6]];
                
                
                int temp = 0;
                if([self isRoyalFlush:cards]){
                    temp = 10;
                } else if([self isStraightFlush:cards]){
                    temp = 9;
                } else if([self isFourOfAKind:cards]){
                    temp = 8;
                } else if([self isFlush:cards]){
                    temp = 6;
                } else if([self isFullHouse:cards]){
                    temp = 7;
                } else if([self isStraight:cards]){
                    temp = 5;
                }else if([self isThreeOfAKind:cards]){
                    temp = 4;
                } else if([self isTwoPair:cards]){
                    temp = 3;
                } else if([self isOnePair:cards]){
                    temp = 2;
                } else{
                    temp = 1;
                }
                
                if(temp > rank)
                    rank = temp;
                
            }
        }
    }
    
    
    switch (rank) {
        case 10:
            return @"royal flush";
            break;
        case 9:
            return @"straight flush";
            break;
        case 8:
            return @"four of a kind";
            break;
        case 7:
            return @"full house";
            break;
        case 6:
            return @"flush";
            break;
        case 5:
            return @"Straight";
            break;
        case 4:
            return @"Three of a kind";
            break;
        case 3:
            return @"Two Pairs";
            break;
        case 2:
            return @"One Pairs";
            break;
        case 1:
            return @"High Card";
            break;
            
        default:
            break;
    }
    
    
    
    return @"aaa";
    
}


+ (BOOL) isStraight:(NSArray *)cards
{
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 5; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    if([nums[0] integerValue] == 1){
        if([nums[1] integerValue] == 10){
            if([nums[2] integerValue] == 11){
                if([nums[3] integerValue] == 12){
                    if([nums[4] integerValue] == 13){
                        return YES;
                    }
                }
            }
        }
    }
    
    
    for(int i = 1; i <= 4; i++){
        NSInteger num1 = [nums[i] integerValue];
        NSInteger num2 = [nums[i-1] integerValue];
        if((num1 - num2) != 1)
            return NO;
        
    }
    return YES;
    
    
}

+ (BOOL) isRoyalFlush:(NSArray *)cards
{
    
    if(![self isFlush:cards]){
        return NO;
    }

    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    if([nums[0] integerValue] == 1){
        if([nums[1] integerValue] == 10){
            if([nums[2] integerValue] == 11){
                if([nums[3] integerValue] == 12){
                    if([nums[4] integerValue] == 13){
                        return YES;
                    }
                }
            }
        }
    }
    
    
    return NO;
}

+ (BOOL) isFlush:(NSArray *)cards
{
    BOOL b = YES;
    NSString *string;
    
    for (int i = 0; i <= 4 ; i++) {
        PokerCard *card = cards[i];
        NSLog(@"card, %@", card.suit);
        if(i == 0)
            string = card.suit;
        else {
            if (![card.suit isEqualToString:string]) {
                b = NO;
            }
        }
    }
    return b;

}


+ (BOOL) isStraightFlush:(NSArray *)cards{
    
    if(![self isFlush:cards]){
        return NO;
    }
    
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    for(int i = 1; i <= 4; i++){
        NSInteger num1 = [nums[i] integerValue];
        NSInteger num2 = [nums[i-1] integerValue];
        if((num1 - num2) != 1)
            return NO;
        
    }
    return YES;
}


+ (BOOL) isFourOfAKind:(NSArray *)cards
{
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL b = YES;
    
    for(int i = 0; i<= 3; i++){
        if([nums[i] integerValue] != [nums[0] integerValue])
            b = NO;
    }
    if(b) return YES;
    
    b = YES;
    
    for(int i = 1; i<= 4; i++){
        if([nums[i] integerValue] != [nums[1] integerValue])
            b = NO;
    }
    if(b) return YES;
    
    return NO;
}

+ (BOOL) isFullHouse:(NSArray *)cards
{
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL three = YES;
    BOOL two = YES;
    for(int i = 0; i <= 2; i++){
        if([nums[i] integerValue] != [nums[0] integerValue])
            three = NO;
    }
    for(int i = 3; i <= 4; i++){
        if([nums[i] integerValue] != [nums[3] integerValue])
            two = NO;
    }
    if(three && two) return YES;
    
    three = YES;
    two = YES;
    for(int i = 0; i <= 1; i++){
        if([nums[i] integerValue] != [nums[0] integerValue])
            three = NO;
    }
    for(int i = 2; i <= 4; i++){
        if([nums[i] integerValue] != [nums[3] integerValue])
            two = NO;
    }
    if(three && two) return YES;
    
    return NO;
}


+(BOOL) isThreeOfAKind:(NSArray *)cards
{
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL three = YES;
    for(int i = 0; i <= 2; i++){
        if([nums[i] integerValue] != [nums[0] integerValue])
            three = NO;
    }

    if(three) return YES;
    
    three = YES;
    for(int i = 1; i <= 3; i++){
        if([nums[i] integerValue] != [nums[1] integerValue])
            three = NO;
    }

    if(three) return YES;
    
    three = YES;
    for(int i = 2; i <= 4; i++){
        if([nums[i] integerValue] != [nums[2] integerValue])
            three = NO;
    }
    
    if(three) return YES;
    
    return NO;
    
}

+(BOOL) isTwoPair:(NSArray *)cards
{
    
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL two = YES;
    for(int i = 0; i <= 1; i++){
        if([nums[i] integerValue] != [nums[0] integerValue])
            two = NO;
    }
    for(int i = 2; i <= 3; i++){
        if([nums[i] integerValue] != [nums[2] integerValue])
            two = NO;
    }
    
    if(two) return YES;
    
    two = YES;
    for(int i = 1; i <= 2; i++){
        if([nums[i] integerValue] != [nums[1] integerValue])
            two = NO;
    }
    for(int i = 3; i <= 4; i++){
        if([nums[i] integerValue] != [nums[3] integerValue])
            two = NO;
    }
    if(two) return YES;
    
    two = YES;
    for(int i = 0; i <= 1; i++){
        if([nums[i] integerValue] != [nums[0] integerValue])
            two = NO;
    }
    for(int i = 3; i <= 4; i++){
        if([nums[i] integerValue] != [nums[3] integerValue])
            two = NO;
    }
    if(two) return YES;
    
    return NO;

}
           
+ (BOOL) isOnePair:(NSArray *)cards
{
    NSMutableArray *num = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= 4; i++){
        PokerCard *card = cards[i];
        [num addObject:[NSNumber numberWithInt:card.rank]];
    }
    
    NSArray *nums = [num sortedArrayUsingSelector:@selector(compare:)];


    for(int i = 0; i <= 3; i++){
        if([nums[i] integerValue] == [nums[i+1] integerValue])
            return YES;
    }
    
    
    return NO;
}

@end
