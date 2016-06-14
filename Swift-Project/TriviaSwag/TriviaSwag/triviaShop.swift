//
//  triviaShop.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

public class triviaShop: NSObject {
    
    var shopItems = [triviaShopItem]()
    
    init(payload:[[String:AnyObject]]){
        for item in payload {
            shopItems.append(triviaShopItem(payload: item))
        }
    }
}


public class triviaShopItem: NSObject {
    public var cost: String?
    public var image: String?
    public var quantity: Int?
    public var summary: String?
    public var type: String?
    
    public var cachedImage: UIImage?
    
    init(payload: [String: AnyObject]) {
        
        if let _cost = payload["cost"] as? Double {
            let temp = Double(round(100*_cost) / 100)
            cost = String(format: "%.2f", temp)
        }
        if let _image = payload["image"] as? String {
            image = _image
        }
        if let _quantity = payload["quantity"] as? Int {
            quantity = _quantity
        }
        if let _summary = payload["summary"] as? String {
            summary = _summary
        }
        if let _type = payload["type"] as? String {
            type = _type
        }
    }
    
    
}