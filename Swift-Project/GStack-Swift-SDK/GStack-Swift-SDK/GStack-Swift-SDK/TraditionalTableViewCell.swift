//
//  TraditionalTableViewCell.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TraditionalTableViewCell: UITableViewCell {
    
    
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

}
