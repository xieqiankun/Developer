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

@property (nonatomic) BOOL isWinThisRound;

@property (nonatomic) NSInteger currentRound;

@property (nonatomic) NSInteger currentQuestionNumber;

@property (strong, nonatomic) NSArray *alivedPlayer;


@end



@implementation PlayBracketiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self UIBeforGameStart];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ui part for nameboard&mainboard

- (void)UIBeforGameStart
{
    for (UIButton *btn in self.answers) {
        btn.hidden = YES;
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
    
    self.nameBoard.hidden = YES;
    self.playerOne.hidden = YES;
    self.playerTwo.hidden = YES;
    self.questionLabel.hidden = YES;
    
}

- (void)UIForShowingNameBoard
{
    self.nameBoard.hidden = NO;
}

- (void)UIForPlayingGame
{
    self.isWinThisRound = 1;
    self.nameBoard.hidden = YES;
    self.playerOne.hidden = NO;
    self.playerTwo.hidden = NO;
}

- (void)UIForReadingQuestion
{
    for (UIButton *btn in self.answers) {
        btn.hidden = YES;
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    self.questionLabel.hidden = NO;
}

- (void)UIForAnswerQuestion
{
    for (UIButton *btn in self.answers) {
        btn.hidden = NO;
    }
    
    
}



#pragma -mark start game part

- (void) initGameStateForStartingGame
{
    self.startBtn.hidden = YES;
    
    self.currentRound = 1;
    
    self.isWinThisRound = 0;
    
    self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.questionLabel.numberOfLines = 0;
    
    self.alivedPlayer = @[@1,@1,@1,@1,@1,@1,@1,@1];
    
    
}

- (IBAction)startGame:(id)sender {
    
    [self initGameStateForStartingGame];
    
    QStack *qstack = [QStack sharedQStack];
    
    
    //start the connection to server
    [qstack connectGameServer:self.uuid completionHandler:^(NSError *error) {
        if (!error){
            
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
        
        
        //set current question number && submit allowance
        self.currentQuestionNumber = [gameInfo[@"questionNum"] intValue];
        self.isAllowSubmit = YES;
        
        NSString * s = [self fixString:gameInfo[@"question"]];
        
        [self.questionLabel setText:[NSString stringWithFormat:@"%lu : %@",(self.currentQuestionNumber + 1), s]];
        
        [self UIForReadingQuestion];
        
        //game answers
        NSArray *receivedAnswers = gameInfo[@"answers"];
        
        //test using correct answer for the server
        NSString *rightAnswer = gameInfo[@"correct"];
        [self.answers[[rightAnswer intValue]] setBackgroundColor:[UIColor greenColor]];
        
        
        for(UIButton *btn in self.answers){

            NSInteger index = [self.answers indexOfObject:btn];
            NSString *s = receivedAnswers[index];
            //fix the string
            s = [self fixString:s];
            [btn setTitle:s forState:UIControlStateNormal];
        }
        
        //control time delay for answer display
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            [self UIForAnswerQuestion];
            
        });
        
    }
    if ([type isEqual: @"correctAnswer"]){
        
        NSInteger answerNum = [gameInfo[@"correctAnswer"] integerValue];
        self.isAllowSubmit = NO;
        
        if ([gameInfo[@"questionNum"] intValue] == self.currentQuestionNumber) {
            [self.answers[answerNum] setBackgroundColor:[UIColor greenColor]];
        }
        
    }
    
    if([type isEqual:@"gameResult"]){
        
        for(UIButton *btn in self.answers){
            //set visible
            btn.hidden = YES;
        }
        
        for (int i = 0; i < 8; i++){
            
            //compare last alive situation to current alive situation
            NSString *alive = data[@"payload"][@"teamAlive"][i];
            NSString *formerAlive = self.alivedPlayer[i];
            
            if([alive intValue] != [formerAlive intValue]){
                
                NSLog(@"former, %@", alive);
                NSLog(@"former, %@", formerAlive);
                
                //                NSLog(@"different number is %i", i);
                
                UILabel *label = self.thirdRoundPlayers[i / 4];
                
                [label setBackgroundColor:[UIColor grayColor]];
                
            }
        }
        
        self.nameBoard.hidden = NO;
        
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
        if(self.isWinThisRound){
            [self UIForPlayingGame];
        } else{
            [self UIForShowingNameBoard];
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
                    
                    UILabel *label = self.secondRoundPlayers[i / 2];
                    
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
        }
    }
    
    if([type isEqual:@"startRound"]){
        
        [self.playerOne setText:self.playerNames[0]];
        
        for(int i = 1; i <8; i++){
            NSString *isAlive = self.alivedPlayer[i];
            if([isAlive intValue] == 1){
                [self.playerTwo setText:self.playerNames[i]];
                break;
            }
        }
        
        [self UIForPlayingGame];
        
    }
    
    if ([type isEqual:@"roundResult"]){
        
        NSString *s = data[@"payload"][@"win"];
        
        if([s intValue] == 0){
            self.isWinThisRound = 0;
        }
        
        [self UIForShowingNameBoard];
        
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
    s = [s stringByReplacingOccurrencesOfString:@"<s>" withString:@"\'"];
    
    return s;
}


#pragma -mark submit part

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
