//
//  gStackGame.swift
//  gStackSDK
//
//  Created by Evan Bernstein on 8/20/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

public protocol gStackGameDelegate: class {
    func gameDidStart()
    func willAttemptToReconnect(options: PrimusReconnectOptions)
    func didReconnect()
    func didLoseConnection()
    func didEstablishConnection()
    func didEncounterError(error: NSError)
    func connectionDidEnd()
    func connectionDidClose()
    func didReceiveTimer(timer:gStackGameTimer)
    func didReceiveQuestion(question: gStackGameQuestion)
    func didReceivePlayerInfo(playerInfo: gStackGamePlayerInfo)
    func didReceiveCorrectAnswer(correctAnswer: gStackGameCorrectAnswer)
    func didReceiveUpdatedScore(updatedScore: gStackGameUpdatedScore)
    func didReceiveGameResult(result: gStackGameResult)
    func didReceiveOtherGameFinished(alive:gStackGameOtherGameFinished)
    func didReceiveStartRound(round:gStackGameStartRound)
    func didReceiveRoundResult(win:gStackGameRoundResult)
    func didReceiveErrorMsg(error:gStackGameErrorMsg)
}

//Note: this implementation allows only one game to be played at a time. If two game objects are valid concurrently, they will both set their connections to the latest game and receive its notifications
public class gStackGame: NSObject {
    
    class var sharedGame: gStackGame {
        struct Singleton {
            static let instance = gStackGame()
        }
        return Singleton.instance
    }
    
    var connection: gStackGameConnection?
    var primus: Primus?
    public weak var delegate: gStackGameDelegate?
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(gStackGame.gameStarted(_:)), name: gStackGameStartedNotificationName, object: nil)
    }
    
    deinit {
        print("gStack game deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func gameStarted(notificaiton: NSNotification) {
        connection = notificaiton.userInfo![gStackConnectionUserInfoKey] as? gStackGameConnection
        primus = Primus(URL: primusURL(connection!)!, options: PrimusConnectOptions(transformerClass: SocketRocketClient.self))
        
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
            self.primus!.write(self.connection!.gameToken)
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
                        self.delegate?.didReceiveQuestion(gStackGameQuestion(dictionary: payload))
                    case "timer":
                        self.delegate?.didReceiveTimer(gStackGameTimer(dictionary: payload))
                    case "startRound":
                        self.delegate?.didReceiveStartRound(gStackGameStartRound(dictionary: payload))
                    case "roundResult":
                        self.delegate?.didReceiveRoundResult(gStackGameRoundResult(dictionary: payload))
                    case "sendPlayerInfo":
                        self.delegate?.didReceivePlayerInfo(gStackGamePlayerInfo(dictionary: payload))
                    case "correctAnswer":
                        self.delegate?.didReceiveCorrectAnswer(gStackGameCorrectAnswer(dictionary: payload))
                    case "updateScore":
                        self.delegate?.didReceiveUpdatedScore(gStackGameUpdatedScore(dictionary: payload))
                    case "gameResult":
                        self.delegate?.didReceiveGameResult(gStackGameResult(dictionary: payload))
                    case "otherGameFinished":
                        self.delegate?.didReceiveOtherGameFinished(gStackGameOtherGameFinished(dictionary: payload))
                    case "error":
                        self.delegate?.didReceiveErrorMsg(gStackGameErrorMsg(dictionary: payload))
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
    
    
    public func submitAnswerForQuestion(question: gStackGameQuestion, answerIndex: NSNumber) {
        let payload = ["questionNum": question.questionNum!, "answer": answerIndex] as Dictionary<String,AnyObject>
        let answer = ["type": "clientSubmitAnswer","payload":payload] as Dictionary<String,AnyObject>
        primus?.write(answer)
    }
    
    public func sendForfeitMessage() {
        let info = ["type": "clientForfeit","payload":["":""]] as [String: AnyObject]
        primus?.write(info)
    }
    
    public func endGame() {
        primus?.end()
        primus = nil
    }
}



class gStackGameConnection: NSObject {
    var serverIp: String
    var serverPort: String
    var gameToken: String
    
    init(_serverIp: String, _serverPort: String, _gameToken: String) {
        serverIp = _serverIp
        serverPort = _serverPort
        gameToken = _gameToken
        super.init()
    }
}

public class gStackGameTimer:NSObject{
    
    public var timer:NSNumber?
    public var msg:String?
    
    init(dictionary: [String:AnyObject]){
        timer = dictionary["timer"] as? NSNumber
        msg = dictionary["msg"] as? String
    }
}


public class gStackGamePlayerInfo: NSObject {
    public var teamAvatars: Array<Array<String>>?
    public var teamLevels: Array<Array<NSNumber>>?
    public var teamNames: Array<Array<String>>?
    
    init(dictionary: Dictionary<String,AnyObject>) {

        teamAvatars = dictionary["teamAvatars"] as? Array<Array<String>>
        teamLevels = dictionary["teamLevels"] as? Array<Array<NSNumber>>
        teamNames = dictionary["teamNames"] as? Array<Array<String>>
    }
}

//Note: This is DIFFERENT than gStackQuestion
public class gStackGameQuestion: NSObject {
    public var answers: Array<String>?
    public var gameLength: NSNumber? //We're given this... do we need it?
    public var question: String? //Unformatted
    public var questionNum: NSNumber?
    public var timer: NSNumber?
    public var votes: NSNumber?
    public var promptTime: NSNumber?
    
    var voted: Bool?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        answers = dictionary["answers"] as? Array<String>
        gameLength = dictionary["gameLength"] as? NSNumber
        question = dictionary["question"] as? String
        questionNum = dictionary["questionNum"] as? NSNumber
        timer = dictionary["timer"] as? NSNumber
        votes = dictionary["votes"] as? NSNumber
        promptTime = dictionary["promptTime"] as? NSNumber
        voted = false
    }
    
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


public class gStackGameCorrectAnswer: NSObject {
    public var correctAnswer: NSNumber?
    public var dead: NSNumber?
    //public var lifelines: gStackLifelines?
    public var questionNum: NSNumber?
    public var timer: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        correctAnswer = dictionary["correctAnswer"] as? NSNumber
        dead = dictionary["dead"] as? NSNumber
//        if let lifelinesDict = dictionary["lifelines"] as? Dictionary<String,AnyObject> {
//            lifelines = gStackLifelines(dictionary: lifelinesDict)
//        }
        questionNum = dictionary["questionNum"] as? NSNumber
        timer = dictionary["timer"] as? NSNumber
    }
}


