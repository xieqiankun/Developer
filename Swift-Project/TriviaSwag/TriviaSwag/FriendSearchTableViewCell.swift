//
//  FriendSearchTableViewCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class FriendSearchTableViewCell: UITableViewCell {
    
    enum UserStatus{
        case Friend, Pending, Nonfriend
    }

    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendRegion: UILabel!
    
    @IBOutlet weak var status: UIButton!
    
    var userStatus = UserStatus.Nonfriend
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initFriendCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initFriendCell() {
        content.backgroundColor = kFriendListBackgroundColor
        content.layer.cornerRadius = contentView.frame.height / 3
        content.clipsToBounds = true
        
        content.layer.borderWidth = 2
        content.layer.borderColor = kFriendListBorderColor.CGColor
        
        friendRegion.textColor = kFriendListBorderColor
    }
    
    
    func configureCell(user: triviaUser){
        
        friendName.text = user.displayName
        setUserStatus(user.displayName!)
        
        switch userStatus {
        case .Friend:
            status.enabled = false
            status.setImage(UIImage(named:"Friended2"), forState: .Disabled)
        case .Nonfriend:
            status.enabled = true
            status.setImage(UIImage(named:"AddFriends-Untouched"), forState: .Normal)
            status.setImage(UIImage(named:"AddFriends-Touched"), forState: .Highlighted)
        case .Pending:
            status.enabled = false
            status.setImage(UIImage(named:"Pending2"), forState: .Disabled)
        }
    }
    
    
    func setUserStatus(displayName: String){
        
        if let friends = triviaCurrentUser?.friends{
            
            for friend in friends {
                if friend.displayName == displayName{
                    userStatus = .Friend
                    return
                }
            }
        }
        if let requests = triviaCurrentUserInbox?.friendRequests{
            for request in requests{
                // TODO: -
                //if request.
            }
        }
        
    }
    
    
    @IBAction func addFriend() {
        
        if userStatus == .Nonfriend{
            triviaRequestFriend(friendName.text!, completion: { (error, newInbox) in
                
            })
        }
    }

}














