//
//  TournamentTableViewController.m
//  GStack-ObjectiveC-SDK
//
//  Created by 谢乾坤 on 2/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "TournamentTableViewController.h"
#import "PlayGameViewController.h"
#import "QStack.h"

@interface TournamentTableViewController ()

@end

@implementation TournamentTableViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.navigationItem.title = @"My Tournaments";
        
        QStack *qstack = [QStack sharedQStack];
        
        [qstack getTournaments:^(NSError *error, NSData *data) {
            if(!error){
                
                NSArray *temp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"Got tournaments");
                qstack.myTournaments = temp;
                
                NSLog(@"%@",temp);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }
        }];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[QStack sharedQStack] myTournaments] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.textLabel.text = [[QStack sharedQStack] myTournaments][indexPath.row][@"name"];
    
    cell.detailTextLabel.text = [[QStack sharedQStack] myTournaments][indexPath.row][@"style"];
    
    
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayGameViewController *pvc = [[PlayGameViewController alloc] init];
    
    pvc.uuid = [[QStack sharedQStack] myTournaments][indexPath.row][@"uuid"];
    
    NSLog(@"uuid :%@", pvc.uuid);
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:pvc
                                         animated:YES];
}


@end
