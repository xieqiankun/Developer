//
//  PlayBracketiewController.m
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PlayBracketiewController.h"
#import "QStack.h"

@interface PlayBracketiewController ()

// for ui
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerOne;
@property (weak, nonatomic) IBOutlet UILabel *playerTwo;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answers;

@property (weak, nonatomic) IBOutlet UIView *nameBoard;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *firstRoundPlayers;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *secondRoundPlayers;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *thirdRoundPlayers;

//for game state control

@property (strong, nonatomic) NSMutableArray *playerNames;

@property (nonatomic) BOOL isAllowSubmit;

@property (nonatomic) BOOL isAllowShowNameBoard;

@property (nonatomic) BOOL isWinThisRound;

@property (nonatomic) NSInteger currentRound;

@property (nonatomic) NSInteger currentQuestionNumber;

@property (strong, nonatomic) NSArray *alivedPlayer;


@end



@implementation PlayBracketiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UIButton *btn in self.answers) {
        btn.hidden = YES;
    }
    
    self.nameBoard.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startGame:(id)sender {
    
    self.startBtn.hidden = YES;
    
    QStack *qstack = [QStack sharedQStack];
    
    self.currentRound = 1;
    
    self.isAllowShowNameBoard = YES;
    
    self.alivedPlayer = @[@1,@1,@1,@1,@1,@1,@1,@1];
    
    //start the connection to server
    [qstack connectGameServer:self.uuid completionHandler:^(NSError *error) {
        if (!error){
            NSLog(@"start loading data");
            
            [qstack startSocket:^(NSDictionary *data) {
                
                [self choosePayLoadType:data];
                
            }];
        }
    }];
}

