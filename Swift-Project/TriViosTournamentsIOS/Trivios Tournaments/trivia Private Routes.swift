//
//  trivia Private Routes.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/25/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation

//MARK: - User
//Get Trivia User Info
public func triviaGetCurrentUserInfo(completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "getuserinfo", type: "getUserInfo", payload: true, completion: {
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

//Updata Address Info
public func triviaUpdateAddress(var name: String?, phone: String, address: triviaUserAddress, completion: (error: NSError?) -> Void) {
    if name == nil {
        name = ""
    }
    if address.line1 == nil {
        address.line1 = ""
    }
    if address.line2 == nil {
        address.line2 = ""
    }
    if address.city == nil {
        address.city = ""
    }
    if address.zipCode == nil {
        address.zipCode = ""
    }
    if address.territory == nil {
        address.territory = ""
    }
    if address.country == nil {
        address.country = ""
    }
    let addressDictionary = ["line1":address.line1!,"line2":address.line2!,"city":address.city!,"zipCode":address.zipCode!,"territory":address.territory!,"country":address.country!]
    let requestDictionary = ["name":name!,"phone":phone,"address":addressDictionary]
    makeRequest(true, route: "useraddress", type: "setUserData", payload: requestDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}


//Resend Email Verification
public func triviaResendVerificationEmail(completion: (error: NSError?) -> Void) {
    if triviaCurrentUser?.email == nil || triviaCurrentUser?.displayName == nil {
        let error = NSError(domain: "user email or display name is missing", code: 2222, userInfo: nil)
        completion(error: error)
    } else {
        makeRequest(true, route: "resendVerificationEmail", type: "clientResendVerificationEmail", payload: ["email":triviaCurrentUser!.email!,"displayName":triviaCurrentUser!.displayName!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _ in
                completion(error: _error)
            })
        })
    }
}

//nq
public func triviaChangeUserPassword(oldPassword: String, newPassword: String, completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "changepass", type: "changePassword", payload: ["passwordOld":oldPassword,"password":newPassword], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}



//MARK: - Tournament Talk
//get up voted chat messages
public func triviaGetDownVotedChatMessagesInTournament(tournament: gStackTournament, completion: (error: NSError?, messages: Array<triviaTournamentChatMessage>?) -> Void) {
    if tournament.uuid == nil {
        let error = NSError(domain: "tournament uuid is missing", code: 2222, userInfo: nil)
        completion(error: error, messages: nil)
    } else if triviaCurrentUser == nil || triviaCurrentUser!.displayName == nil {
        let error = NSError(domain: "current user nil or display name nil", code: 2222, userInfo: nil)
        completion(error: error, messages: nil)
    } else {
        makeRequest(true, route: "getDownVotedMessages", type: "clientGetDownVotedMessages", payload: ["displayName":triviaCurrentUser!.displayName!,"tournamentID":tournament.uuid!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, messages: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let messages = payload["messages"] as? Array<Dictionary<String,AnyObject>> {
                        var returnMessages = Array<triviaTournamentChatMessage>()
                        for message in messages {
                            returnMessages.append(triviaTournamentChatMessage(dictionary: message))
                        }
                        completion(error: nil, messages: returnMessages)
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


// get down voted messages
public func triviaGetUpVotedChatMessagesInTournament(tournament: gStackTournament, completion: (error: NSError?, messages: Array<triviaTournamentChatMessage>?) -> Void) {
    if tournament.uuid == nil {
        let error = NSError(domain: "tournament uuid is missing", code: 2222, userInfo: nil)
        completion(error: error, messages: nil)
    } else if triviaCurrentUser == nil || triviaCurrentUser!.displayName == nil {
        let error = NSError(domain: "current user nil or display name nil", code: 2222, userInfo: nil)
        completion(error: error, messages: nil)
    } else {
        makeRequest(true, route: "getUpVotedMessages", type: "clientGetUpVotedMessages", payload: ["displayName":triviaCurrentUser!.displayName!,"tournamentID":tournament.uuid!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, messages: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let messages = payload["messages"] as? Array<Dictionary<String,AnyObject>> {
                        var returnMessages = Array<triviaTournamentChatMessage>()
                        for message in messages {
                            returnMessages.append(triviaTournamentChatMessage(dictionary: message))
                        }
                        completion(error: nil, messages: returnMessages)
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

// Send Tournament Talk Message
public func triviaSendTournamentChatMessage(message: triviaTournamentChatMessage, completion: (error: NSError?, message: triviaTournamentChatMessage?) -> Void) {
    if message.tournament?.uuid == nil || triviaCurrentUser?.displayName == nil || triviaCurrentUser?.avatar == nil || message.messageBody == nil {
        let error = NSError(domain: "tournament uuid and/or display name and/or avatar and/or message body is missing", code: 2222, userInfo: nil)
        completion(error: error, message: nil)
    } else {
        let requestDictionary = ["tournamentID":message.tournament!.uuid!,"displayName":triviaCurrentUser!.displayName!,"avatar":triviaCurrentUser!.avatar!,"messageBody":message.messageBody!]
        makeRequest(true, route: "sendchatmessage", type: "clientSendChatMessage", payload: requestDictionary, completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, message: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let message = payload["message"] as? Dictionary<String,AnyObject> {
                        completion(error: nil, message: triviaTournamentChatMessage(dictionary: message))
                    } else {
                        let missingError = NSError(domain: "Missing message", code: 1111, userInfo: nil)
                        completion(error: missingError, message: nil)
                    }
                } else {
                    completion(error: gStackMissingPayloadError, message: nil)
                }
            })
        })
    }
}


