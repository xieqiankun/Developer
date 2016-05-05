//
//  LeaderboardTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kLeaderboardBorderColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)
let kLeaderboardBackgroundColor = UIColor(red: 213/255, green: 220/255, blue: 32/255, alpha: 1)

enum LeaderboardLabels: String {
    case nameLabel, rankLabel, timeLabel
}

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    // TODO: --
    @IBOutlet weak var avatar: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = kLeaderboardBackgroundColor
        self.contentView.layer.cornerRadius = contentView.frame.height / 3
        self.contentView.clipsToBounds = true
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = kLeaderboardBorderColor.CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLabels(dictionary: [LeaderboardLabels: String]) {
        
        for (item, str) in dictionary {
            switch item {
            case .nameLabel:
                setupLabel(str, label: nameLabel)
            case .rankLabel:
                setupLabel(str, label: rankLabel)
            case .timeLabel:
                setupLabel(str, label: timeLabel)
            }
            
            
        }
        
    }

    func setupLabel(text: String, label: UILabel) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : kLeaderboardBorderColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0
        ]
        label.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
        label.adjustsFontSizeToFitWidth = true
        
    }
}
