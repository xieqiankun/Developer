//
//  trivia Private Routes.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/25/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation

let triviaUpdateInboxNotificationName = "triviaFetchUserInbox"
let triviaDidSendMessageNotificationName = "triviaDidSendMessage"
let triviaDidDeleteMessageNotificationName = "triviaDidDeleteMessage"
let triviaDidUpdateFriendsNotificationName = "triviaDidUpadateFriend"

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
                // update token every time user open the app
                saveLogInTokenForCurrentUser()
                completion(error: nil)
                if let displayName = triviaCurrentUser?.displayName, avator = triviaCurrentUser?.avatar {
                    gStackSetCurrentUserInfo(displayName, avator: avator)
                }
                
            } else {
                completion(error: gStackMissingPayloadError)
            }
        })
    })
}

//Updata Address Info
//regulate use before submit the address
public func triviaUpdateAddress(name: String?, phone: String, address: triviaUserAddress, completion: (error: NSError?) -> Void) {

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


//MARK: - User messages
//nq
public func triviaGetCurrentUserInbox(completion: (error: NSError?, inbox: triviaUserInbox?) -> Void) {
    makeRequest(true, route: "getinbox", type: "clientGetInbox", payload: true, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, inbox: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                if let userInbox = payload["userInbox"] as? Dictionary<String,AnyObject> {
                    
                    let currentInbox = triviaUserInbox(dictionary: userInbox)
                    
                    triviaCurrentUserInbox = currentInbox

//                    print("In fetching message ------")
//                    print(currentInbox.friendRequests.count)
//                    print("In fetching message ------")
//                    
                    completion(error: nil, inbox: currentInbox)
                    // post fetch trivia inbox success notification
                    NSNotificationCenter.defaultCenter().postNotificationName(triviaUpdateInboxNotificationName, object: nil)
                    
                } else {
                    let missingError = NSError(domain: "Missing User Inbox", code: 1111, userInfo: nil)
                    completion(error: missingError, inbox: nil)
                }
            } else {
                completion(error: gStackMissingPayloadError, inbox: nil)
            }
        })
    })
}

//nq
public func triviaDeleteCommunique(communique: triviaCommunique, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    if communique._id == nil || communique.type == nil {
        let error = NSError(domain: "_id and/or type is missing", code: 2222, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else if communique.type == "finishedAsyncChallenge" || communique.type == "incomingAsyncChallenge" {
        let error = NSError(domain: "Finished or incoming challenges cannot be deleted", code: 2223, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else {
        var requestDictionary = ["messageId":communique._id!,"messageType":communique.type!]

        if communique.isKindOfClass(gStackAsyncChallengeMessage) {
            requestDictionary["challengeId"] = communique._id!
        }
        makeRequest(true, route: "deletemessage", type: "clientDeleteMessage", payload: requestDictionary, completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, updatedInbox: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let updatedInboxDictionary = payload["userInbox"] as? Dictionary<String,AnyObject> {
                    print(_payload)
                    let inbox = triviaUserInbox(dictionary: updatedInboxDictionary)
                    //update the trivia current user inbox
                    triviaCurrentUserInbox = inbox
//                    print("In deleting message ------")
//                    print(inbox.friendRequests.count)
//                    print("In deleting message ------")

                    completion(error: nil, updatedInbox: inbox)
                    NSNotificationCenter.defaultCenter().postNotificationName(triviaDidDeleteMessageNotificationName, object: nil)
                    }
                } else {
                    completion(error: gStackMissingPayloadError, updatedInbox: nil)
                }
            })
        })
    }
}

//nq
public func triviaDeleteMessage(message: triviaMessage, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    triviaDeleteCommunique(message, completion: completion)
}

//nq
public func triviaDeleteFriendRequest(request: triviaFriendRequest, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    triviaDeleteCommunique(request, completion: completion)
}

