//
//  DispatchUtils.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/25/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}