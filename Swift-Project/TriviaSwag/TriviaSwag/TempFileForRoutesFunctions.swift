//
//  TempFileForRoutesFunctions.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/23/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation










//private part
//nq
public func gStackLinkCurrentUserToFacebook(facebookAccessToken: String, facebookName: String, facebookGender: String, facebookAgeRange: AnyObject, facebookId: String, facebookEmail: String, completion: (error: NSError?) -> Void) {
    let requestDictionary = ["fbToken":facebookAccessToken,"name":facebookName,"gender":facebookGender,"age_range":facebookAgeRange,"userID":facebookId,"fbEmail":facebookEmail]
    makeRequest(true, route: "linkfacebook", type: "clientLinkFacebook", payload: requestDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}

//nq
public func gStackRedeemPromoCode(promoCode: String, completion: (error: NSError?, summary: String?) -> Void) {
    makeRequest(true, route: "promo", type: "redeemPromo", payload: promoCode, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, summary: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                if let userDictionary = payload["user"] as? Dictionary<String,AnyObject> {
                    if let id = userDictionary["_id"] as? String {
                        triviaCurrentUser?._id = id
                    }
                    if let adFreeExpire = userDictionary["adFreeExpire"] as? NSNumber {
                        triviaCurrentUser?.adFreeExpire = adFreeExpire
                    }
                    if let ticketBalance = userDictionary["ticketBalance"] as? NSNumber {
                        triviaCurrentUser?.ticketBalance = ticketBalance
                    }
                    if let multiplier = userDictionary["multiplier"] as? NSNumber {
                        triviaCurrentUser?.multiplier = multiplier
                    }
                    if let multiplierExpireString = userDictionary["multiplierExpire"] as? String {
                        triviaCurrentUser?.multiplierExpire = dateForString(multiplierExpireString)
                    }
                }
                completion(error: nil, summary: payload["summary"] as? String)
            } else {
                completion(error: gStackMissingPayloadError, summary: nil)
            }
        })
    })
}




//nq

//nq
public func gStackSetCurrentUserAvatar(avatar: String, completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "avatar", type: "setUserAva", payload: ["avatar":avatar], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            if _error == nil {
                triviaCurrentUser?.avatar = avatar
            }
            completion(error: _error)
        })
    })
}



//nq
public func gStackGetGameMessage(completion: (error: NSError?, message: String?) -> Void) {
    makeRequest(true, route: "getgamemessage", type: "getGameMessage", payload: true, completion: {
        data, response, error in
        if error != nil {
            completion(error: error, message: nil)
        } else {
            var parseError: NSError?
            do {
                let reply = try parseJSONReply(data!)
                if let gameMessage = reply["payload"] as? String {
                    if let type = reply["type"] as? String where type == "getGameMessageFail" {
                        let failError = NSError(domain: "getGameMessageFail", code: 1111, userInfo: ["message": gameMessage])
                        completion(error: failError, message: nil)
                    } else {
                        completion(error: nil, message: gameMessage)
                    }
                }
            } catch let error1 as NSError {
                parseError = error1
                completion(error: parseError, message: nil)
            } catch {
                fatalError()
            }
        }
    })
}

//nq
public func gStackSetCurrentUserLocation(location: triviaUserLocation, completion: (error: NSError?) -> Void) {
    if location.region == nil {
        location.region = ""
    }
    if location.country == nil {
        location.country = ""
    }
    if location.lat == nil {
        location.lat = ""
    }
    if location.long == nil {
        location.long = ""
    }
    let requestDictionary = ["location":["region":location.region!,"country":location.country!,"lat":location.lat!,"long":location.long!]]
    makeRequest(true, route: "location", type: "setUserLoc", payload: requestDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            if _error == nil {
                triviaCurrentUser?.location = location
            }
            completion(error: _error)
        })
    })
}








