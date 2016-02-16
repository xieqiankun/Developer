//
//  TexasHoldemRegulation.h
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TexasHoldemRegulation : NSObject

+ (NSString *) handRanking:(NSArray *)cards;

+ (NSString *) bestHandRanking:(NSArray *)cards withIndex:(NSInteger)index;

@end
