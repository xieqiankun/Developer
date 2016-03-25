//
//  Facebook Data Fetcher.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/12/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation

var globalSavedFacebookUser = [NSObject: AnyObject]()

func requestFacebookUserInformation(completion: (error: NSError?) -> Void) {
    if FBSDKAccessToken.currentAccessToken() != nil {
        FBSDKGraphRequest(graphPath: "me?fields=id,email,age_range,name,gender", parameters: nil).startWithCompletionHandler({
            connection, result, error in
            if error == nil {
                globalSavedFacebookUser = result as! [NSObject: AnyObject]
                print(result)
                completion(error: error)
            }
        })
    }
}