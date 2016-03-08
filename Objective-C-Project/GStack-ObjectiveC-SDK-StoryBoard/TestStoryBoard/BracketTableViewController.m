//
//  BracketTableViewController.m
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "BracketTableViewController.h"
#import "PlayBracketiewController.h"
#import "BracketTableViewCell.h"
#import "QStack.h"

@interface BracketTableViewController ()

@property (strong, nonatomic) NSString *selectedUuid;

@end

@implementation BracketTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BracketTableCell";
    BracketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tournamet = [[QStack sharedQStack] myBracketT][indexPath.section];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.tournamentName.text = tournamet[@"name"];
    cell.tournamentStyle.text = tournamet[@"questions"][@"zone"];
    cell.tournamentCategory.text = tournamet[@"questions"][@"category"];
    cell.tournamentQuestionNum.text = [NSString stringWithFormat:@"%@ Questions",tournamet[@"questions"][@"num"]];
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
    [cell.contentView.layer setBorderWidth:2.0f];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[QStack sharedQStack] myBracketT] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"uuid ");
    
    self.selectedUuid = [[QStack sharedQStack] myBracketT][indexPath.row][@"uuid"];
    
    // Push it onto the top of the navigation controller's stack
    [self performSegueWithIdentifier:@"playBracket" sender:self];
    
    
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"playBracket"])
    {
        //if you need to pass data to the next controller do it here
        
        PlayBracketiewController *ptc = (PlayBracketiewController *)[segue destinationViewController];
        
        ptc.uuid = self.selectedUuid;
        
        NSLog(@"here %@", ptc.uuid);
    }
    
    
    
}

@end
