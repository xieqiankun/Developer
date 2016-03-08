//
//  GStackGame.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

public protocol GStackGameDelegate {
    func gameDidStart(game: GStackGame)
    
    func willAttemptToReconnect(game: GStackGame, options: PrimusReconnectOptions)
    func didReconnect(game: GStackGame)
    func didLoseConnection(game: GStackGame)
    func didEstablishConnection(game: GStackGame)
    func didEncounterError(game: GStackGame, error: NSError)
    func connectionDidEnd(game: GStackGame)
    func connectionDidClose(game: GStackGame)
    func didReceiveTimer(game:GStackGame, timer:GStackGameTimer)
    func didReceiveQuestion(game: GStackGame, question: GStackGameQuestion)
    func didReceivePlayerInfo(game: GStackGame, playerInfo: GStackGamePlayerInfo)
    func didReceiveCorrectAnswer(game: GStackGame, correctAnswer: GStackGameCorrectAnswer)
    func didReceiveUpdatedScore(game: GStackGame, updatedScore: GStackGameUpdatedScore)
    func didReceiveGameResult(game: GStackGame, result: GStackGameResult)
    func didReceiveOtherGameFinished(game: GStackGame,alive:GStackGameOtherGameFinished)
}


public class GStackGame: NSObject {

    var primus: Primus?
    public var delegate: GStackGameDelegate?
    
    var gameServerIp: String?
    var gameServerPort: String?
    var gameToken: String?
    
    init(_gameServerIp:String?, _gameServerPort:String?, _gameToken:String?){
        
        self.gameToken = _gameToken
        self.gameServerIp = _gameServerIp
        self.gameServerPort = _gameServerPort
    }
    
    
    func startGame() {
        
        let connection = GStackGameConnection(_serverIp: gameServerIp!, _serverPort: gameServerPort!, _gameToken: gameToken!)
        
        primus = Primus(URL: primusURL(connection)!, options: PrimusConnectOptions(transformerClass: SocketRocketClient.self))
        
        
        let onReconnect: @convention(block) (PrimusReconnectOptions) -> () = { (options: PrimusReconnectOptions) -> () in
            self.delegate?.willAttemptToReconnect(self, options: options)
        }
        primus!.on("reconnect", listener: unsafeBitCast(onReconnect, AnyObject.self))
        
        let onOnline: @convention(block) () -> () = { () -> () in
            self.delegate?.didReconnect(self)
        }
        primus!.on("online", listener: unsafeBitCast(onOnline, AnyObject.self))
        
        let onOffline: @convention(block) () -> () = { () -> () in
            self.delegate?.didLoseConnection(self)
        }
        primus!.on("offline", listener: unsafeBitCast(onOffline, AnyObject.self))
        
        let onOpen: @convention(block) () -> () = { () -> () in
            self.primus!.write(connection.gameToken)
            self.delegate?.didEstablishConnection(self)
        }
        primus!.on("open", listener: unsafeBitCast(onOpen, AnyObject.self))
        
        let onError: @convention(block) (NSError) -> () = { (error: NSError) -> () in
            self.delegate?.didEncounterError(self, error: error)
        }
        primus!.on("error", listener: unsafeBitCast(onError, AnyObject.self))
        
        let onData: @convention(block) (NSDictionary, AnyObject) -> () = { (data: NSDictionary, raw: AnyObject) -> () in
            if let payload = data["payload"] as? Dictionary<String,AnyObject> {
                print("Data : \(data)")
                if let type = data["type"] as? String {
                    switch type {
                    case "sendQuestion":
                        self.delegate?.didReceiveQuestion(self, question: GStackGameQuestion(dictionary: payload))
                    case "timer":
                        self.delegate?.didReceiveTimer(self, timer: GStackGameTimer(dictionary: payload))
                    case "sendPlayerInfo":
                        self.delegate?.didReceivePlayerInfo(self, playerInfo: GStackGamePlayerInfo(dictionary: payload))
                    case "correctAnswer":
                        self.delegate?.didReceiveCorrectAnswer(self, correctAnswer: GStackGameCorrectAnswer(dictionary: payload))
                    case "updateScore":
                        self.delegate?.didReceiveUpdatedScore(self, updatedScore: GStackGameUpdatedScore(dictionary: payload))
                    case "gameResult":
                        self.delegate?.didReceiveGameResult(self, result: GStackGameResult(dictionary: payload))
                    case "otherGameFinished":
                        self.delegate?.didReceiveOtherGameFinished(self,alive:GStackGameOtherGameFinished(dictionary: payload))
                    default:
                        break
                    }
                }
            }
        }
        primus!.on("data", listener: unsafeBitCast(onData, AnyObject.self))
        
        let onEnd: @convention(block) () -> () = { () -> () in
            self.delegate?.connectionDidEnd(self)
        }
        primus!.on("end", listener: unsafeBitCast(onEnd, AnyObject.self))
        
        let onClose: @convention(block) () -> () = { () -> () in
            self.delegate?.connectionDidClose(self)
        }
        primus!.on("close", listener: unsafeBitCast(onClose, AnyObject.self))
        
        delegate?.gameDidStart(self)
    }
    
    
    func primusURL(connection: GStackGameConnection) -> NSURL? {
        let urlString = "ws://" + connection.serverIp + ":" + connection.serverPort + "/primus/websocket"
        print(urlString)
        return NSURL(string: urlString)
    }
    
