//
//  DetailedTournamentViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/5/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class DetailedTournamentViewController: UIViewController {

    var tournament: gStackTournament?
    
    @IBOutlet weak var tournamentNameLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedTournamentViewController.updateTournamentInfo(_:)), name: TournamentDidSelectNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedTournamentViewController.updateTournamentInfo(_:)), name: TournamentWillAppearNotificationName, object: nil)
        
        setCornerEdge()
        // Do any additional setup after loading the view.
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        //call here to change the background
        setBackground("Tournament-Image-Placeholder")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground(name:String) {
        
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: name)
        // Change
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        imageViewBackground.alpha = 0.5
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        imageViewBackground.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
    }
    
    func setCornerEdge(){
        
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2.0
        
    }
    
    
    // Update the UI with new Tournament
    func updateTournamentInfo(notification: NSNotification) {
        
        if let info = notification.userInfo {
            let temp = info["currentTournament"] as! gStackTournament
            self.tournament = temp
            
            self.tournamentNameLabel.text = self.tournament?.name
            if self.tournament?.status() == gStackTournamentStatus.Active {
                self.startBtn.hidden = false
            } else {
                self.startBtn.hidden = true
            }
        }
        
    }
    

    @IBAction func startToPlayGame(sender: UIButton) {
        
        prepareTStartTheGame()
        

    }
    
    func prepareTStartTheGame(){
        
        SimplePingClient.pingHost { latency in
            print("latency is: \(latency)")
            
            if let lat = latency {
                let num = Int(lat)
                // set the max delay to 3 seconds
                if num <= 3000 {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.performSegueWithIdentifier("GamePlaySegue", sender: self)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let button1 = AlertButton(title: "", imageNames: ["PlayNowButton-Untouched","PlayNowButton-Touched"], style: .Custom,action: {
                            self.performSegueWithIdentifier("GamePlaySegue", sender: self)
                        })
                        let button2 = AlertButton(title: "", imageNames: [], style: .Cancel, action: nil)
                        let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button1,button2], title: "Slimmy Internet!", message: "Are you sure you want to play?")
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GamePlaySegue" {
            
            let vc = segue.destinationViewController as! GameViewController
            vc.currentTournament = self.tournament
            print("I am in segue \(vc.currentTournament?.name)")
        }
        
        
    }
    

}
