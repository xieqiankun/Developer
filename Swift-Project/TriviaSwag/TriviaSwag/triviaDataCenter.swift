//
//  triviaDataCenter.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

public class triviaDataCenter {
    
    var gifStore:triviaGifStore?
    var shop:triviaShop?
    var practiceTournament: gStackTournament?
    
    
    init(payload: [String: AnyObject]) {
     
        if let gifs = payload["gifs"] as? [String:AnyObject] {
            gifStore = triviaGifStore(payload: gifs)
        }
        if let items = payload["iap"] as? [[String:AnyObject]]{
            
            shop = triviaShop(payload: items)
        }
        if let practice = payload["practice"] as? [String: AnyObject] {
            
            practiceTournament = gStackTournament(practice: practice)
        }
    }
    
}