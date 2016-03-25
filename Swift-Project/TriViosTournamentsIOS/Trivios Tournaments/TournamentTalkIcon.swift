//
//  TournamentTalkIcon.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/28/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class TournamentTalkIcon: UIView {
    
    var tournament: gStackTournament? {
        didSet {
            getNumberOfReplies()
        }
    }
    var replies: Int?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
        getNumberOfReplies()
    }
    
    func getNumberOfReplies() {
        if tournament != nil {
            triviaGetChatMessagesForTournament(tournament!, completion: {
                error, messages in
                if error != nil {
                    print("Error getting chat messages: \(error!)")
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.replies = messages!.count
                        self.setNeedsDisplay()
                    })
                }
            })
        }
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        //Background chat bubble
        let background = UIImage(named: "chatbubble")?.imageWithRenderingMode(.AlwaysTemplate)
        background?.drawInRect(rect)
        
        //Draw number in center
        if replies != nil {
//            let font = UIFont.systemFontOfSize(24)
            let font = UIFont.getFontTofitInRect(rect, forText: String(replies!))
            let color = UIColor.greenColor()
            let stringAttributes = [NSFontAttributeName:font,NSForegroundColorAttributeName:color]
            let attributedString = NSAttributedString(string: String(replies!), attributes: stringAttributes)
            
            let size = NSString(string: String(replies!)).sizeWithAttributes(stringAttributes)
            let x = (rect.size.width - size.width) / 2
            let y = (rect.size.height - size.height) / 2
            attributedString.drawAtPoint(CGPointMake(x, y))
        }
    }
    

}
