//
//  ProfileViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/14/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var displayName = ""
    var user: triviaUser?

    @IBOutlet var profileInformationView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var numberOfGamesLabel: UILabel!
    @IBOutlet var numberOfFriendsLabel: UILabel!
    @IBOutlet var addFriendButton: UIButton!
    @IBOutlet var profileDescriptionLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var informationTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshData() {
        triviaFetchProfileForDisplayName(displayName, completion: {
            _user, error in
            if error != nil {
                print("Error fetching profile: \(error!)")
            } else {
                self.user = _user
                dispatch_async(dispatch_get_main_queue(), {
                    self.configureProfileElements()
                })
            }
        })
    }
    
    func configureProfileElements() {
        if user != nil {
            if displayName == triviaCurrentUser?.displayName {
                navigationItem.rightBarButtonItem = nil
                addFriendButton.hidden = true
            }
            
            let fullAvatarString = user!.avatar!
            let shortenedAvatarString = fullAvatarString.substringFromIndex(fullAvatarString.startIndex.advancedBy(5))
            avatarImageView.image = UIImage(named: shortenedAvatarString)
            
            displayNameLabel.text = user!.displayName
            navigationItem.title = user!.displayName
            
            if let location = user?.location {
                if let country = location.country {
                    if country != "United States" {
                        locationLabel.text = country
                    }
                    else {
                        if let region = location.region {
                            locationLabel.text = "\(region), US"
                        } else {
                            locationLabel.text = country
                        }
                    }
                }
                else {
                    locationLabel.text = "??"
                }
            }
            else {
                locationLabel.text = "??"
            }
            
            //Status label
            
            //Status image
            
            if let gamesPlayed = user!.gamesPlayed {
                numberOfGamesLabel.text = gamesPlayed.stringValue
            } else {
                numberOfGamesLabel.text = "0'"
            }
            
            if let friends = user!.friends {
                numberOfFriendsLabel.text = String(friends.count)
            }
            else {
                numberOfFriendsLabel.text = "0"
            }
            
            if let status = user!.status {
                profileDescriptionLabel.text = status
            }
            else {
                profileDescriptionLabel.text = ""
            }
        }
    }
}
