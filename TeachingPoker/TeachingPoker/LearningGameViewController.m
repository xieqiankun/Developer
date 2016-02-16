//
//  LearningGameViewController.m
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "LearningGameViewController.h"
#import "PokerDeck.h"
#import "LearningTexasHoledmGame.h"
#import "TexasHoldemRegulation.h"
#import "PokerCardView.h"


@interface LearningGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (strong, nonatomic) IBOutletCollection(PokerCardView) NSArray *cardDisplayed;


@property (strong, nonatomic) Deck* deck;
@property (strong, nonatomic) LearningTexasHoledmGame *game;
@end

@implementation LearningGameViewController

-(LearningTexasHoledmGame *)game
{
    if(!_game){
        _game = [[LearningTexasHoledmGame alloc] initWithDeck:[self createDeck]];
    }
   // NSLog(@"a %@",[_game cardAtIndex:0].content);
    return _game;

}

-(Deck *)createDeck
{
    return [[PokerDeck alloc] init];
}


- (IBAction)doItAgain:(UIButton *)sender
{
    [self resetUI];
}

- (void)resetUI
{
    
    [self.game reTakeFromDeck:[self createDeck]];
   
    for(PokerCardView *view in self.cardDisplayed){
        
        NSInteger index = [self.cardDisplayed indexOfObject:view];
        
        PokerCard *card = self.game.cardss[index];
        
        view.rank = card.rank;
        view.suit = card.suit;
        
        view.faceUp = NO;

    }
    
    [self.answerLabel setText:@"Result"];
    
  
}


- (IBAction)seeResult:(id)sender {
    
    for(PokerCardView *view in self.cardDisplayed){
        
        view.faceUp = YES;
    }
    
    [self.answerLabel setText:[TexasHoldemRegulation handRanking:self.game.cardss]];

    
    
}

- (NSString *)titleForCard:(Card *)card
{
    return card.content;
}

- (IBAction)backBtn:(id)sender {
    
    [self dismissModalViewControllerAnimated:true];
}

@end
