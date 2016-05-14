//
//  FriendsTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/12/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kFriendListBorderColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)
let kFriendListBackgroundColor = UIColor(red: 213/255, green: 220/255, blue: 32/255, alpha: 1)

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendRegion: UILabel!
    
    @IBOutlet weak var onlineLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initFriendCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        content.backgroundColor = kFriendListBackgroundColor
        onlineLabel.hidden = true

    }
    
    private func initFriendCell() {
        content.backgroundColor = kFriendListBackgroundColor
        content.layer.cornerRadius = contentView.frame.height / 3
        content.clipsToBounds = true
        
        content.layer.borderWidth = 2
        content.layer.borderColor = kFriendListBorderColor.CGColor
        

        friendRegion.textColor = kFriendListBorderColor
        onlineLabel.textColor = kFriendListBorderColor
        onlineLabel.hidden = true
    }
    
    func configueCell(friend:triviaFriend) {
    
        let attributes = [NSStrokeColorAttributeName: kFriendListBorderColor,
                          NSStrokeWidthAttributeName : -3.0,
                          NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let str = NSAttributedString(string: friend.displayName!, attributes: attributes)
        friendName.attributedText = str
        
        if friend.isOnline{
            onlineLabel.hidden = false
        }
        
    }
    
}












