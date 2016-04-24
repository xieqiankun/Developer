//
//  FacebookFunctions.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/23/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

func requestFacebookUserInformation(completion: (result:[NSObject: AnyObject]?,error: NSError?) -> Void) {
    if FBSDKAccessToken.currentAccessToken() != nil {
        FBSDKGraphRequest(graphPath: "me?fields=id,email,age_range,name,gender", parameters: nil).startWithCompletionHandler({
            connection, result, error in
            if error == nil {
                print(result)
                completion(result:result as? [NSObject: AnyObject],error: error)
            } else {
                completion(result: nil, error: error)
            }
        })
    }
}