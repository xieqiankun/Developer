//
//  Private Routes.swift
//  gStackSDK
//
//  Created by Qiankun Xie on 3/23/16.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation

public class gStackPrizeWinner : NSObject {
    public var prize: String?
    public var displayName: String?
    public var avatar: String?
    public var image: String?
    public var color: String?
    public var date: NSDate?
    public var isTournament: Bool?
    public var tournament: gStackTournament?
}


//qstack works
public func gStackFetchTournaments(completion: (error: NSError?, tournaments: Array<gStackTournament>?) -> Void) {
    gStackMakeRequest(true, route: "gettournaments", type: "getUserTournaments", payload: [String : AnyObject](), completion: {
        data, response, error in
        
        var parsedData: [Dictionary<String, AnyObject>]?
        do{
            if data != nil{
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [[String: AnyObject]]
            }
        } catch {
            // do something to catch the error
        }
        
        print(parsedData)
        var returnTournaments = Array<gStackTournament>()
        if let payload = parsedData  {
            for tournament in payload {
                returnTournaments.append(gStackTournament(tournament: tournament))
            }
        }
        gStackCachedTournaments = returnTournaments
        completion(error: nil, tournaments: returnTournaments)

    })
}

//qstack works
public func gStackStartGameForTournament(tournament: gStackTournament, completion: (error: NSError?, game: gStackGame?) -> Void) {
    if tournament.uuid == nil {
        tournament.uuid = ""
    }
    let requestDictionary = ["teams":[["displayName":"yyy", "channel": gStackPusherChannel!, "avatar": "yyy"]],"gameMode":["type":"tournament","uuid":tournament.uuid!]]
    gStackMakeRequest(true, route: "startgame", type: "clientStartGame", payload: requestDictionary, completion: {
        data, reply, error in
        gStackProcessResponse(error, data: data, successType: "startGameSuccess" ,completion: {
            _error, _ in
            if _error != nil {
                completion(error: _error, game: nil)
            } else {
                completion(error: nil, game: gStackGame())
            }
        })
    })
}


//qstack
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


//qstack
public func gStackFetchLeaderboardForTournament(tournament: gStackTournament, completion: (error: NSError?, leaderboard: gStackTournamentLeaderboard?) -> Void) {
    if tournament.uuid == nil {
        let error = NSError(domain: "tournament uuid is missing", code: 2222, userInfo: nil)
        completion(error: error, leaderboard: nil)
    } else {
        makeRequest(false, route: "gettournaments", type: "clientGetTournamentLeaderboard", payload: ["uuid":tournament.uuid!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _payload in
                if _error != nil {
                    completion(error: _error, leaderboard: nil)
                } else if let payload = _payload as? Array<Dictionary<String,AnyObject>> {
                    completion(error: nil, leaderboard: gStackTournamentLeaderboard(array: payload))
                } else {
                    completion(error: gStackMissingPayloadError, leaderboard: nil)
                }
            })
        })
    }
}





//qstack
public func gStackDeleteChallenge(challenge: gStackAsyncChallengeMessage, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    gStackDeleteCommunique(challenge, completion: completion)
}


//qstack
public func gStackMarkChallengeRead(challenge: gStackAsyncChallengeMessage, completion: (error: NSError?, updatedInbox: triviaUserInbox?) -> Void) {
    gStackMarkCommuniqueRead(challenge, completion: completion)
}


//qstack
public func gStackFlagQuestion(question: gStackQuestion, completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "flagquestion", type: "flagQuestion", payload: question.flagDictionary(), completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}

//qstack
public func gStackUpVoteQuestion(tournament: gStackTournament, question: gStackGameQuestion, completion: (error: NSError?) -> Void) {
    if tournament.questions?._zone == nil || question.question == nil {
        let error = NSError(domain: "zone or questionBody is missing", code: 2222, userInfo: nil)
        completion(error: error)
    } else {
        makeRequest(true, route: "flagquestion", type: "upVoteQuestion", payload: ["zone":tournament.questions!._zone!,"question":question.question!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _ in
                completion(error: _error)
            })
        })
    }
}

//qstack
public func gStackDownVoteQuestion(tournament: gStackTournament, question: gStackGameQuestion, completion: (error: NSError?) -> Void) {
    if tournament.questions?._zone == nil || question.question == nil {
        let error = NSError(domain: "zone or questionBody is missing", code: 2222, userInfo: nil)
        completion(error: error)
    } else {
        makeRequest(true, route: "flagquestion", type: "downVoteQuestion", payload: ["zone":tournament.questions!._zone!,"question":question.question!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _ in
                completion(error: _error)
            })
        })
    }
}


//qstack
public func gStackSubmitQuestion(question: gStackQuestion, completion: (error: NSError?) -> Void) {
    makeRequest(true, route: "submitquestion", type: "submitQuestion", payload: question.submitDictionary(), completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _ in
            completion(error: _error)
        })
    })
}


//qstack
public func gStackDeclineAsyncChallenge(challenge: gStackAsyncChallengeMessage, completion: (error: NSError?) -> Void) {
    if challenge._id == nil {
        let error = NSError(domain: "challenge id is missing", code: 2222, userInfo: nil)
        completion(error: error)
    } else {
        makeRequest(true, route: "declineAsyncChallenge", type: "clientDeclineAsyncChallenge", payload: ["challengeId":challenge._id!], completion: {
            data, response, error in
            processResponse(error, data: data, completion: {
                _error, _ in
                completion(error: _error)
            })
        })
    }
}

//qstack
public func gStackGetOpenAsyncChallenges(completion: (error: NSError?, games: Array<gStackAsyncChallengeGame>?) -> Void) {
    makeRequest(true, route: "getOpenAsyncChallenges", type: "clientGetOpenAsyncChallenges", payload: true, completion: {
        data, response, error in
        processResponse(error, data: data, completion: {
            _error, _payload in
            if _error != nil {
                completion(error: _error, games: nil)
            } else if let payload = _payload as? Dictionary<String,AnyObject> {
                if let gamesDictionary = payload["games"] as? Array<Dictionary<String,AnyObject>> {
                    var games = Array<gStackAsyncChallengeGame>()
                    for game in gamesDictionary {
                        games.append(gStackAsyncChallengeGame(dictionary: game))
                    }
                    completion(error: nil, games: games)
                } else {
                    let missingError = NSError(domain: "Missing games", code: 1111, userInfo: nil)
                    completion(error: missingError, games: nil)
                }
            } else {
                completion(error: gStackMissingPayloadError, games: nil)
            }
        })
    })
}