public class gStackGameUpdatedScore: NSObject {
    public var teamAnswersTime: Array<Array<NSNumber>>?
    public var answerNumber: NSNumber?
    public var rightOrWrong: NSNumber?
    public var teamScores: [AnyObject]?
    public var questionNum: NSNumber?
    
    //Others probably...
    
    init(dictionary: Dictionary<String,AnyObject>) {
        teamAnswersTime = dictionary["teamAnswersTime"] as? Array<Array<NSNumber>>
        answerNumber = dictionary["answerNumber"] as? NSNumber
        rightOrWrong = dictionary["rightOrWrong"] as? NSNumber
        teamScores = (dictionary["teamScores"] as? [[AnyObject]])?.first
        questionNum = dictionary["questionNum"] as? NSNumber

        //Others probably...
    }
}

public class gStackGameStartRound:NSObject {
    public var round: NSNumber?
    public var teamNum:NSNumber?
    
    init(dictionary:[String:AnyObject]) {
        round = dictionary["round"] as? NSNumber
        teamNum = dictionary["teamNum"] as? NSNumber
    }
}

public class gStackGameRoundResult:NSObject {
    public var win:NSNumber?
    init(dictionary:[String:AnyObject]){
        win = dictionary["win"] as? NSNumber
    }
}

public class gStackGameOtherGameFinished:NSObject{
    public var alive: [NSNumber]?
    public var gameRemaining: NSNumber?
    public var round:NSNumber?
    
    init(dictionary: [String:AnyObject]) {
        alive = dictionary["alive"] as? [NSNumber]
        gameRemaining = dictionary["gameRemaining"] as? NSNumber
        round = dictionary["round"] as? NSNumber
    }
}

public class gStackGameResult: NSObject {

    public var teamAnswersTime: Array<Array<NSNumber>>?
    public var teamLevels: Array<Array<NSNumber>>?
    public var teamPlaces: Array<NSNumber>?
    public var teamRating: Array<Array<NSNumber>>?
    public var teamScores: Array<Array<NSNumber>>?
    public var winnerTeamNum: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        teamAnswersTime = dictionary["teamAnswersTime"] as? Array<Array<NSNumber>>
        teamLevels = dictionary["teamLevels"] as? Array<Array<NSNumber>>
        teamPlaces = dictionary["teamPlaces"] as? Array<NSNumber>
        teamScores = dictionary["teamScores"] as? Array<Array<NSNumber>>
        winnerTeamNum = dictionary["winnerTeamNum"] as? NSNumber
    }
}


public class gStackGameErrorMsg:NSObject {
    
    public var error: String?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        error = dictionary["error"] as? String
    }
    
}
