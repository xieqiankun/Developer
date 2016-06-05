//
//  HomeViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var topbarContainerView: UIView!
    
    @IBOutlet weak var leaderboardViewContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var tourneyTalkViewContainer: UIView!
    
    var reachability: Reachability?
    
    deinit{
        reachability?.stopNotifier()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the reachability checker
        
        self.addBackground()
        setupContainer()
        setupNetworkChecker()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        print("view did appear")
       // self.addBackground()
    }
    
    func setupContainer(){
        
        self.leaderboardViewContainer.hidden = false
        self.mapViewContainer.hidden = true
        self.tourneyTalkViewContainer.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "Background.png")
        
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
        // For Detail Tournament View
        let detailWidth = detailContainerView.frame.width
        let detailHeight = detailContainerView.frame.height
        
        let detailImageViewBackground = UIImageView(frame: CGRectMake(0, 0, detailWidth, detailHeight))
        detailImageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        detailImageViewBackground.image = UIImage(named: "TournamentInfoBackground.png")
        
        detailContainerView.addSubview(detailImageViewBackground)
        detailContainerView.sendSubviewToBack(detailImageViewBackground)
        detailImageViewBackground.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // For table container
        let tableWidth = tableContainerView.bounds.size.width
        let tableHeight = tableContainerView.bounds.size.height
        
        let tableImageViewBackground = UIImageView(frame: CGRectMake(0, 0, tableWidth, tableHeight))
        tableImageViewBackground.image = UIImage(named: "TournamentListBackground.png")
        tableImageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        
        tableContainerView.addSubview(tableImageViewBackground)
        tableContainerView.sendSubviewToBack(tableImageViewBackground)
        tableImageViewBackground.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        
        // For Top Bar View
        let topbarWidth = topbarContainerView.bounds.size.width
        let topbarHeight = topbarContainerView.bounds.size.height
        
        let topbarImageViewBackground = UIImageView(frame: CGRectMake(0, 0, topbarWidth, topbarHeight))
        topbarImageViewBackground.image = UIImage(named: "TopBar.png")
        topbarImageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        
        topbarContainerView.addSubview(topbarImageViewBackground)
        topbarContainerView.sendSubviewToBack(topbarImageViewBackground)
        topbarImageViewBackground.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
    }
    
    
    @IBAction func segementIndexChanged(sender: SegementedControlUI) {
        
        switch sender.selectedIndex {
        case 0:
            self.leaderboardViewContainer.hidden = false
            self.mapViewContainer.hidden = true
            self.tourneyTalkViewContainer.hidden = true
        case 1:
            self.leaderboardViewContainer.hidden = true
            self.mapViewContainer.hidden = false
            self.tourneyTalkViewContainer.hidden = true
        case 2:
            self.leaderboardViewContainer.hidden = true
            self.mapViewContainer.hidden = true
            self.tourneyTalkViewContainer.hidden = false
        default:
            break
        }
    }
    
    struct Fahrenheit {
        var temperature: Double = 32.0
        var m: Int = 5

    }
    
    // Not use
    func addConstrains(aView: UIView) {
        
        let topContraint = NSLayoutConstraint(item: aView, attribute: .Top, relatedBy: .Equal, toItem: aView.superview!, attribute: .Top, multiplier: 1, constant: 0)
        let leftContraint = NSLayoutConstraint(item: aView, attribute: .Leading, relatedBy: .Equal, toItem: aView.superview!, attribute: .Leading, multiplier: 1, constant: 0)
        let rightContraint = NSLayoutConstraint(item: aView, attribute: .Width, relatedBy: .Equal, toItem: aView.superview!, attribute: .Width, multiplier: 1, constant: 0)
        let downContraint = NSLayoutConstraint(item: aView, attribute: .Height, relatedBy: .Equal, toItem: aView.superview!, attribute: .Height, multiplier: 1, constant: 0)
        
        aView.superview!.addConstraints([topContraint,leftContraint,rightContraint,downContraint])
    }
    
    // Not use for now
    func setContainerView()
    {
        tableContainerView.layer.borderColor = UIColor.whiteColor().CGColor
        tableContainerView.layer.cornerRadius = 8
        tableContainerView.layer.masksToBounds = true
        tableContainerView.layer.borderWidth = 2.0
        
    }
    @IBAction func backToMain(segue: UIStoryboardSegue)
    {
    }
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
     }

}

extension HomeViewController {
    
    // network checking
    func setupNetworkChecker() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            reachability!.whenUnreachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    let button = AlertButton(title: "", imageNames: [], style: .Cancel,action: nil)
                    
                    let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button], title: "No Connection!", message: "You should check your internet connection!")
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            }
            reachability!.whenReachable = {
                reachability in
                
                if gStackCachedTournaments.count == 0 {
                    
                    if gStackAppIDToken == nil {
                        gStackLoginWithAppID() { (error) -> Void in
                            gStackFetchTournaments({
                                error, _ in
                                if error != nil {
                                    print("Error fetching tournaments: \(error!)")
                                } else {
                                    
                                }
                            })
                        }
                    } else {
                        gStackFetchTournaments({
                            error, _ in
                            if error != nil {
                                print("Error fetching tournaments: \(error!)")
                            } else {
                                
                            }
                        })
                    }
                }
            }
            do {
                try reachability!.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
        } catch {
            print("Unable to create Reachability")
            
        }
    }

    
    
}

