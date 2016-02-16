//
//  PlayGameViewController.m
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/15/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PlayGameViewController.h"
#import "QStack.h"

@interface PlayGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *startGameBtn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answers;

//@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentQuestionNumber;
@property (nonatomic) BOOL isAllowSubmit;


@end

@implementation PlayGameViewController


- (IBAction)startGame:(id)sender {
    
    self.startGameBtn.hidden = YES;
    
    QStack *qstack = [QStack sharedQStack];
    
    [qstack connectGameServer:self.uuid completionHandler:^(NSError *error) {
        if (!error){
            NSLog(@"start loading data");
            [qstack startSocket:^(NSDictionary *data) {
                
                NSString* type = data[@"type"];
                
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
                
            }];
        }
    }];
}

- (NSString *)fixString:(NSString *)neededFixString
{
    NSString* s = [neededFixString stringByReplacingOccurrencesOfString:@"<q>" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"<a>" withString:@"\'"];
    
    return s;
}

// not used
- (void) delayStartGame
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //[self start];
    });
}


- (IBAction)chooseAnswer:(id)sender {
    
  //  NSString * timestamp;
    
    if (self.isAllowSubmit) {
        
        NSInteger index = [self.answers indexOfObject:sender];
        
        self.isAllowSubmit = NO;
        
        NSDictionary* answer = @{
                                 @"questionNum" : [NSString stringWithFormat:@"%lu",self.currentQuestionNumber],
                                 @"answer" : [NSString stringWithFormat:@"%lu",index],
                                 @"time" : @""
                                 };
        [sender setBackgroundColor:[UIColor blueColor]];
        [[QStack sharedQStack] submitAnswer:answer];

    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[QStack sharedQStack] endSocket];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    for (UIButton *btn in self.answers) {
        btn.hidden = YES;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
