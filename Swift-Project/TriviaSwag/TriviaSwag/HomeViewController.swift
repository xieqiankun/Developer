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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackground()
        setupContainer()
        
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
    
    // Not use
    func addConstrains(aView: UIView) {
    
        let topContraint = NSLayoutConstraint(item: aView, attribute: .Top, relatedBy: .Equal, toItem: aView.superview!, attribute: .Top, multiplier: 1, constant: 0)
        let leftContraint = NSLayoutConstraint(item: aView, attribute: .Leading, relatedBy: .Equal, toItem: aView.superview!, attribute: .Leading, multiplier: 1, constant: 0)
        let rightContraint = NSLayoutConstraint(item: aView, attribute: .Width, relatedBy: .Equal, toItem: aView.superview!, attribute: .Width, multiplier: 1, constant: 0)
        let downContraint = NSLayoutConstraint(item: aView, attribute: .Height, relatedBy: .Equal, toItem: aView.superview!, attribute: .Height, multiplier: 1, constant: 0)
        
        aView.superview!.addConstraints([topContraint,leftContraint,rightContraint,downContraint])
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
    
    // Not use for now
    func setContainerView()
    {
        tableContainerView.layer.borderColor = UIColor.whiteColor().CGColor
        tableContainerView.layer.cornerRadius = 8
        tableContainerView.layer.masksToBounds = true
        tableContainerView.layer.borderWidth = 2.0
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.

        
        
     }
    
    
}
