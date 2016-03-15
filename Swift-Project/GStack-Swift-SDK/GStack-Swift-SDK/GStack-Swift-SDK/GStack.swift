//
//  GStack.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

class GStack {
    static let sharedInstance = GStack()
    
    var token: String?
    var channel: String?
    
    var displayName: String?
    
    var GStackTraditionalTournaments = Array<GStackTournament>()
    var GStackBracketTournaments = Array<GStackTournament>()
    
    var gameServerIp: String?
    var gameServerPort: String?
    var gameToken: String?
    
    // MARK: - gStack function
    //login with app key and app id

    func gStackLoginWithAppID(appId: String, appKey: String, completion:(error: NSError?)-> Void){
        
        print("appId" + appId)
        
        sendRequest(false, route: "register", type: "apiRegister", payload: ["appId":appId, "appKey":appKey]) {(data, response, error) -> Void in
            
            self.processResponse(error, data: data, successType: "apiRegisterSuccess", completion: {(error, payload) -> Void in
                
                if error == nil {
                    self.token = payload!["token"] as? String
                    self.channel = payload!["channel"] as? String
                    print(self.token)
                    print(self.channel)
                 
                    PusherSock.sharedPusher.connectToPushServerWithChannel(self.channel!)
                    completion(error: nil)
                    
                } else {
                    //handle the error
                    
                }
                
            })
        }
    }
    
    
    //fetch tournaments
    func gStackFetchTournaments(completion: (error: NSError?, tournaments: Array<GStackTournament>?) -> Void) {
        
        print("I am fetching the data")
        
        sendRequest(true, route: "gettournaments", type: "getUserTournaments", payload:[String : AnyObject]() , completion: {// return data kind of different from normal, so do not use self.processResponse
            data, response, error in
            
            var tournaments: [Dictionary<String, AnyObject>]?
            
            do{
                tournaments = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [[String: AnyObject]]
            } catch {
                // do something to catch the error
                
            }
            //for completion
            print(tournaments)
            var ts = [GStackTournament]()
            self.GStackBracketTournaments.removeAll()
            self.GStackTraditionalTournaments.removeAll()
            for tournament in tournaments! {
                let t = GStackTournament(tournament: tournament)
                ts.append(t)
                if t.style == "traditional"{
                    print("in tradition")
                    if case .Active = t.status() {
                        self.GStackTraditionalTournaments.append(t)
                    }

                } else if t.style == "shootout" {
                    if case .Active = t.status() {
                        self.GStackBracketTournaments.append(t)
                    }
                }
            }
            
            completion(error: nil, tournaments: ts)
        })
    }

    //get game server ip and port
    func GStackStartGameForTournament(tournament: GStackTournament, completion: (error: NSError?, game: GStackGame?) -> Void) {
        if tournament.uuid == nil {
            tournament.uuid = ""
            return
        }
        let requestDictionary = ["teams":[["displayName":"yyy", "channel": self.channel!, "avatar": "yyy"]],"gameMode":["type":"tournament","uuid":tournament.uuid!]]
        print(requestDictionary)
        sendRequest(true, route: "startgame", type: "clientStartGame", payload: requestDictionary, completion: {
            data, reply, error in
            
            self.processResponse(error,data: data,successType: "startGameSuccess", completion: {
                error, payload in
                if error != nil {
                    completion(error: error, game: nil)
                } else {
                    PusherSock.sharedPusher.didReceiveEvent("newGameSuccess",completion: {
                        t in
                        let receivedData = t.data as! Dictionary<String, AnyObject>
                        if receivedData["event"] as! String == "newGameSuccess"{
                            self.gameServerIp = receivedData["serverIp"] as? String
                            self.gameServerPort = String(receivedData["serverPort"] as! NSNumber)
                            self.gameToken = receivedData["token"] as? String
                            
//                            print(self.gameServerIp)
//                            print(self.gameServerPort)
//                            print(self.gameToken)
                            
                            let game = GStackGame(_gameServerIp: self.gameServerIp!, _gameServerPort: self.gameServerPort!, _gameToken: self.gameToken!)
                            
                            completion(error: nil, game: game)
                        }
                        
                    })
                }
            })
        })
    }
    
    
    
    
    
    
    // MARK: - help func
    func sendRequest(isPrivate:Bool, route: String, type: String, payload: Dictionary<String, AnyObject>, completion:(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void ){
        
        let session = NSURLSession.sharedSession()
        
        let serverURL = "http://UserServerLB-672243361.us-west-2.elb.amazonaws.com/"
        
        var requestSuffix = route
        
        if isPrivate {
            requestSuffix = "qstacks/" + route
        } else {
            requestSuffix = "qstack/" + route
        }
        
        let url = NSURL(string: serverURL + requestSuffix)!
        
        let payloadString = JSONStringify(payload)
        
        let postString = JSONStringify(["type" : type, "payload" : payloadString])
        
        let request = NSMutableURLRequest(URL: url)
        
        //set http request
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTaskWithRequest(request,completionHandler: completion).resume()
        
        
        
    }
    
    func JSONStringify(value: AnyObject) -> String{
        
        let options = NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    
    func processResponse(error: NSError?, data: NSData?, successType: String?, completion: (error: NSError?, payload: AnyObject?) -> Void) {
        
        if error != nil {

            completion(error: error, payload: nil)
        } else {
            var parseError: NSError?
            do {
                let reply = try parseJSONReply(data!)
                if((reply["type"] as! String == successType!) || successType == "" ){ // verify the success type
                    
                    if let payload = reply["payload"] as? Dictionary<String,AnyObject> {
                        if let errorString = payload["error"] as? String {
                            let apiError = NSError(domain: errorString, code: 1111, userInfo: nil)
                            completion(error: apiError, payload: nil)
                        }
                        else {
                            completion(error: nil, payload: payload)
                        }
                    } else if let payload = reply["payload"] as? Array<Dictionary<String,AnyObject>> {
                        completion(error: nil, payload: payload)
                    } else if let payload: AnyObject = reply["payload"] {
                        completion(error: nil, payload: payload)
                    } else {
                        completion(error: nil, payload: nil) //Some calls can succeed and receive no payload
                    }
                }
            } catch let error1 as NSError {
                parseError = error1
                completion(error: parseError, payload: nil)
            }
        }
    }
    
    func parseJSONReply(data: NSData) throws -> Dictionary<String,AnyObject> {
        let value: Dictionary<String,AnyObject>?
        do {
            value = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String,AnyObject>
            
            return value!
        } catch let error as NSError {
            throw error
        }
    }
    
    
}