//nq
public func triviaMarkCommuniqueRead(communique: triviaCommunique, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    if communique._id == nil || communique.type == nil {
        let error = NSError(domain: "_id and/or type is missing", code: 2222, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else if communique.isKindOfClass(triviaFriendRequest) {
        let error = NSError(domain: "Friend requests cannot be marked read", code: 2223, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else if communique.type == "incomingAsyncChallenge" {
        let error = NSError(domain: "Incoming challenges cannot be marked read", code: 2223, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else if communique.type == "outgoingAsyncChallenge" || communique.type == "outgoing" {
        let error = NSError(domain: "Outgoing messages/challenges cannot be marked read", code: 2223, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else {
        var requestDictionary = ["messageId":communique._id!,"messageType":communique.type!]
        if communique.isKindOfClass(gStackAsyncChallengeMessage) {
            requestDictionary["challengeId"] = communique._id!
        }
        makeRequest(true, route: "markread", type: "clientMarkRead", payload: requestDictionary, completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, updatedInbox: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    completion(error: nil, updatedInbox: triviaUserInbox(dictionary: payload))
                } else {
                    completion(error: gStackMissingPayloadError, updatedInbox: nil)
                }
            })
        })
    }
}

//nq
public func triviaMarkMessageRead(message: triviaMessage, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    triviaMarkCommuniqueRead(message, completion: completion)
}

//nq
public func triviaSendMessage(message: triviaMessage, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    if message.recipient == nil || message.body == nil {
        let error = NSError(domain: "Message recipient and/or body is missing", code: 2222, userInfo: nil)
        completion(error: error, updatedInbox: nil)
    } else {
        let payloadDictionary = ["recipientName":message.recipient!,"message":message.body!]
        makeRequest(true, route: "sendmessage", type: "clientSendMessage", payload: payloadDictionary, completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, updatedInbox: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let updatedInboxDictionary = payload["userInbox"] as? Dictionary<String,AnyObject> {
                        let currentInbox = triviaUserInbox(dictionary: updatedInboxDictionary)
                        triviaCurrentUserInbox = currentInbox
                        completion(error: nil, updatedInbox: currentInbox)
                        // post fetch trivia inbox success notification
                        NSNotificationCenter.defaultCenter().postNotificationName(triviaDidSendMessageNotificationName, object: nil)
                    } else {
                        let missingError = NSError(domain: "Missing updated inbox", code: 1111, userInfo: nil)
                        completion(error: missingError, updatedInbox: nil)
                    }
                } else {
                    completion(error: gStackMissingPayloadError, updatedInbox: nil)
                }
            })
        })
    }
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

//nq
public func triviaSearchForUsers(searchString: String, completion: (error: NSError?, users: Array<triviaUser>?) -> Void) {
    makeRequest(true, route: "searchforusers", type: "clientUsersSearch", payload: ["searchName":searchString], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, users: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                if let users = payload["users"] as? Array<Dictionary<String,AnyObject>> {
                    var triviaUsers = Array<triviaUser>()
                    for user in users {
                        triviaUsers.append(triviaUser(payload: user))
                    }
                    print("success")
                    completion(error: nil, users: triviaUsers)
                } else {
                    let missingError = NSError(domain: "Users missing", code: 1111, userInfo: nil)
                    completion(error: missingError, users: nil)
                }
            } else {
                completion(error: gStackMissingPayloadError, users: nil)
            }
        })
    })
}

//nq
public func triviaRequestFriend(friendDisplayName: String, completion: (error: NSError?, newInbox: triviaUserInbox?) -> Void) {
    makeRequest(true, route: "requestfriend", type: "clientRequestFriend", payload: ["recipientName":friendDisplayName], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, newInbox: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                if let updatedInboxDictionary = payload["userInbox"] as? Dictionary<String,AnyObject> {
                    completion(error: nil, newInbox: triviaUserInbox(dictionary: updatedInboxDictionary))
                } else {
                    let missingError = NSError(domain: "Missing updated inbox", code: 1111, userInfo: nil)
                    completion(error: missingError, newInbox: nil)
                }
            } else {
                completion(error: gStackMissingPayloadError, newInbox: nil)
            }
        })
    })
}



//nq
public func triviaAnswerFriendRequest(request: triviaFriendRequest, accept: Bool, completion: (error: NSError?, updatedFriends: Array<triviaFriend>?) -> Void) {
    if request.token == nil || request._id == nil {
        let error = NSError(domain: "Request missing token and/or _id", code: 2222, userInfo: nil)
        completion(error: error, updatedFriends: nil)
    } else {
        let requestDictionary = ["token":request.token!,"accepted":accept,"messageId":request._id!]
        makeRequest(true, route: "answerfriendrequest", type: "clientAnswerFriendRequest", payload: requestDictionary, completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, updatedFriends: nil)
                } else if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let updatedFriends = payload["friends"] as? Array<Dictionary<String,AnyObject>> {
                        var friends = Array<triviaFriend>()
                        for friend in updatedFriends {
                            friends.append(triviaFriend(dictionary: friend))
                        }
                        completion(error: nil, updatedFriends: friends)
                        if let currentUser = triviaCurrentUser {
                            currentUser.friends = friends
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName(triviaDidUpdateFriendsNotificationName, object: nil, userInfo: nil)
                        
                    } else {
                        let missingError = NSError(domain: "Missing Updated Friends", code: 1111, userInfo: nil)
                        completion(error: missingError, updatedFriends: nil)
                    }
                } else {
                    completion(error: gStackMissingPayloadError, updatedFriends: nil)
                }
            })
        })
    }
}

//nq
public func triviaUnfriend(friendDisplayName: String, completion: (error: NSError?, updatedFriends: Array<triviaFriend>?) -> Void) {
    makeRequest(true, route: "unfriend", type: "clientUnfriend", payload: ["friendName":friendDisplayName], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, updatedFriends: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                if let updatedFriends = payload["friends"] as? Array<Dictionary<String,AnyObject>> {
                    var friends = Array<triviaFriend>()
                    for friend in updatedFriends {
                        friends.append(triviaFriend(dictionary: friend))
                    }
                    // Should do something to clean the database
                    completion(error: nil, updatedFriends: friends)
                    if let currentUser = triviaCurrentUser {
                        currentUser.friends = friends
                        print("===== user friends num ======")
                        print(triviaCurrentUser?.friends?.count)
                        print(currentUser.friends?.count)
                        print("===== user friends num ======")
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(triviaDidUpdateFriendsNotificationName, object: nil, userInfo: nil)
                } else {
                    let missingError = NSError(domain: "Missing Updated Friends", code: 1111, userInfo: nil)
                    completion(error: missingError, updatedFriends: nil)
                }
            } else {
                completion(error: gStackMissingPayloadError, updatedFriends: nil)
            }
        })
    })
}





