//
//  TraditionalTableCellViewTableViewCell.h
//  TestStoryBoard
//
//  Created by 谢乾坤 on 2/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraditionalTableCellViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tournamentName;
@property (weak, nonatomic) IBOutlet UILabel *tournamentStyle;
@property (weak, nonatomic) IBOutlet UILabel *tournamentCategory;
@property (weak, nonatomic) IBOutlet UILabel *tournamentQuestionNum;

@end
