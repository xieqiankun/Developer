//
//  trivia Public Routes.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/24/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation

//MARK: - Trivia User Login/Sign up
// for user login in trivia game
//works
public func triviaUserLogin(email: String, password: String, completion: (error: NSError?) -> Void) {
    makeRequest(false, route: "login", type: "clientLogin", payload: ["email":email,"password":password], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error)
                triviaCurrentUser = nil
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                triviaCurrentUser = triviaUser(payload: payload)
                // store user login token
                saveLogInTokenForCurrentUser()
                completion(error: nil)
                // save info for gStack
                if let displayName = triviaCurrentUser?.displayName, avator = triviaCurrentUser?.avatar {
                    gStackSetCurrentUserInfo(displayName, avator: avator)
                }
            } else {
                completion(error: triviaMissingPayloadError)
                triviaCurrentUser = nil
            }
        })
    })
}

public func triviaUserLoginWithFacebook(fbToken: String, fbID: String, completion:(error: NSError?) -> Void) {
    
    makeRequest(false, route: "loginfacebook", type: "clientFacebookLogin", payload: ["accessToken":fbToken,"fbId":fbID], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                triviaCurrentUser = triviaUser(payload: payload)
                completion(error: nil)
            } else {
                completion(error: triviaMissingPayloadError)
            }
        })
    })
    
    
}

//Verify email
public func triviaVerifyEmail(email: String, completion: (error: NSError?) -> Void) {
    makeRequest(false, route: "verifyemail", type: "verifyEmail", payload: ["email":email], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}


//not sure if the function will work
public func triviaFacebookSignUp(displayName: String, email: String, password: String, avatar: String?, deviceId: String?, referralCode: String?, fbToken: String?, fbData: [NSObject: AnyObject]?, completion: (error: NSError?) -> Void) {

    let payloadDictionary = ["displayName":displayName,"email":email,"password":password,"avatar":avatar!,"deviceId":deviceId!,"referralCode":referralCode!,"fbToken":fbToken!,"fbData":fbData!]
    makeRequest(false, route: "signup", type: "clientSignUp", payload: payloadDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                triviaCurrentUser = triviaUser(payload: payload)
                completion(error: nil)
            } else {
                completion(error: gStackMissingPayloadError)
            }
        })
    })
}

// workds
public func triviaSignUp(displayName: String, email: String, password: String, avatar: String?, deviceId: String?, referralCode: String?, completion: (error: NSError?) -> Void) {

    let payloadDictionary = ["displayName":displayName,"email":email,"password":password,"avatar":avatar!,"deviceId":deviceId!,"referralCode":referralCode!]
    makeRequest(false, route: "signup", type: "clientSignUp", payload: payloadDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                triviaCurrentUser = triviaUser(payload: payload)
                completion(error: nil)
            } else {
                completion(error: gStackMissingPayloadError)
            }
        })
    })

}



//MARK: - Tournament Talk
//works
public func triviaGetChatMessagesForTournament(tournament: gStackTournament, completion: (error: NSError?, messages: Array<triviaTournamentChatMessage>?) -> Void) {
    if tournament.uuid == nil {
        let error = NSError(domain: "tournament uuid is missing", code: 2222, userInfo: nil)
        completion(error: error, messages: nil)
    } else {
        makeRequest(false, route: "getchatmessages", type: "clientGetChatMessages", payload: ["tournamentID":tournament.uuid!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, messages: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let messages = payload["messages"] as? Array<Dictionary<String,AnyObject>> {
                        var messagesArray = Array<triviaTournamentChatMessage>()
                        for message in messages {
                            messagesArray.append(triviaTournamentChatMessage(dictionary: message))
                        }
                        completion(error: nil, messages: messagesArray)
                    } else {
                        let missingError = NSError(domain: "Missing messages", code: 1111, userInfo: nil)
                        completion(error: missingError, messages: nil)
                    }
                } else {
                    completion(error: gStackMissingPayloadError, messages: nil)
                }
            })
        })
    }
}


//MARK: - Other User Info
public func triviaFetchProfileForDisplayName(displayName: String, completion: (user: triviaUser?, error: NSError?) -> Void) {
    makeRequest(false, route: "getprofile", type: "clientRequestProfile", payload: ["displayName":displayName], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(user: nil, error: _error)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                completion(user: triviaUser(payload: payload), error: nil)
            } else {
                completion(user: nil, error: gStackMissingPayloadError)
            }
        })
    })
}


public func triviaFetchDataCenter(completion:(center:triviaDataCenter?, error: NSError? ) -> Void) {
    
    makeRequest(false, route: "triviamonster", type: "getGameData", payload: true, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error == nil {
                if let payload = _payload as? [String: AnyObject]{
                    let datacenter = triviaDataCenter(payload: (payload))
                    triviaCurrentDataCenter = datacenter
                    completion(center: datacenter, error: nil)
                    
                }
             // Handle error
            }
        })
    })
    
}




















