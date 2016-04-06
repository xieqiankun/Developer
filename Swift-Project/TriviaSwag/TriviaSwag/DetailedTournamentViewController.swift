//
//  DetailedTournamentViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/5/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class DetailedTournamentViewController: UIViewController {

    var tournamet: gStackTournament?
    
    @IBOutlet weak var tournamentNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedTournamentViewController.updateTournamentInfo(_:)), name: TournamentDidSelectNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedTournamentViewController.updateTournamentInfo(_:)), name: TournamentWillAppearNotificationName, object: nil)
        
        setCornerEdge()
        // Do any additional setup after loading the view.
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
            self.tournamet = temp
            
            self.tournamentNameLabel.text = self.tournamet?.name
        }
        
        

        
        
        
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
