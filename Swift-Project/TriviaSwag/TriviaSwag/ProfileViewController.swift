//
//  ProfileViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/2/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kProfileCellBackgroundColor =  UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)
let kProfileLabelStrokeColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)


class ProfileViewController: UIViewController {
    
    var userName: String!

    var isLogin:Bool {
        return triviaCurrentUser != nil
    }
    
    var isMyProfile: Bool {
        return isLogin && triviaCurrentUser!.displayName! == userName
    }
    
    var user: triviaUser? {
        didSet{
            dispatch_async(dispatch_get_main_queue()) {
                self.setCurrentUserInfo()
            }
        }
    }
    
    enum UserStatus{
        case Friend, Pending, Nonfriend
    }
    
    var userStatus = UserStatus.Nonfriend {
        didSet{
            // only update userInfo when user already been set
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateAddFriendBtn()
                }
            }
        }
    }
    
    // User Info
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var badgeLabel:UILabel!
    @IBOutlet weak var friendsNumberLabel:UILabel!
    
    // User avatar
    @IBOutlet weak var profileImageView: UIImageView!
    
    // place holder views
    @IBOutlet weak var statusBackground: UIView!
    @IBOutlet weak var statisticsBackground: UIView!
    @IBOutlet weak var activityBackground: UIView!
    @IBOutlet weak var achievementsBackground: UIView!
    @IBOutlet weak var addFriendStack: UIStackView!
    
    //labels
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statisticsLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var achievementsLabel: UILabel!
    // will change when view other people's profile
//    @IBOutlet weak var addFriendLabel: UILabel!
//    @IBOutlet weak var chatLabel: UILabel!
//    
    //buttons
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var achievementsButton: UIButton!
    // will change when view other people's profile
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    //Status Variable
    //Only for last three
    var currentSelectedButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        modalPresentationStyle = .Custom
        transitioningDelegate = self

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        setupLabelStrokes()

        
        if isMyProfile {
            addFriendStack.removeFromSuperview()
            user = triviaCurrentUser
        } else {
            // Not able to hide this before fetching user's data
            //statusBackground.removeFromSuperview()
            if !isLogin {
                addFriendStack.removeFromSuperview()
            } else {
                // set add friend button label
                setUserStatus()
                updateAddFriendBtn()
            }
            triviaFetchProfileForDisplayName(userName, completion: {[weak self] (user, error) in
                if let strongSelf = self {
                    print(user?.displayName)
                    strongSelf.user = user
                }
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.refresh), name: triviaDidUpdateFriendsNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.refresh), name: triviaUpdateInboxNotificationName, object: nil)
        
        // Do any additional setup after loading the view.
        currentSelectedButton = statisticsButton
        currentSelectedButton.enabled = false
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refresh() {
        
        setUserStatus()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setupRoundBackgrounds()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImageView.layer.borderWidth = 4
        self.profileImageView.layer.borderColor = kProfileCellBackgroundColor.CGColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.profileImageView.layer.masksToBounds = true
    }
    
    func setCurrentUserInfo() {
//        print("Setting user info")
//        print(user?.friends?.count)
        if let name = user!.displayName {
            let strokeTextAttributes = [
                NSStrokeColorAttributeName : kProfileCellBackgroundColor,
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSStrokeWidthAttributeName : -3.0
            ]
            nameLabel.adjustsFontSizeToFitWidth = true
            
            nameLabel.attributedText = NSAttributedString(string: name, attributes: strokeTextAttributes)
        }
        
        if let friends = user!.friends {
            friendsNumberLabel.text = "Friends: \(friends.count)"
        }
        if let location = user!.location {
            var country: String = ""
            var region: String = ""
            if let _ = location.country{
                country = location.country!
            }
            if let _ = location.region{
                region = location.region!
            }
            locationLabel.text = country + ", " + region
        }
        
    }
    
    // verify the user status
    func setUserStatus() {

        if let inbox = triviaCurrentUserInbox {
            if inbox.isSentFriendRequestToUser(self.userName) {
                userStatus = .Pending
                return
            }
        }
        
        if let me = triviaCurrentUser {
            if me.isFriendOfCurrentUser(self.userName){
                userStatus = .Friend
                return
            }
        }
        userStatus = .Nonfriend
    }
    
    // use user status to update friend btn
    func updateAddFriendBtn() {
        switch userStatus {
        case .Friend:
            if let image = UIImage(named: "UnfriendButton-Untouched") {
                addFriendButton.setImage(image, forState: .Normal)
            }
            if let image = UIImage(named: "UnfriendButton-Touched") {
                addFriendButton.setImage(image, forState: .Highlighted)
            }
        case .Pending:
            if let image = UIImage(named: "PendingButton") {
                addFriendButton.setImage(image, forState: .Disabled)
                addFriendButton.enabled = false
            }
        default:
            break
        }
        
        
    }
    
    // MARK: - Init set
    // Set round corner
    func setupRoundBackgrounds() {
        
        setupBackground(statusBackground)
        setupBackground(statisticsBackground)
        setupBackground(activityBackground)
        setupBackground(achievementsBackground)
    }
    
    func setupBackground(aView: UIView) {
        
        aView.backgroundColor = kProfileCellBackgroundColor
        aView.layer.cornerRadius = aView.frame.size.height/2
        aView.layer.masksToBounds = true
    }
    
    // Set Labels
    func setupLabelStrokes() {
        
        setupLabelStroke(statusLabel, str: "I am QiankunXie")
        setupLabelStroke(statisticsLabel, str: "STATISTICS")
        setupLabelStroke(activityLabel, str: "ACTIVITY")
        setupLabelStroke(achievementsLabel, str: "ACHIEVEMENTS")
        //TODO: -- May Change
//        setupLabelStroke(addFriendLabel, str: "ADD FRIEND")
//        setupLabelStroke(chatLabel, str: "CHAT")
    }
    
    func setupLabelStroke(aLabel: UILabel, str: String) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : kProfileLabelStrokeColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0
        ]
        aLabel.attributedText = NSAttributedString(string: str, attributes: strokeTextAttributes)
        aLabel.adjustsFontSizeToFitWidth = true
        aLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    // MARK: - IBAction
    
    @IBAction func addFriendAction() {
        
        switch userStatus {
        case .Friend:
            triviaUnfriend(userName, completion: { [weak self](error, updatedFriends) in
                if let strongSelf = self {
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        case .Nonfriend:
            triviaRequestFriend(userName, completion: { (error, newInbox) in
                
            })
        default:
            break
        }
        
        
    }
    
    // Last three button selected action
    @IBAction func selectStatisticsButton(sender: UIButton) {
        changeButtonStatus(sender)
        
    }
    @IBAction func selectActivityButton(sender: UIButton) {
        changeButtonStatus(sender)
        
    }
    @IBAction func selectAchievementsButton(sender: UIButton) {
        changeButtonStatus(sender)
        
    }
    
    
    func changeButtonStatus(btn: UIButton) {
        
        if let image1 = UIImage(named: "BigButtonUnselectedUntouched"){
            currentSelectedButton.setImage(image1, forState: .Normal)
            currentSelectedButton.enabled = true
            currentSelectedButton = btn
        }
        
        if let image = UIImage(named: "BigButtonSelectedUntouched"){
            btn.setImage(image, forState: .Normal)
            btn.enabled = false
        }
        
        
    }
    
    @IBAction func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// Custom Transitioning Delegate
extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController( presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {

        return DimmingPresentationController( presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController( presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadeInAnimationController()
    }
    
    func animationControllerForDismissedController( dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutAnimationController()
    }
    
}






















