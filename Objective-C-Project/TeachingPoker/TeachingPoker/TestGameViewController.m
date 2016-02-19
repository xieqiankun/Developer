//
//  TestGameViewController.m
//  TeachingPoker
//
//  Created by 谢乾坤 on 2/3/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "TestGameViewController.h"
#import "TestTexasHoldemGame.h"
#import "TexasHoldemRegulation.h"
#import "PokerDeck.h"
#import "PokerCardView.h"

@interface TestGameViewController ()


@property (weak, nonatomic) IBOutlet UILabel *answerBoard;

@property (strong, nonatomic) TestTexasHoldemGame *game;

@property (strong, nonatomic) IBOutletCollection(PokerCardView) NSArray *cardsOnDeck;

@property (strong, nonatomic) IBOutletCollection(PokerCardView) NSArray *cardsOnHand;

@property (weak, nonatomic) IBOutlet UIButton *gameStepBtn;


@end


@implementation TestGameViewController

-(TestTexasHoldemGame *)game
{
    if(!_game){
        _game = [[TestTexasHoldemGame alloc] initWithDeck:[self createDeck]];
    }
    // NSLog(@"a %@",[_game cardAtIndex:0].content);
    return _game;
    
}

-(Deck *)createDeck
{
    return [[PokerDeck alloc] init];
}

- (IBAction)doItAgainBtn:(UIButton *)sender {
    
    [self.answerBoard setText:@"Answer is here"];
    
    [self resetUI];
}

- (void) resetUI
{
    [self.game reTakeFromDeck:[self createDeck]];
    
    self.game.gameStep = 0;
    
    [self buttonUI];
    
    for(PokerCardView *view in self.cardsOnDeck){
        
        NSInteger index = [self.cardsOnDeck indexOfObject:view];
        
        PokerCard *card = self.game.cardss[index];
        
        view.rank = card.rank;
        
        view.suit = card.suit;
        
        view.faceUp = NO;
  
    }
    
    
    for(PokerCardView *view in self.cardsOnHand){
        
        NSInteger index = [self.cardsOnHand indexOfObject:view]+5;
        
        PokerCard *card = self.game.cardss[index];
        
        view.rank = card.rank;
        
        view.suit = card.suit;
        
        view.faceUp = YES;
    }
}

- (void)buttonUI{
    
    if(self.game.gameStep == 0){
        [self.gameStepBtn setTitle:@"Flop" forState:UIControlStateNormal];}
    else if(self.game.gameStep == 1){
            [self.gameStepBtn setTitle:@"Turn" forState:UIControlStateNormal];
    }else if(self.game.gameStep == 2){
         [self.gameStepBtn setTitle:@"River" forState:UIControlStateNormal];
    }else{
        [self.gameStepBtn setTitle:@"GameOver" forState:UIControlStateNormal];
    }
        
    
}

- (IBAction)gameStep:(id)sender {
    
    
        if(self.game.gameStep == 0){
           
    
            for(int i = 0; i <= 2; i++){
    
                PokerCardView *view = self.cardsOnDeck[i];
                view.faceUp = YES;
            }
            
            [self.answerBoard setText:[TexasHoldemRegulation bestHandRanking:self.game.cardss withIndex:5]];

        }else if(self.game.gameStep == 1){
    
            PokerCardView *view = self.cardsOnDeck[3];
            view.faceUp = YES;
            
            [self.answerBoard setText:[TexasHoldemRegulation bestHandRanking:self.game.cardss withIndex:6]];
    
    
        }else if(self.game.gameStep == 2){
    
            PokerCardView *view = self.cardsOnDeck[4];
            view.faceUp = YES;
            
            [self.answerBoard setText:[TexasHoldemRegulation bestHandRanking:self.game.cardss withIndex:7]];
    
        }
        self.game.gameStep ++;
        [self buttonUI];

    
    
    

}






- (IBAction)backBtn:(id)sender {
    
    [self dismissModalViewControllerAnimated:true];

}

@end
