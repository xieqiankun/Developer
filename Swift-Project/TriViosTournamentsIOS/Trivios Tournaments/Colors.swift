//
//  Colors.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 7/29/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func color(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    class func color(red: Int, green: Int, blue: Int) -> UIColor {
        return color(red, green: green, blue: blue, alpha: 1.0)
    }
}

//Tournament Colors
let kActiveTournamentsUnselectedBackgroundColor = UIColor.color(136, green: 211, blue: 146)
let kActiveTournamentsUnselectedTextColor = UIColor.color(230, green: 230, blue: 230)
let kActiveTournamentsSelectedBackgroundColor = UIColor.color(158, green: 255, blue: 172)
let kActiveTournamentsSelectedTextColor = UIColor.color(0, green: 104, blue: 55)
let kActiveTournamentsOddCellBackgroundColor = UIColor.color(57, green: 181, blue: 74)
let kActiveTournamentsEvenCellBackgroundColor = UIColor.color(40, green: 127, blue: 52)

let kExpiredTournamentsUnselectedBackgroundColor = UIColor.color(87, green: 176, blue: 212)
let kExpiredTournamentsUnselectedTextColor = UIColor.color(230, green: 230, blue: 230)
let kExpiredTournamentsSelectedBackgroundColor = UIColor.color(46, green: 85, blue: 194)
let kExpiredTournamentsSelectedTextColor = UIColor.color(176, green: 219, blue: 255)
let kExpiredTournamentsOddCellBackgroundColor = UIColor.color(63, green: 169, blue: 245)
let kExpiredTournamentsEvenCellBackgroundColor = UIColor.color(44, green: 119, blue: 172)

let kUpcomingTournamentsUnselectedBackgroundColor = UIColor.color(246, green: 182, blue: 96)
let kUpcomingTournamentsUnselectedTextColor = UIColor.color(230, green: 230, blue: 230)
let kUpcomingTournamentsSelectedBackgroundColor = UIColor.color(241, green: 149, blue: 36)
let kUpcomingTournamentsSelectedTextColor = UIColor.color(252, green: 247, blue: 176)
let kUpcomingTournamentsOddCellBackgroundColor = UIColor.color(251, green: 176, blue: 57)
let kUpcomingTournamentsEvenCellBackgroundColor = UIColor.color(176, green: 124, blue: 41)


//Dot Colors
let kWrongBackgroundColor = UIColor.color(237, green: 28, blue: 36)
let kCorrectBackgroundColor = UIColor.color(57, green: 181, blue: 74)
let kUnansweredBackgroundColor = UIColor.color(247, green: 147, blue: 30)
let kGamePageTextColor = UIColor.color(46, green: 49, blue: 146)


//Page Control Colors
let kPageControlTintColor = UIColor.lightGrayColor()
let kPageControlCurrentPageTintColor = UIColor.blackColor()


func randomColor() -> UIColor {
    let red = Double(arc4random() % 255) / 255.0
    let green = Double(arc4random() % 255) / 255.0
    let blue = Double(arc4random() % 255) / 255.0
    
    return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
}