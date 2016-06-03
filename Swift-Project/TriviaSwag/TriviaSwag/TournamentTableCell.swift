//
//  TournamentTableCell.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation


class TournamentTableViewCell: UITableViewCell {
    
    var tournamentStatus = gStackTournamentStatus.Active
    
    //For UI
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var prizeImageView: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    //@IBOutlet weak var backgroundImageView: UIImageView!
    //TODO: --
    @IBOutlet weak var startbtn: UIButton!
    
    
    var backgroundImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myLabel.textColor = kMainScreenLeaderboardFillColor
        
    }
    
    func changeColorWhenSelect(){
        let view = tableCellView.subviews[0] as! UIImageView
        view.image = UIImage(named: "TournamentItemTouched.png")
        startbtn.hidden = true
    }
    
    func changeCorlorWhenDeselect(){
        let view = tableCellView.subviews[0] as! UIImageView
        view.image = UIImage(named: "TournamentItemUntouched.png")
        
        if tournamentStatus == gStackTournamentStatus.Active {
            startbtn.hidden = false
        }
    }
    
    func setupCell(tournament: gStackTournament) {
        
        self.backgroundColor = UIColor.clearColor()
        self.myLabel.text = tournament.name
        self.setRoundCorner()
        self.setupCellBackground()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        if tournamentStatus != gStackTournamentStatus.Active {
            startbtn.hidden = true
        } else {
            startbtn.hidden = false
        }
    }
    
    override func prepareForReuse() {
        
    }
    
    func setupCellBackground(){
        
        if backgroundImageView != nil{
            backgroundImageView?.removeFromSuperview()
        }
        
        let tableImageViewBackground = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        tableImageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        tableImageViewBackground.image = UIImage(named: "TournamentItemUntouched.png")
        tableImageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        
        
        backgroundImageView = tableImageViewBackground
        
        tableCellView.addSubview(tableImageViewBackground)
        tableCellView.sendSubviewToBack(tableImageViewBackground)
        tableImageViewBackground.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        //TODO: - there is a bug for ipad version and iphone 4s
        //Fixed
        addConstrains(tableImageViewBackground,toView: self.tableCellView)
        
    }
    
    // Auto layout
    func addConstrains(aView: UIView, toView:UIView) {
        
        let topContraint = NSLayoutConstraint(item: aView, attribute: .Top, relatedBy: .Equal, toItem: toView, attribute: .Top, multiplier: 1, constant: 0)
        let leftContraint = NSLayoutConstraint(item: toView, attribute: .Trailing, relatedBy: .Equal, toItem: aView, attribute: .Trailing, multiplier: 1, constant: 0)
        let rightContraint = NSLayoutConstraint(item: toView, attribute: .Leading, relatedBy: .Equal, toItem: aView, attribute: .Leading, multiplier: 1, constant: 0)
        let downContraint = NSLayoutConstraint(item: toView, attribute: .Bottom, relatedBy: .Equal, toItem: aView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        topContraint.active = true
        leftContraint.active = true
        rightContraint.active = true
        downContraint.active = true
        
       // aView.superview!.addConstraints([topContraint,leftContraint,rightContraint,downContraint])
    }
    
    func setRoundCorner(){
        
        prizeImageView.layer.borderColor = UIColor.whiteColor().CGColor
        prizeImageView.layer.cornerRadius = 8
        prizeImageView.layer.masksToBounds = true
        prizeImageView.layer.borderWidth = 2.0
        
    }
    
    
    
}
