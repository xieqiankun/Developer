//
//  PrizeCell.swift
//  TriviaSwag
//
//  Created by Jared Eisenberg on 6/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class PrizeCell: UITableViewCell {

    
    @IBOutlet weak var prizeNum: UILabel!
    @IBOutlet weak var prizeName: UILabel!
    @IBOutlet weak var prizeImage: UIButton!
    
    var prize: gStackTournamentPrize!{
        didSet{

            prizeName.text = prize.name
            prizeImage.layer.cornerRadius = 7
            prizeImage.layer.borderColor = UIColor(red: 46.0/255, green: 29.0/255, blue: 141.0/255, alpha: 1).CGColor
            prizeImage.layer.borderWidth = 2
            if let i = prize.image{
                
                let imgURL = NSURL(string: i)
                let task = NSURLSession.sharedSession().dataTaskWithURL(imgURL!) {(responseData, responseUrl, error) -> Void in
                    
                    if let data = responseData{
                        dispatch_async(dispatch_get_main_queue(), { ()
                            let img = UIImage(data: data)
                            self.prizeImage.setImage(img, forState: UIControlState.Normal)
                            self.prizeImage.setImage(img, forState: .Highlighted)
                            self.prizeImage.setImage(img, forState: .Focused)
                        })
                    }
                }
                
                task.resume()

            }
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