- (void) choosePayLoadType:(NSDictionary *)data
{
    NSString* type = data[@"type"];
    
    NSLog(@"Data:  %@", type);
    
    NSDictionary * gameInfo = data[@"payload" ];
    
    if ([type isEqual: @"sendQuestion"]){
        
        self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.questionLabel.numberOfLines = 0;
        
        //set current question number && submit allowance
        self.currentQuestionNumber = [gameInfo[@"questionNum"] intValue];
        self.isAllowSubmit = YES;
        
        NSString * s = [self fixString:gameInfo[@"question"]];
        
        [self.questionLabel setText:[NSString stringWithFormat:@"%lu : %@",(self.currentQuestionNumber + 1), s]];
        
        //game answers
        NSArray *receivedAnswers = gameInfo[@"answers"];
        
        for(UIButton *btn in self.answers){
            //set visible
            NSInteger index = [self.answers indexOfObject:btn];
            NSString *s = receivedAnswers[index];
            //fix the string
            s = [self fixString:s];
            [btn setTitle:s forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.hidden = NO;
            
        }
    }
    if ([type isEqual: @"correctAnswer"]){
        
        NSInteger answerNum = [gameInfo[@"correctAnswer"] integerValue];
        self.isAllowSubmit = NO;
        
        if ([gameInfo[@"questionNum"] intValue] == self.currentQuestionNumber) {
            [self.answers[answerNum] setBackgroundColor:[UIColor yellowColor]];
        }
        
    }
    
    if([type isEqual:@"gameResult"]){
        
        [self.questionLabel setText:@"Game Over"];
        
        for(UIButton *btn in self.answers){
            //set visible
            btn.hidden = YES;
        }
        
    }
    
    if([type isEqual:@"sendPlayerInfo"]){
        
        NSMutableArray * ans = [[NSMutableArray alloc] init];
        
        for(NSArray *array in data[@"payload"][@"teamNames"]){
            
            [ans addObject:array[0]];
        }
        self.playerNames = ans;
        
        //get the players' info and set them to UIlable
        [self setNames];
        
        //if allow to display, then display the nameboard
        if(self.isAllowShowNameBoard){
            if(self.isWinThisRound == 1){
                self.isAllowShowNameBoard = NO;
            } else{
                self.nameBoard.hidden = NO;
            }
        }
    }
    
    if([type isEqual:@"otherGameFinished"]){
        
        
        int aliveCount = 0;

        for (int i = 0; i < 8; i++){
            
            //compare last alive situation to current alive situation
            NSString *alive = data[@"alive"][i];
            NSString *formerAlive = self.alivedPlayer[i];
            
            if([alive intValue] != [formerAlive intValue]){
                
                NSLog(@"former, %@", alive);
                NSLog(@"former, %@", formerAlive);

                NSLog(@"different number is %i", i);
                
                if(self.currentRound == 1){
                    
                    UILabel *label = self.firstRoundPlayers[i];
                    
                    [label setBackgroundColor:[UIColor grayColor]];

                }
                
                if(self.currentRound == 2){
                    
                    UILabel *label = self.secondRoundPlayers[i % 2];
                    
                    [label setBackgroundColor:[UIColor grayColor]];
                }
                
            }
            
            if([alive intValue] == 1){
                aliveCount ++;
            }
        }
        
        //update the alive situation
        self.alivedPlayer = data[@"alive"];
        
        NSLog(@"Count Alive Is %i",aliveCount);
        
        if(aliveCount == 4 || aliveCount == 2){
            if(aliveCount == 4) self.currentRound = 2;
            if(aliveCount == 2) self.currentRound = 3;
            [self setNames];
            
            NSLog(@"=========================");

            
        }
    }
    
    if([type isEqual:@"startRound"]){
        self.isWinThisRound = 1;
        self.isAllowShowNameBoard = NO;
        self.nameBoard.hidden = YES;
        
    }
    
    if ([type isEqual:@"roundResult"]){
        
        NSString *s = data[@"payload"][@"win"];
        
        if([s intValue] == 0){
            self.isWinThisRound = 0;
        }
        
        self.isAllowShowNameBoard = YES;
        self.nameBoard.hidden = NO;
        
    }
    
    
    
}

- (void) setNames
{
    
    for (int i = 0; i <8; i++) {
        
        NSString *s = self.playerNames[i];
    
        UILabel* label =  self.firstRoundPlayers[i];
        
        [label setText:s];
    }
    
    if(self.currentRound == 2){
        
        NSLog(@"I am round222222222222");
        
        int aliveCount = 0;
        
        for (int i = 0; i <8; i++) {
            
            NSString *s = self.playerNames[i];
            
            NSString *alive = self.alivedPlayer[i];
            
            if([alive intValue] == 1){
                
                UILabel* label = self.secondRoundPlayers[aliveCount];
                
                [label setText:s];
                
                aliveCount ++;
            }
        }
    }
    
    if(self.currentRound == 3){
        NSLog(@"I am round3333333333");
        
        int aliveCount = 0;
        
        for (int i = 0; i <8; i++) {
            
            NSString *s = self.playerNames[i];
            
            NSString *alive = self.alivedPlayer[i];
            
            if([alive intValue] == 1){
                
                UILabel* label = self.thirdRoundPlayers[aliveCount];
                
                [label setText:s];
                
                aliveCount ++;
            }
        }
 
    }
}



- (NSString *)fixString:(NSString *)neededFixString
{
    NSString* s = [neededFixString stringByReplacingOccurrencesOfString:@"<q>" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"<a>" withString:@"\'"];
    
    return s;
}

- (IBAction)submitAnswer:(id)sender {
    
    if (self.isAllowSubmit) {
        
        NSInteger index = [self.answers indexOfObject:sender];
        
        self.isAllowSubmit = NO;
        
        NSLocale* currentLocale = [NSLocale currentLocale];
        
        NSDictionary* answer = @{
                                 @"questionNum" : [NSNumber numberWithInteger:self.currentQuestionNumber],
                                 @"answer" : [NSNumber numberWithInteger:index],
                                 @"time" : [[NSDate date] descriptionWithLocale:currentLocale]
                                 
                                 };
        [sender setBackgroundColor:[UIColor blueColor]];
        [[QStack sharedQStack] submitAnswer:answer];

        
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
