//
//  LoginViewController.m
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "LoginViewController.h"
#import "TournamentTableViewController.h"
#import "QStack.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *appID;
@property (weak, nonatomic) IBOutlet UITextField *appKey;
@property (weak, nonatomic) IBOutlet UITextField *username;

@end

@implementation LoginViewController

- (instancetype) init
{
    self = [super init];
    if(self){
        self.navigationItem.title = @"User Login";
    }
    return self;
}
- (IBAction)loginBtn:(UIButton *)sender {
    
    //get QStack by Singleton method
    QStack *qstack = [QStack sharedQStack];
 
    //set the user information
    [qstack setUserInformation:@"yyy" withAvatar:@""];
    
    NSString *usernameField = @"308189542";//self.username.text;
    NSString *passwordField = @"/o3I3goKCQ==";// self.password.text;
    

    
    //initate qstack instance
    [qstack login:usernameField withKey:passwordField completionHandler:^(NSError *error) {
        if (!error){
            NSLog(@"Logged in");

            dispatch_async(dispatch_get_main_queue(),^{
                
            //if successed login, pop tournaments viewcontroller
            TournamentTableViewController * tvc = [[TournamentTableViewController alloc] initWithStyle:UITableViewStylePlain];
                
                
            //  NSLog(@"%@", self.navigationController);
            [self.navigationController pushViewController:tvc animated:YES];
            });
            
        }

    }];
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
