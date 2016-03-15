//
//  ItemCell.swift
//  Homeowner
//
//  Created by 谢乾坤 on 3/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        let labelFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = labelFont
        valueLabel.font = labelFont
        
        serialNumberLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    }

}
