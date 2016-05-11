//
//  Public Routes.swift
//  gStack Client Framework
//
//  Created by Qiankun Xie on 3/23/16.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation

var gStackLoginWithAppIDNotificationName = "gStackLoginWithAppID"

let gStackAppIdTokenKey = "gStackAppIdTokenKey"
let gStackPusherChannelKey = "gStackPusherChannelKey"

//login with app key and app id
//works

func gStackLoginWithAppID(completion:(error: NSError?)-> Void){
    
    gStackMakeRequest(false, route: "register", type: "apiRegister", payload: ["appId":"308189542", "appKey":"/o3I3goKCQ=="]) {(data, response, error) -> Void in
        
        gStackProcessResponse(error, data: data, successType: "apiRegisterSuccess", completion: {(error, payload) -> Void in
            
            if error == nil {
                gStackAppIDToken = payload!["token"] as? String
                gStackPusherChannel = payload!["channel"] as? String
                print(gStackPusherChannel)
                print(gStackAppIDToken)
                
                NSUserDefaults.standardUserDefaults().setObject(gStackAppIDToken, forKey: gStackAppIdTokenKey)
                NSUserDefaults.standardUserDefaults().setObject(gStackPusherChannel, forKey: gStackPusherChannelKey)

                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                gStackNotificationHandler.sharedInstance.connectToPushServerWithChannel(gStackPusherChannel!);
                NSNotificationCenter.defaultCenter().postNotificationName(gStackLoginWithAppIDNotificationName, object: nil)
                
                completion(error: nil)
                
            } else {
                //handle the error
                print("Error in login")
            }
            
        })
    }
}