    public func submitAnswerForQuestion(question: GStackGameQuestion, answerIndex: NSNumber) {
        let payload = ["questionNum": question.questionNum!, "answer": answerIndex] as Dictionary<String,AnyObject>
        let answer = ["type": "clientSubmitAnswer","payload":payload] as Dictionary<String,AnyObject>
        primus?.write(answer)
    }
    
    
    public func endGame() {
        primus?.end()
    }
}


//wrap the connection info
class GStackGameConnection: NSObject {
    var serverIp: String
    var serverPort: String
    var gameToken: String
    
    init(_serverIp: String, _serverPort: String, _gameToken: String) {
        serverIp = _serverIp
        serverPort = _serverPort
        gameToken = _gameToken
    }
}


public class GStackGamePlayerInfo: NSObject {
    public var prizes: Array<NSNumber>?
    public var teamAvatars: Array<Array<String>>?
    public var teamNames: Array<Array<String>>?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        prizes = dictionary["prizes"] as? Array<NSNumber>
        teamAvatars = dictionary["teamAvatars"] as? Array<Array<String>>
        teamNames = dictionary["teamNames"] as? Array<Array<String>>
    }
}

public class GStackGameTimer:NSObject{
    
    public var timer:NSNumber?
    public var msg:String?
    
    init(dictionary: [String:AnyObject]){
        timer = dictionary["timer"] as? NSNumber
        msg = dictionary["msg"] as? String
    }
    
    
    
}

//Note: This is DIFFERENT than GStackQuestion
public class GStackGameQuestion: NSObject {
    public var answers: Array<String>?
    public var gameLength: NSNumber? //We're given this... do we need it?
    public var question: String? //Unformatted
    public var questionNum: NSNumber?
    public var timer: NSNumber?
    public var promptTime: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        answers = dictionary["answers"] as? Array<String>
        gameLength = dictionary["gameLength"] as? NSNumber
        question = dictionary["question"] as? String
        questionNum = dictionary["questionNum"] as? NSNumber
        timer = dictionary["timer"] as? NSNumber
        promptTime = dictionary["promptTime"] as? NSNumber
    }
    
    // use this function to get formatted question.
    public func formattedQuestion() -> String? {
        var formattedQuestion = question?.stringByReplacingOccurrencesOfString("<q>", withString: "\"", options: [], range: nil)
        formattedQuestion = formattedQuestion?.stringByReplacingOccurrencesOfString("<s>", withString: "'", options: [], range: nil)
        return formattedQuestion
    }
    
    public func formattedAnswers() -> Array<String> {
        var formattedAnswers = Array<String>()
        if answers != nil {
            for answer in answers! {
                var formattedAnswer = answer.stringByReplacingOccurrencesOfString("<q>", withString: "\"", options: [], range: nil)
                formattedAnswer = formattedAnswer.stringByReplacingOccurrencesOfString("<s>", withString: "'", options: [], range: nil)
                formattedAnswers.append(formattedAnswer)
            }
        }
        return formattedAnswers
    }
}


public class GStackGameCorrectAnswer: NSObject {
    public var correctAnswer: NSNumber?
    public var questionNum: NSNumber?
    public var timer: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        correctAnswer = dictionary["correctAnswer"] as? NSNumber
        questionNum = dictionary["questionNum"] as? NSNumber
        timer = dictionary["timer"] as? NSNumber
    }
}

public class GStackGameOtherGameFinished:NSObject{
    public var alive: [NSNumber]?
    public var gameRemaining: NSNumber?
    
    init(dictionary: [String:AnyObject]) {
        alive = dictionary["alive"] as? [NSNumber]
        gameRemaining = dictionary["gameRemaining"] as? NSNumber
    }
}


// TO-DO finish it latter.....Not use right now
public class GStackGameUpdatedScore: NSObject {
    public var teamAnswersTime: Array<Array<NSNumber>>?
    public var answerNumber: NSNumber?
    //Others probably...
    
    init(dictionary: Dictionary<String,AnyObject>) {
        teamAnswersTime = dictionary["teamAnswersTime"] as? Array<Array<NSNumber>>
        answerNumber = dictionary["answerNumber"] as? NSNumber
        //Others probably...
    }
}


public class GStackGameResult: NSObject {
    
    //for traditional game
    public var teamAnswersTime: Array<Array<NSNumber>>?
    public var teamLevels: Array<Array<NSNumber>>?
    public var teamPlaces: Array<NSNumber>?
    public var teamRating: Array<Array<NSNumber>>?
    public var teamScores: Array<Array<NSNumber>>?
    public var teamTokens: Array<Array<NSNumber>>?
    public var winnerTeamNum: NSNumber?
    
    //for bracket
    public var teamAlive: Array<NSNumber>?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        teamAnswersTime = dictionary["teamAnswersTime"] as? Array<Array<NSNumber>>
        teamLevels = dictionary["teamLevels"] as? Array<Array<NSNumber>>
        teamPlaces = dictionary["teamPlaces"] as? Array<NSNumber>
        teamRating = dictionary["teamRating"] as? Array<Array<NSNumber>>
        teamScores = dictionary["teamScores"] as? Array<Array<NSNumber>>
        teamTokens = dictionary["teamTokens"] as? Array<Array<NSNumber>>
        winnerTeamNum = dictionary["winnerTeamNum"] as? NSNumber
        
        //for bracket
        teamAlive = dictionary["teamAlive"] as? [NSNumber]
        
    }
}