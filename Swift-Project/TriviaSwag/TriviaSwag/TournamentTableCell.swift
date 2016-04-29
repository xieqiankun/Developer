//
//  TournamentTableCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation


class TournamentTableViewCell: UITableViewCell {
    
    //For UI
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var prizeImageView: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    
    var backgroundImageView: UIImageView?
    
    func changeColorWhenSelect(){
        let view = tableCellView.subviews[0] as! UIImageView
        view.image = UIImage(named: "TournamentItemTouched.png")
        
    }
    
    func changeCorlorWhenDeselect(){
        let view = tableCellView.subviews[0] as! UIImageView
        view.image = UIImage(named: "TournamentItemUntouched.png")
    }
    
    func setupCellBackground(){
        
        if backgroundImageView != nil{
            backgroundImageView?.removeFromSuperview()
        }
        
        let tableWidth = tableCellView.bounds.size.width
        let tableHeight = tableCellView.bounds.size.height
        
        let tableImageViewBackground = UIImageView(frame: CGRectMake(0, 0, tableWidth, tableHeight))
        tableImageViewBackground.image = UIImage(named: "TournamentItemUntouched.png")
        tableImageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView = tableImageViewBackground
        
        tableCellView.addSubview(tableImageViewBackground)
        tableCellView.sendSubviewToBack(tableImageViewBackground)
        
    }
    
    func setRoundCorner(){
        
        prizeImageView.layer.borderColor = UIColor.whiteColor().CGColor
        prizeImageView.layer.cornerRadius = 8
        prizeImageView.layer.masksToBounds = true
        prizeImageView.layer.borderWidth = 2.0
        
    }
    
    
}
