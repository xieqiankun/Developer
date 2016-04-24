//
//  App Info.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/23/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation

/*
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

public var triviaCurrentUser: triviaUser?
public var gStackCachedTournaments = Array<gStackTournament>()

let triviaUserLogInTokenKey = "triviaUserLoginToken"

func saveLogInToken(token: String) {
    NSUserDefaults.standardUserDefaults().setObject(token, forKey: triviaUserLogInTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
}

func retrieveLogInToken() {
    if triviaCurrentUser == nil {
        triviaCurrentUser = triviaUser()
    }
    triviaCurrentUser!._id = NSUserDefaults.standardUserDefaults().stringForKey(triviaUserLogInTokenKey)
}

func isCurrentUserLoggedIn() -> Bool {
    return triviaCurrentUser?.displayName != nil
}

*/

//MARK: - Handle Trivia User

let triviaUserLogInTokenKey = "triviaUserLoginToken"
let triviaUserSuccessfullyLoggedIn = "triviaUserSuccessfullyLoggedIn"

public var triviaCurrentUser: triviaUser?
func retrieveLogInToken() {
    if triviaCurrentUser == nil {
        triviaCurrentUser = triviaUser()
    }
    triviaCurrentUser!._id = NSUserDefaults.standardUserDefaults().stringForKey(triviaUserLogInTokenKey)
    print(triviaCurrentUser?._id)
}

func isCurrentUserLoggedIn() -> Bool {
    return triviaCurrentUser?.displayName != nil
}

func saveLogInToken(token: String) {
    NSUserDefaults.standardUserDefaults().setObject(token, forKey: triviaUserLogInTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
}

// MARK: - default


//MARK: - Handle Trivia User Inbox
public var triviaCurrentUserInbox: triviaUserInbox?




