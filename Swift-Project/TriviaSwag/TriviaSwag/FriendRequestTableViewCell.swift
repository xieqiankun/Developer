//
//  FriendRequestTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendRegion: UILabel!
    
    
    @IBOutlet weak var badge: CustomBadge!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initFriendRequestCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        badge.hidden = true
    }
    
    private func initFriendRequestCell() {
        content.backgroundColor = UIColor.whiteColor()
        content.layer.cornerRadius = contentView.frame.height / 3
        content.clipsToBounds = true
        
        content.layer.borderWidth = 2
        content.layer.borderColor = kFriendListBorderColor.CGColor
        
        friendRegion.textColor = kFriendListBorderColor
        badge.hidden = true
    }

    func configueCell(item:ListMessageBean) {
        
        let attributes = [NSStrokeColorAttributeName: kFriendListBorderColor,
                          NSStrokeWidthAttributeName : -3.0,
                          NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let str = NSAttributedString(string: item.friendRequest!.sender!, attributes: attributes)
        friendName.attributedText = str

        if item.newMessageNumber != 0 {
            badge.hidden = false
            if item.newMessageNumber < 10 {
                badge.text = String(item.newMessageNumber)
            } else {
                badge.text = "..."
            }
        }
        
    }


}
