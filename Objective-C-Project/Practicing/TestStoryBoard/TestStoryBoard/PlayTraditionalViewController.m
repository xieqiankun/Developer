//
//  PlayTriditionalViewController.m
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PlayTraditionalViewController.h"
#import "QStack.h"

@interface PlayTraditionalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UIView *questionLabelView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answers;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *answersView;

@property (weak, nonatomic) IBOutlet UIView *timeBarView;

@property (weak, nonatomic) IBOutlet UIView *timeBar;

@property (weak, nonatomic) IBOutlet UILabel *timeBarClock;

//for timer
@property (nonatomic, strong) NSTimer *timeBarTimer;

@property (nonatomic) NSNumber *timeNow;

@property (nonatomic) NSInteger time;


@property (nonatomic) NSInteger currentQuestionNumber;
@property (nonatomic) BOOL isAllowSubmit;
@property (nonatomic) NSInteger currentSumbittedAnswer;


@end

@implementation PlayTraditionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUIBeforeStart];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self startGame];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [[QStack sharedQStack] endSocket];
    
    
}

- (void)setUIBeforeStart{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];

    
    for(UIView *view in self.answersView){
        
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view.layer setBorderWidth:2.0f];
        [view setBackgroundColor:[UIColor clearColor]];
    }
    
    [self.questionLabelView.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.questionLabelView.layer.cornerRadius = 5;
    self.questionLabelView.layer.masksToBounds = YES;
    [self.questionLabelView.layer setBorderWidth:2.0f];
    [self.questionLabelView setBackgroundColor:[UIColor clearColor]];
    
    //set time bar
    [self.timeBarView.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.timeBarView.layer.cornerRadius = 17;
    self.timeBarView.layer.masksToBounds = YES;
    [self.timeBarView.layer setBorderWidth:2.0f];
    [self.timeBarView setBackgroundColor:[UIColor clearColor]];
    
    self.timeBar.layer.cornerRadius = 17;
    self.timeBar.layer.masksToBounds = YES;
    
    self.timeBarClock.layer.cornerRadius = 27;
    self.timeBarClock.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startGame {
    
    
    QStack *qstack = [QStack sharedQStack];
    
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
    
    NSDictionary * gameInfo = data[@"payload" ];
    
    if ([type isEqual: @"sendQuestion"]){
        
        self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.questionLabel.numberOfLines = 0;
        self.currentSumbittedAnswer = -1;

        
        //set current question number && submit allowance
        self.currentQuestionNumber = [gameInfo[@"questionNum"] intValue];
        self.isAllowSubmit = YES;
        
        NSString * s = [self fixString:gameInfo[@"question"]];
        
        [self.questionLabel setText:[NSString stringWithFormat:@"%@",s]];
        
        //set timer
        self.time = 5;
        self.timeNow = [NSNumber numberWithDouble:self.time];
        [self.timeBarClock setText:[NSString stringWithFormat:@"%ld",(long)self.time]];

        
        //game answers
        NSArray *receivedAnswers = gameInfo[@"answers"];
        
        for(UIButton *btn in self.answers){
            //reset button color
            NSInteger index = [self.answers indexOfObject:btn];
            NSString *s = receivedAnswers[index];
            [btn setTitle:s forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
        }
        //control time delay for answer display
        double delayInSeconds = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //start timer
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
        
        //stop timer
        [self.timeBarTimer invalidate];
        self.timeBarTimer = nil;
        
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
        
        [self.questionLabel setText:@"Game Over"];
        
        for(UIButton *btn in self.answers){
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
        }
        [self.timeBar setBackgroundColor:[UIColor clearColor]];
    }
    
}

// for time bar
- (void)startTimer:(NSTimer *)timer{
    
    double tempTimeNow = [self.timeNow doubleValue] - 0.05;
    
    self.timeNow = [NSNumber numberWithDouble:tempTimeNow];
    
    [self.timeBarClock setText:[NSString stringWithFormat:@"%i",(int)tempTimeNow]];
    
    CGRect newRect = self.timeBar.frame;
    
    double ratio = 1.0 * (self.time - tempTimeNow)/self.time;
    
    newRect.origin.x = ratio * (self.timeBarView.frame.size.width - self.timeBarClock.frame.size.width) / 2;
    
    newRect.size.width = self.timeBarView.frame.size.width - 2* newRect.origin.x;
    
    [self.timeBar setFrame:newRect];
    
}


- (NSString *)fixString:(NSString *)neededFixString
{
    NSString* s = [neededFixString stringByReplacingOccurrencesOfString:@"<q>" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"<a>" withString:@"\'"];
    
    return s;
}

- (IBAction)chooseAnswer:(id)sender {
    
    if (self.isAllowSubmit) {
        
        NSInteger index = [self.answers indexOfObject:sender];
        //record current submitted answer
        self.currentSumbittedAnswer = index;
        
        self.isAllowSubmit = NO;
        
        //stop timer
        [self.timeBarTimer invalidate];
        self.timeBarTimer = nil;
        
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

@end
