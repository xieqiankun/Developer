//
//  Avatars.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/12/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation

func resourceNameForRandomAvatar() -> String {
    let names = resourceNamesForAvatars()
    let randomIndex = Int(arc4random_uniform(UInt32(names.count)))
    return names[randomIndex]
}

func resourceNamesForAvatars() -> Array<String> {
    var names = Array<String>()
    var notFound = false
    var index = 1
    while notFound == false {
        let name = "b"+String(index)+".png"
        if let _ = UIImage(named: name) {
            index += 1
            names.append("imgs/"+name)
        }
        else {
            notFound = true
        }
    }
    return names
}