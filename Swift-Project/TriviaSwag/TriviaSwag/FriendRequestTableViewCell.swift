//
//  FriendRequestTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

@objc protocol ShowProfile {
    func showProfile(name: String)
}

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendRegion: UILabel!
    @IBOutlet weak var badge: CustomBadge!
    
    @IBOutlet weak var userinfoStack: UIStackView!
    weak var delegate: ShowProfile?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initFriendRequestCell()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(FriendRequestTableViewCell.tap))
        gesture.delegate = self
        userinfoStack.addGestureRecognizer(gesture)
        
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

    var request: triviaFriendRequest?
    
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
        request = item.friendRequest
    }
    
    func tap() {
        delegate?.showProfile(friendName.text!)
    }
    
    @IBAction func accept() {
        if let request = request {
            triviaAnswerFriendRequest(request, accept: true, completion: { (error, updatedFriends, updateUserInbox) in
                
            })
        }
    }
    
    @IBAction func ignore() {
        
        if let request = request {
            triviaAnswerFriendRequest(request, accept: false, completion: { (error, updatedFriends, updateUserInbox) in
                
            })
        }
        
    }
    
}










