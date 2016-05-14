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
    
    var currentUser: triviaUser!

    // User Info
    @IBOutlet weak var nameLabelUp: UILabel!
    @IBOutlet weak var nameLabelDown: UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var badgeLabel:UILabel!
    @IBOutlet weak var friendsNumberLabel:UILabel!
    
    // User avatar
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Round Backgound
    @IBOutlet weak var statusBackground: UIView!
    @IBOutlet weak var statisticsBackground: UIView!
    @IBOutlet weak var activityBackground: UIView!
    @IBOutlet weak var achievementsBackground: UIView!
    // will change when view other people's profile
    @IBOutlet weak var addFriendBackground: UIView!
    @IBOutlet weak var chatBackground: UIView!
    
    //labels
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statisticsLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var achievementsLabel: UILabel!
    // will change when view other people's profile
    @IBOutlet weak var addFriendLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
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
        
        // Do any additional setup after loading the view.
        currentSelectedButton = statisticsButton
        currentSelectedButton.enabled = false
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setCurrentUserInfo()
        
        //setupRoundBackgrounds()
        setupLabelStrokes()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImageView.layer.borderWidth = 4
        self.profileImageView.layer.borderColor = kProfileCellBackgroundColor.CGColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.profileImageView.layer.masksToBounds = true
        
    }
    
    func setCurrentUserInfo() {

        if let name = currentUser.displayName {
            let strokeTextAttributes = [
                NSStrokeColorAttributeName : kProfileCellBackgroundColor,
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSStrokeWidthAttributeName : -3.0
            ]
            nameLabelUp.adjustsFontSizeToFitWidth = true
            nameLabelDown.adjustsFontSizeToFitWidth = true
            
            nameLabelUp.attributedText = NSAttributedString(string: name, attributes: strokeTextAttributes)
            nameLabelDown.attributedText = NSAttributedString(string: name, attributes: strokeTextAttributes)
        }
        
        if let friends = currentUser.friends {
            friendsNumberLabel.text = "Friends: \(friends.count)"
        }
        if let location = currentUser.location {
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
    
    // Make round corner
    func setupRoundBackgrounds() {
        
        setupBackground(statusBackground)
        setupBackground(statisticsBackground)
        setupBackground(activityBackground)
        setupBackground(achievementsBackground)
        setupBackground(addFriendBackground)
        setupBackground(chatBackground)
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
        setupLabelStroke(addFriendLabel, str: "ADD FRIEND")
        setupLabelStroke(chatLabel, str: "CHAT")
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






















