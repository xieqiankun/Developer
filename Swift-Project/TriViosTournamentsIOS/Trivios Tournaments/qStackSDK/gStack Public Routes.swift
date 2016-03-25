//
//  Public Routes.swift
//  gStack Client Framework
//
//  Created by Qiankun Xie on 3/23/16.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation

var gStackLoginWithAppIDNotificationName = "gStackLoginWithAppID"

//login with app key and app id
//works

func gStackLoginWithAppID(appId: String, appKey: String, completion:(error: NSError?)-> Void){
    
    print("appId" + appId)
    
    gStackMakeRequest(false, route: "register", type: "apiRegister", payload: ["appId":appId, "appKey":appKey]) {(data, response, error) -> Void in
        
        gStackProcessResponse(error, data: data, successType: "apiRegisterSuccess", completion: {(error, payload) -> Void in
            
            if error == nil {
                gStackAppIDToken = payload!["token"] as? String
                gStackPusherChannel = payload!["channel"] as? String
                print(gStackPusherChannel)
                print(gStackAppIDToken)
                
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
