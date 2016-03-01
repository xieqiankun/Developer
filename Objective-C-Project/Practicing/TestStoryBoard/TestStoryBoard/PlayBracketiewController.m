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

@property (weak, nonatomic) IBOutlet UIView *questionLabelView;


@property (weak, nonatomic) IBOutlet UILabel *playerOne;

@property (weak, nonatomic) IBOutlet UILabel *playerTwo;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answers;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *answersView;


@property (weak, nonatomic) IBOutlet UIView *nameBoard;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *firstRoundPlayers;


@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *firstRoundPlayersView;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *secondRoundPlayers;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *secondRoundPlayersView;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *thirdRoundPlayers;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *thirdRoundPlayersView;

@property (weak, nonatomic) IBOutlet UIView *timeBarBackground;

@property (weak, nonatomic) IBOutlet UIView *timeBarFront;


//for game state control

@property (strong, nonatomic) NSMutableArray *playerNames;

@property (nonatomic) BOOL isAllowSubmit;

@property (nonatomic) BOOL isWinThisRound;

@property (nonatomic) NSInteger currentRound;

@property (nonatomic) NSInteger currentQuestionNumber;

@property (strong, nonatomic) NSArray *alivedPlayer;

@property (nonatomic) NSInteger currentSumbittedAnswer;

//for timer

@property (nonatomic, strong) NSTimer *timeBarTimer;

@property (nonatomic) NSNumber *timeNow;

@property (nonatomic) NSInteger time;

@property (weak, nonatomic) IBOutlet UILabel *timeBarLabel;

@end



@implementation PlayBracketiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set the background with ,png
    self.nameBoard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    [self UIBeforGameStart];
    [self startGame];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[QStack sharedQStack] endSocket];
    
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
    
    self.nameBoard.hidden = NO;
    self.playerOne.hidden = YES;
    self.playerTwo.hidden = YES;
    self.questionLabel.hidden = YES;
    
    //set up for name labels
    for(UIView *view in self.firstRoundPlayersView){
        
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view.layer setBorderWidth:2.0f];
        [view setBackgroundColor:[UIColor clearColor]];
    }
    for(UIView *view in self.secondRoundPlayersView){
        
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view.layer setBorderWidth:2.0f];
        [view setBackgroundColor:[UIColor clearColor]];
    }
    for(UIView *view in self.thirdRoundPlayersView){
        
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view.layer setBorderWidth:2.0f];
        [view setBackgroundColor:[UIColor clearColor]];
    }
    
    
    //set question label
    [self.questionLabelView.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.questionLabelView.layer.cornerRadius = 5;
    self.questionLabelView.layer.masksToBounds = YES;
    [self.questionLabelView.layer setBorderWidth:2.0f];
    [self.questionLabelView setBackgroundColor:[UIColor clearColor]];
    
    for(UIView *view in self.answersView){
        
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view.layer setBorderWidth:2.0f];
        [view setBackgroundColor:[UIColor clearColor]];
    }
    
    
    //set time bar
    [self.timeBarBackground.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.timeBarBackground.layer.cornerRadius = 18;
    self.timeBarBackground.layer.masksToBounds = YES;
    [self.timeBarBackground.layer setBorderWidth:2.0f];
    [self.timeBarBackground setBackgroundColor:[UIColor clearColor]];
    
    self.timeBarFront.layer.cornerRadius = 18;
    self.timeBarFront.layer.masksToBounds = YES;
    
    self.timeBarLabel.layer.cornerRadius = 27;
    self.timeBarLabel.layer.masksToBounds = YES;
    

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
        [btn setBackgroundColor:[UIColor clearColor]];
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
    self.currentRound = 1;
    
    self.isWinThisRound = 0;
    
    self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.questionLabel.numberOfLines = 0;
    
    self.alivedPlayer = @[@1,@1,@1,@1,@1,@1,@1,@1];
    
    self.currentSumbittedAnswer = -1;
    
}