//nq
public func gStackVerifyInAppPurchase(itemId: String, receipt: NSData, completion: (error: NSError?) -> Void) {
    let payloadDictionary = ["itemId":itemId,"type":"APPLE","receipt":receipt]
    makeRequest(true, route: "inapppurchase", type: "clientPurchase", payload: payloadDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let userDictionary = payload["user"] as? Dictionary<String,AnyObject> {
                        if let id = userDictionary["_id"] as? String {
                            triviaCurrentUser?._id = id
                        }
                        if let adFreeExpire = userDictionary["adFreeExpire"] as? NSNumber {
                            triviaCurrentUser?.adFreeExpire = adFreeExpire
                        }
                        if let ticketBalance = userDictionary["ticketBalance"] as? NSNumber {
                            triviaCurrentUser?.ticketBalance = ticketBalance
                        }
                        if let multiplier = userDictionary["multiplier"] as? NSNumber {
                            triviaCurrentUser?.multiplier = multiplier
                        }
                        if let multiplierExpireString = userDictionary["multiplierExpire"] as? String {
                            triviaCurrentUser?.multiplierExpire = dateForString(multiplierExpireString)
                        }
                    }
                }
            } else {
                completion(error: gStackMissingPayloadError)
            }
            completion(error: _error)
        })
    })
}

//nq
public func gStackGetReferralBonus(completion: (error: NSError?, bonus: NSNumber?) -> Void) {
    makeRequest(true, route: "getreferralbonus", type: "referralBonus", payload: true, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, payload in
            if _error != nil {
                completion(error: _error, bonus: nil)
            } else {
                completion(error: nil, bonus: payload as? NSNumber)
            }
        })
    })
}

//nq  we need to change this for just favorite tournaments, this needs to be added to the backend because it currently does not exist
public func gStackGetTournamentsForCurrentUser(completion: (error: NSError?, tournaments: Array<gStackTournament>?) -> Void) {
    var payloadDictionary = Dictionary<String,AnyObject>()
    if let userLocation = triviaCurrentUser?.location {
        payloadDictionary["location"] = userLocation.dictionary()
    }
    if let tournamentsWon = triviaCurrentUser?.tournamentsWon {
        payloadDictionary["tournamentsWon"] = tournamentsWon.count
    }
    makeRequest(true, route: "getusertournaments", type: "getUserTournaments", payload: payloadDictionary, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, tournaments: nil)
            } else {
                var tournaments = Array<gStackTournament>()
                if let payload = _payload as? Dictionary<String,AnyObject> {
                    if let tournamentsDict = payload["tournaments"] as? Array<Dictionary<String,AnyObject>> {
                        for tournament in tournamentsDict {
                            tournaments.append(gStackTournament(tournament: tournament))
                        }
                    }
                    if let favoritesDict = payload["favorites"] as? Dictionary<String,AnyObject> {
                        if let favoriteTournaments = favoritesDict["tournaments"] as? Array<Dictionary<String,AnyObject>> {
                            triviaCurrentUser!.favoriteTournaments = Array<gStackTournament>()
                            for tournament in favoriteTournaments {
                                triviaCurrentUser!.favoriteTournaments!.append(gStackTournament(tournament: tournament))
                            }
                        }
                    }
                }
                gStackCacheDataManager.sharedInstance.setTournaments(tournaments)
                completion(error: nil, tournaments: tournaments)
            }
        })
    })
}

//nq
public func gStackSetFavoriteTournament(favorite: Bool, tournament: gStackTournament, completion: (error: NSError?) -> Void) {
    if tournament.uuid == nil {
        let error = NSError(domain: "uuid is missing", code: 2222, userInfo: nil)
        completion(error: error)
    } else {
        var type = "addFavoriteTournament"
        if favorite == false {
            type = "unfavoriteTournament"
        }
        makeRequest(true, route: "favoritetournament", type: type, payload: ["uuid":tournament.uuid!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, payload in
                completion(error: _error)
            })
        })
    }
}

//nq
public func gStackRedeemScratcher(completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "scratcher", type: "redeemScratcher", payload: true, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, payload in
            if _error == nil {
                if let userDictionary = payload as? Dictionary<String,AnyObject> {
                    if let id = userDictionary["_id"] as? String {
                        triviaCurrentUser?._id = id
                    }
                    if let adFreeExpire = userDictionary["adFreeExpire"] as? NSNumber {
                        triviaCurrentUser?.adFreeExpire = adFreeExpire
                    }
                    if let ticketBalance = userDictionary["ticketBalance"] as? NSNumber {
                        triviaCurrentUser?.ticketBalance = ticketBalance
                    }
                    if let multiplier = userDictionary["multiplier"] as? NSNumber {
                        triviaCurrentUser?.multiplier = multiplier
                    }
                    if let multiplierExpireString = userDictionary["multiplierExpire"] as? String {
                        triviaCurrentUser?.multiplierExpire = dateForString(multiplierExpireString)
                    }
                }
            }
            completion(error: _error)
        })
    })
}

