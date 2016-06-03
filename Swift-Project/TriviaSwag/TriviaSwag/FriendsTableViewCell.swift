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
    
    @IBOutlet weak var badge: CustomBadge!
    
    @IBOutlet weak var userinfoStack: UIStackView!
    weak var delegate: ShowProfile?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initFriendCell()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(FriendsTableViewCell.tap))
        gesture.delegate = self
        userinfoStack.addGestureRecognizer(gesture)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        content.backgroundColor = kFriendListBackgroundColor
        onlineLabel.hidden = true
        badge.hidden = true
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
        badge.hidden = true
    }
    
    func configueCell(item:ListMessageBean) {
    
        let attributes = [NSStrokeColorAttributeName: kFriendListBorderColor,
                          NSStrokeWidthAttributeName : -3.0,
                          NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let str = NSAttributedString(string: item.displayName!, attributes: attributes)
        friendName.attributedText = str
        
        if item.isOnline{
            onlineLabel.hidden = false
        }
        if item.newMessageNumber != 0 {
            badge.hidden = false
            if item.newMessageNumber < 10 {
                badge.text = String(item.newMessageNumber)
            } else {
                badge.text = "..."
            }
            content.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    
    func tap() {
        delegate?.showProfile(friendName.text!)
    }
    
    
}