- (void)startGame {
    
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
        self.currentSumbittedAnswer = -1;
        
        NSString * s = [self fixString:gameInfo[@"question"]];
        
        [self.questionLabel setText:[NSString stringWithFormat:@"%@", s]];
        
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
        
        //set timer
        NSString *timePeriod = gameInfo[@"timer"];
        self.time = [timePeriod intValue]/1000;
        self.timeNow = [NSNumber numberWithDouble:self.time];
        [self.timeBarLabel setText:[NSString stringWithFormat:@"%ld",(long)self.time]];
        
        CGRect newRect = self.timeBarBackground.frame;
        newRect.origin = CGPointZero;
        [self.timeBarFront setFrame:newRect];
        
        //control time delay for answer display
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            [self UIForAnswerQuestion];
            self.timeBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                                 target:self
                                                               selector:@selector(startTimer:)
                                                               userInfo:nil
                                                                repeats:YES];
            
        });
        
    }
    if ([type isEqual: @"correctAnswer"]){
        
        NSInteger answerNum = [gameInfo[@"correctAnswer"] integerValue];
        self.isAllowSubmit = NO;
        
        if (self.timeBarTimer != nil) {
            [self.timeBarTimer invalidate];
            self.timeBarTimer = nil;
        }
        
        if ([gameInfo[@"questionNum"] intValue] == self.currentQuestionNumber) {
            
            if (self.currentSumbittedAnswer >= 0){
                if(self.currentSumbittedAnswer == answerNum)
                    [self.answers[answerNum] setBackgroundColor:[UIColor greenColor]];
                else {
                    [self.answers[answerNum] setBackgroundColor:[UIColor greenColor]];
                    [self.answers[self.currentSumbittedAnswer] setBackgroundColor:[UIColor redColor]];
                }
            } else {
                [self.answers[answerNum] setBackgroundColor:[UIColor greenColor]];
            }
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
                
                UIView *view = self.thirdRoundPlayersView[i / 4];
                
                [view setBackgroundColor:[UIColor redColor]];
                
                if(i/4 % 2 != 0){
                    
                    UIView *view = self.thirdRoundPlayersView[i/4 - 1];
                    
                    [view setBackgroundColor:[UIColor greenColor]];
                    
                } else {
                    UIView *view = self.thirdRoundPlayersView[i/4 + 1];
                    
                    [view setBackgroundColor:[UIColor greenColor]];
                    
                }

                
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
            
            //set ui for nameboard
            if([alive intValue] != [formerAlive intValue]){
                
                if(self.currentRound == 1){
                    
                    UIView *view = self.firstRoundPlayersView[i];
                    
                    [view setBackgroundColor:[UIColor redColor]];
                    
                    if(i % 2 != 0){
                        
                        UIView *view = self.firstRoundPlayersView[i - 1];
                        
                        [view setBackgroundColor:[UIColor greenColor]];

                    } else {
                        UIView *view = self.firstRoundPlayersView[i + 1];
                        
                        [view setBackgroundColor:[UIColor greenColor]];

                    }
                    
                }
                
                if(self.currentRound == 2){
                    
                    UIView *view = self.secondRoundPlayersView[i / 2];
                    
                    [view setBackgroundColor:[UIColor redColor]];
                    
                    if(i/2 % 2 != 0){
                        
                        UIView *view = self.secondRoundPlayersView[i/2 - 1];
                        
                        [view setBackgroundColor:[UIColor greenColor]];
                        
                    } else {
                        UIView *view = self.secondRoundPlayersView[i/2 + 1];
                        
                        [view setBackgroundColor:[UIColor greenColor]];
                        
                    }

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


// for time bar
- (void)startTimer:(NSTimer *)timer{
    
    double tempTimeNow = [self.timeNow doubleValue] - 0.05;
    
    self.timeNow = [NSNumber numberWithDouble:tempTimeNow];
    
    [self.timeBarLabel setText:[NSString stringWithFormat:@"%i",(int)tempTimeNow]];
    
    CGRect newRect = self.timeBarFront.frame;
    
    double ratio = 1.0 * (self.time - tempTimeNow)/self.time;
    
    newRect.origin.x = ratio * (self.timeBarBackground.frame.size.width - self.timeBarLabel.frame.size.width) / 2;
    
    newRect.size.width = self.timeBarBackground.frame.size.width - 2* newRect.origin.x;
    
    [self.timeBarFront setFrame:newRect];
    
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
        
        //set the current submit index for helping show the correct ui
        self.currentSumbittedAnswer = index;
        
        //stop timer
        [self.timeBarTimer invalidate];
        self.timeBarTimer = nil;
        
        self.isAllowSubmit = NO;
        
        NSLocale* currentLocale = [NSLocale currentLocale];
        
        NSDictionary* answer = @{
                                 @"questionNum" : [NSNumber numberWithInteger:self.currentQuestionNumber],
                                 @"answer" : [NSNumber numberWithInteger:index],
                                 @"time" : [[NSDate date] descriptionWithLocale:currentLocale]
                                 
                                 };

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

- (IBAction)answers:(UIButton *)sender {
}
@end
