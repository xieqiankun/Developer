//
//  GStackGame.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

public protocol GStackGameDelegate {
    func gameDidStart()
    
    func willAttemptToReconnect(options: PrimusReconnectOptions)
    func didReconnect()
    func didLoseConnection()
    func didEstablishConnection()
    func didEncounterError(error: NSError)
    func connectionDidEnd()
    func connectionDidClose()
    func didReceiveTimer(timer:GStackGameTimer)
    func didReceiveQuestion(question: GStackGameQuestion)
    func didReceivePlayerInfo(playerInfo: GStackGamePlayerInfo)
    func didReceiveCorrectAnswer(correctAnswer: GStackGameCorrectAnswer)
    func didReceiveUpdatedScore(updatedScore: GStackGameUpdatedScore)
    func didReceiveGameResult(result: GStackGameResult)
    func didReceiveOtherGameFinished(alive:GStackGameOtherGameFinished)
    func didReceiveStartRound(round:GStackGameStartRound)
    func didReceiveRoundResult(win:GStackGameRoundResult)
    func didReceiveErrorMsg(error:GStackGameErrorMsg)
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
        
        print("I am in Start Game")
        
        let connection = GStackGameConnection(_serverIp: gameServerIp!, _serverPort: gameServerPort!, _gameToken: gameToken!)
        
        primus = Primus(URL: primusURL(connection)!, options: PrimusConnectOptions(transformerClass: SocketRocketClient.self))
        
        
        let onReconnect: @convention(block) (PrimusReconnectOptions) -> () = { (options: PrimusReconnectOptions) -> () in
            self.delegate?.willAttemptToReconnect(options)
        }
        primus!.on("reconnect", listener: unsafeBitCast(onReconnect, AnyObject.self))
        
        let onOnline: @convention(block) () -> () = { () -> () in
            self.delegate?.didReconnect()
        }
        primus!.on("online", listener: unsafeBitCast(onOnline, AnyObject.self))
        
        let onOffline: @convention(block) () -> () = { () -> () in
            self.delegate?.didLoseConnection()
        }
        primus!.on("offline", listener: unsafeBitCast(onOffline, AnyObject.self))
        
        let onOpen: @convention(block) () -> () = { () -> () in
            self.primus!.write(connection.gameToken)
            self.delegate?.didEstablishConnection()
        }
        primus!.on("open", listener: unsafeBitCast(onOpen, AnyObject.self))
        
        let onError: @convention(block) (NSError) -> () = { (error: NSError) -> () in
            self.delegate?.didEncounterError(error)
        }
        primus!.on("error", listener: unsafeBitCast(onError, AnyObject.self))
        
        let onData: @convention(block) (NSDictionary, AnyObject) -> () = { (data: NSDictionary, raw: AnyObject) -> () in
            if let payload = data["payload"] as? Dictionary<String,AnyObject> {
                print("Data : \(data)")
                if let type = data["type"] as? String {
                    switch type {
                    case "sendQuestion":
                        self.delegate?.didReceiveQuestion(GStackGameQuestion(dictionary: payload))
                    case "timer":
                        self.delegate?.didReceiveTimer(GStackGameTimer(dictionary: payload))
                    case "startRound":
                        self.delegate?.didReceiveStartRound(GStackGameStartRound(dictionary: payload))
                    case "roundResult":
                        self.delegate?.didReceiveRoundResult(GStackGameRoundResult(dictionary: payload))
                    case "sendPlayerInfo":
                        self.delegate?.didReceivePlayerInfo(GStackGamePlayerInfo(dictionary: payload))
                    case "correctAnswer":
                        self.delegate?.didReceiveCorrectAnswer(GStackGameCorrectAnswer(dictionary: payload))
                    case "updateScore":
                        self.delegate?.didReceiveUpdatedScore(GStackGameUpdatedScore(dictionary: payload))
                    case "gameResult":
                        self.delegate?.didReceiveGameResult(GStackGameResult(dictionary: payload))
                    case "otherGameFinished":
                        self.delegate?.didReceiveOtherGameFinished(GStackGameOtherGameFinished(dictionary: payload))
                    case "error":
                        self.delegate?.didReceiveErrorMsg(GStackGameErrorMsg(dictionary: payload))
                    default:
                        break
                    }
                }
            }
        }
        primus!.on("data", listener: unsafeBitCast(onData, AnyObject.self))
        
        let onEnd: @convention(block) () -> () = { () -> () in
            self.delegate?.connectionDidEnd()
        }
        primus!.on("end", listener: unsafeBitCast(onEnd, AnyObject.self))
        
        let onClose: @convention(block) () -> () = { () -> () in
            self.delegate?.connectionDidClose()
        }
        primus!.on("close", listener: unsafeBitCast(onClose, AnyObject.self))
        
        delegate?.gameDidStart()
    }
    
    
    func primusURL(connection: GStackGameConnection) -> NSURL? {
        let urlString = "ws://" + connection.serverIp + ":" + connection.serverPort + "/primus/websocket"
        return NSURL(string: urlString)
    }
    
    public func submitAnswerForQuestion(question: GStackGameQuestion, answerIndex: NSNumber) {
        let payload = ["questionNum": question.questionNum!, "answer": answerIndex] as Dictionary<String,AnyObject>
        let answer = ["type": "clientSubmitAnswer","payload":payload] as Dictionary<String,AnyObject>
        print(answer)
        primus?.write(answer)
    }
    
    public func sendForfeitMessage() {
        
        let info = ["type": "clientForfeit","payload":["":""]] as [String: AnyObject]
        primus?.write(info)
        print(info)
        
    }
    
    
    public func endGame() {
        primus?.end()
        primus = nil
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

public class GStackGameStartRound:NSObject {
    public var round: NSNumber?
    public var teamNum:NSNumber?
    
    init(dictionary:[String:AnyObject]) {
        round = dictionary["round"] as? NSNumber
        teamNum = dictionary["teamNum"] as? NSNumber
    }
}

public class GStackGameRoundResult:NSObject {
    public var win:NSNumber?
    init(dictionary:[String:AnyObject]){
        win = dictionary["win"] as? NSNumber
    }
}

public class GStackGameOtherGameFinished:NSObject{
    public var alive: [NSNumber]?
    public var gameRemaining: NSNumber?
    public var round:NSNumber?
    
    init(dictionary: [String:AnyObject]) {
        alive = dictionary["alive"] as? [NSNumber]
        gameRemaining = dictionary["gameRemaining"] as? NSNumber
        round = dictionary["round"] as? NSNumber
    }
}


// TO-DO finish it latter.....Not use right now
public class GStackGameUpdatedScore: NSObject {
    public var teamAnswersTime: Array<Array<NSNumber>>?
    public var answerNumber: NSNumber?
    public var rightOrWrong: NSNumber?
    public var teamNum: NSNumber?
    //Others probably...
    
    init(dictionary: Dictionary<String,AnyObject>) {
        teamAnswersTime = dictionary["teamAnswersTime"] as? Array<Array<NSNumber>>
        answerNumber = dictionary["answerNumber"] as? NSNumber
        rightOrWrong = dictionary["rightOrWrong"] as? NSNumber
        teamNum = dictionary["teamNum"] as? NSNumber
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

public class GStackGameErrorMsg:NSObject {
    
    public var error: String?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        error = dictionary["error"] as? String
    }
    
}