//nq
public func gStackGetScratcher(completion: (error: NSError?, scratcher: gStackScratcher?) -> Void) {
    makeRequest(true, route: "scratcher", type: "getScratcher", payload: true, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, scratcher: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                completion(error: nil, scratcher: gStackScratcher(dictionary: payload))
            } else {
                completion(error: gStackMissingPayloadError, scratcher: nil)
            }
        })
    })
}



//nq
public func gStackRegisterForPushNotifications(token: String, completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "registerpush", type: "registerPush", payload: ["plat":"iOS","token":token], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}

//nq
public func gStackUnregisterForPushNotifications(completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "unregisterpush", type: "unregisterPush", payload: ["plat":"iOS"], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}

//nq
public func gStackChangeUserPushSettings(pushSettings: gStackPushSettings, completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "pushsettings", type: "changePushSetting", payload: pushSettings.dictionary(), completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}





//nq
public func gStackUpVoteChatMessageInTournament(tournament: gStackTournament, message: triviaTournamentChatMessage, completion: (error: NSError?, message: triviaTournamentChatMessage?) -> Void) {
    if tournament.uuid == nil || message.uuid == nil {
        let error = NSError(domain: "tournament uuid or message uuid is missing", code: 2222, userInfo: nil)
        completion(error: error, message: nil)
    } else {
        makeRequest(true, route: "upVoteMessage", type: "clientUpVoteMessage", payload: ["messageID":message.uuid!,"tournamentID":tournament.uuid!,"displayName":triviaCurrentUser!.displayName!], completion: {
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
public func gStackDownVoteChatMessageInTournament(tournament: gStackTournament, message: triviaTournamentChatMessage, completion: (error: NSError?, message: triviaTournamentChatMessage?) -> Void) {
    if tournament.uuid == nil || message.uuid == nil {
        let error = NSError(domain: "tournament uuid or message uuid is missing", code: 2222, userInfo: nil)
        completion(error: error, message: nil)
    } else {
        makeRequest(true, route: "downVoteMessage", type: "clientDownVoteMessage", payload: ["messageID":message.uuid!,"tournamentID":tournament.uuid!,"displayName":triviaCurrentUser!.displayName!], completion: {
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
public func gStackFetchPrizeWinners(completion: (error: NSError?, winners: Array<gStackPrizeWinner>?) -> Void) {
    makeRequest(false, route: "getPrizeTicker", type: "getPrizeTicker", payload: true, completion: {
        data, response, error in
        if error != nil {
            completion(error: error, winners: nil)
        } else {
            let winnersArray: Array<Dictionary<String,AnyObject>>?
            do {
                winnersArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? Array<Dictionary<String,AnyObject>>
                var returnWinners = Array<gStackPrizeWinner>()
                for winner in winnersArray! {
                    let returnWinner = gStackPrizeWinner()
                    returnWinner.prize = winner["prize"] as? String
                    returnWinner.displayName = winner["displayName"] as? String
                    returnWinner.avatar = winner["avatar"] as? String
                    if let imageDict = winner["image"] as? Dictionary<String,AnyObject> {
                        returnWinner.image = imageDict["image"] as? String
                        returnWinner.color = imageDict["color"] as? String
                    }
                    if let dateString = winner["date"] as? String {
                        returnWinner.date = dateForString(dateString)
                    }
                    returnWinner.isTournament = winner["isTournament"] as? Bool
                    if let tournamentDictionary = winner["tournament"] as? Dictionary<String,AnyObject> {
                        returnWinner.tournament = gStackTournament(tournament: tournamentDictionary)
                    }
                    returnWinners.append(returnWinner)
                }
                completion(error: nil, winners: returnWinners)
            }
            catch let parseError as NSError {
                completion(error: parseError, winners: nil)
            }
            catch {
                completion(error: NSError(domain: "Unexpected results", code: 5551, userInfo: nil), winners:nil)
            }
        }
    })
}


//public part


//nq
public func gStackRequestPasswordReset(email: String, completion: (error: NSError?) -> Void) {
    makeRequest(false, route: "reset", type: "clientRequestReset", payload: ["email":email], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}

//nq
public func gStackResetPassword(email: String, resetcode: String, completion: (error: NSError?) -> Void) {
    makeRequest(false, route: "reset", type: "clientResetPassword", payload: ["email":email,"resetcode":resetcode], completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}






