//
//  PlayBracketiewController.m
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "PlayBracketiewController.h"
#import "NameBoardView.h"
#import "QStack.h"

@interface PlayBracketiewController ()


@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerOne;
@property (weak, nonatomic) IBOutlet UILabel *playerTwo;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answers;

@property (strong, nonatomic) NSMutableArray *teamNames;

@property (nonatomic) BOOL isAllowSubmit;

@property (nonatomic) NSInteger currentQuestionNumber;

@end

@implementation PlayBracketiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UIButton *btn in self.answers) {
        btn.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startGame:(id)sender {
    
    self.startBtn.hidden = YES;
    
    QStack *qstack = [QStack sharedQStack];
    
    NSLog(@"uuid::::: %@",self.uuid);
    
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
        
        //self.teamNames = data[@"payload"][@"teamNames"];
        
        NSMutableArray * ans = [[NSMutableArray alloc] init];
        
        for(NSArray *array in data[@"payload"][@"teamNames"]){
            
            [ans addObject:array[0]];
        }
        self.teamNames = ans;
        
        //NSLog(@"teamNames : %@", self.teamNames);
        
    }
    
}

- (void) setPlayersName:(NSArray *)nameList
{
    
    
    
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
