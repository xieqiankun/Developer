//
//  TournamentDescriptionViewController.swift
//  TriviaSwag
//
//  Created by Jared Eisenberg on 6/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TournamentDescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tournament: gStackTournament?
    
    @IBOutlet weak var tourneyName: UILabel!
    @IBOutlet weak var prizeTable: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
        
    }
    
    override func viewDidLoad() {
        if let tourney = tournament{
            tourneyName.text = tourney.name!
            prizeTable.delegate = self
            prizeTable.dataSource = self
        }
        closeButton.setImage(UIImage(named: "Close-Big"), forState: .Normal)
        closeButton.setImage(UIImage(named: "Close-Small"), forState: .Highlighted)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let tourney = tournament{
            if let _ = tourney.info{
                return 2
            }
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tourney = tournament{
            if let _ = tourney.info{
                if (section == 0){
                    return 1
                }
            }
            return tourney.prizes!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let tourney = tournament{
            if (indexPath.section == 1 || tableView.numberOfSections == 1){
                let cell = tableView.dequeueReusableCellWithIdentifier("PrizeCell") as! PrizeCell
                cell.prizeNum.text = String(indexPath.row + 1)
                cell.prize = tourney.prizes![indexPath.row]
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell") as! InfoCell
                cell.infoBody.text = tourney.info!
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    @IBAction func close(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInView(self.view)
        
        if (!mainView.pointInside(touchLocation, withEvent: nil)){
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "EnlargeImage"){
            let dest = segue.destinationViewController as! TournamentDetailImageViewController
            let butt = sender as! UIButton
            dest.pendingImg = butt.currentImage
        }
    }

    
}

extension TournamentDescriptionViewController: UIViewControllerTransitioningDelegate {
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