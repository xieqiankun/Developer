//
//  App Info.swift
//  gStack Client Framework
//
//  Created by Qiankun Xie on 3/26/16.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation


func serverPrefix() -> String {
    if let path = NSBundle.mainBundle().pathForResource("ServerInfo", ofType: "plist") {
        let dictionary = NSDictionary(contentsOfFile: path)! as! Dictionary<String,String>
        return dictionary["ServerPrefix"]!
    }
    else {
        return ""
    }
}

func primusURL(connection: gStackGameConnection) -> NSURL? {
    let urlString = "ws://" + connection.serverIp + ":" + connection.serverPort + "/primus/websocket"
    return NSURL(string: urlString)
}

public var gStackCachedTournaments = Array<gStackTournament>()

public var gStackAppIDToken: String?
public var gStackPusherChannel: String?



