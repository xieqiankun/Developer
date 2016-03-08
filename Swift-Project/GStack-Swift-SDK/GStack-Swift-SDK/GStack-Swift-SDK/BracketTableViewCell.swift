//
//  BracketTableViewCell.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class BracketTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var tournamentName: UILabel!
    
    @IBOutlet weak var tournamentStyle: UILabel!
    
    @IBOutlet weak var tournamentCategory: UILabel!
    
    @IBOutlet weak var tournamentQuestionNum: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /*
    override func layoutSubviews() {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - 30, self.bounds.size.height)
        super.layoutSubviews()
    }
*/
}
