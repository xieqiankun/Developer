//
//  PlayBracketViewController.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class PlayBracketViewController: UIViewController,GStackGameDelegate {
    
    var tournament: GStackTournament?
    var game: GStackGame?
    
    //for ui
    //for question label
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionLabelView: UIView!
    
    //TO-DO make the player one and player two
    
    //for answers
    @IBOutlet var answers: [UIButton]!
    @IBOutlet var answersView: [UIView]!
    
    //for timebar
    @IBOutlet weak var timeBarBackGround: UIView!
    @IBOutlet weak var timeBar: UIView!
    
    @IBOutlet weak var clock: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    
    //for nameboard
    @IBOutlet weak var nameBoard: UIView!
    
    @IBOutlet var firstRoundPlayersView: [UIView]!
    
    @IBOutlet var firstRoundPlayers: [UILabel]!
    
    @IBOutlet var firstRoundPlaysAlive: [UIView]!
    
    
    @IBOutlet var secondRoundPlayersView: [UIView]!
    
    @IBOutlet var secondRoundPlayers: [UILabel]!
    
    @IBOutlet var secondRoundPlaysAlive: [UIView]!
    
    
    @IBOutlet var thirdRoundPlayersView: [UIView]!
    
    @IBOutlet var thirdRoundPlayers: [UILabel]!
    
    @IBOutlet var thirdRoundPlaysAlive: [UIView]!
    //for game control
    
    var isAllowSubmit = false
    
    var alivePlayers = [1,1,1,1,1,1,1,1]
    
    var currentSumbittedAnswer = -1
    
    var currentQuestion: GStackGameQuestion?
    
    var playersNames: [String]?
    
    var firstInRoundTwo = true
    
    var firstInRoundThree = true
    
    //timer
    var timeBarTimer: NSTimer?
    var timeNow: Double?
    var time: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        self.nameBoard.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        self.UIInit()
        
        GStack.sharedInstance.GStackStartGameForTournament(tournament!) { (error, game) -> Void in
            
            //prepare for starting game
            self.game = game
            game?.delegate = self
            game?.startGame()
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        //stop primus when leave the page
        game?.endGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIInit() {
        
        //set question label
        self.questionLabelView.layer.borderColor = UIColor.whiteColor().CGColor
        self.questionLabelView.layer.cornerRadius = 8
        self.questionLabelView.layer.masksToBounds = true
        self.questionLabelView.layer.borderWidth = 2.0
        self.questionLabelView.backgroundColor = UIColor.clearColor()
        self.questionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        //set answers
        
        for view in self.answersView {
            
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            view.layer.borderWidth = 2.0
            view.backgroundColor = UIColor.clearColor()
            self.questionLabel.numberOfLines = 0
        }
        
        //set time bar and clock
        self.timeBarBackGround.layer.borderColor = UIColor.whiteColor().CGColor
        self.timeBarBackGround.layer.cornerRadius = 18
        self.timeBarBackGround.layer.masksToBounds = true
        self.timeBarBackGround.layer.borderWidth = 2.0
        self.timeBarBackGround.backgroundColor = UIColor.clearColor()
        
        self.timeBar.layer.cornerRadius = 18
        self.timeBar.layer.masksToBounds = true
        
        self.clock.layer.cornerRadius = 22
        self.clock.layer.masksToBounds = true
        
        //set nameboard
        for view in self.firstRoundPlayersView {
            
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            view.layer.borderWidth = 2.0
            view.backgroundColor = UIColor.clearColor()
        }
        for view in self.secondRoundPlayersView {
            
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            view.layer.borderWidth = 2.0
            view.backgroundColor = UIColor.clearColor()
        }
        for view in self.thirdRoundPlayersView {
            
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            view.layer.borderWidth = 2.0
            view.backgroundColor = UIColor.clearColor()
        }
        
        
    }
    
    //for time bar
    
    func startTimer() {
        
        //print("call me")
        
        let tempTimeNow = self.timeNow! - 0.05
        self.timeNow = tempTimeNow
        
        self.clockLabel.text = String(Int(tempTimeNow))
        
        var newRect = self.timeBar.frame
        let ratio = 1.0 * (Double(self.time!) - tempTimeNow)/Double(self.time!)
        
        newRect.origin.x = CGFloat(ratio * Double(self.timeBarBackGround.frame.size.width - self.clock.frame.size.width) / 2)
        
        newRect.size.width = CGFloat(self.timeBarBackGround.frame.size.width - 2 * newRect.origin.x)
        
        self.timeBar.frame = newRect
        
        
    }
    
    func setupQuestionUI() {
        
        //clear button text
        for btn in self.answers {
            btn.setTitle("", forState: .Normal)
        }
        for view in self.answersView {
            view.backgroundColor = UIColor.clearColor()
        }
        
        //reset the timebar
        var newRect = self.timeBarBackGround.frame
        newRect.origin = CGPointZero
        self.timeBar.frame = newRect
    }
    
    @IBAction func submitAnswer(sender: UIButton) {
        
        if self.isAllowSubmit {
            
            let index:Int = self.answers.indexOf(sender)!
            
            self.currentSumbittedAnswer = index
            
            self.game?.submitAnswerForQuestion(self.currentQuestion!, answerIndex: index)
            
            self.isAllowSubmit = false
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func gameDidStart(game: GStackGame){
        print("Game did start")
    }
    func willAttemptToReconnect(game: GStackGame, options: PrimusReconnectOptions) {
        print("Will attempt to reconnect")
    }
    func didReconnect(game: GStackGame) {
        print("Did reconnect")
    }
    func didLoseConnection(game: GStackGame) {
        print("Did lose connection")
    }
    func didEstablishConnection(game: GStackGame) {
        print("Did establish connection")
    }
    func didEncounterError(game: GStackGame, error: NSError) {
        print("Did encounter error: \(error)")
    }
    func connectionDidEnd(game: GStackGame) {
        print("Connection did end")
    }
    func connectionDidClose(game: GStackGame) {
        print("Connection did close")
    }
    func didReceiveTimer(game:GStackGame, timer:GStackGameTimer){
        //for helping the ui
    }
    func didReceiveStartRound(game: GStackGame, round: GStackGameStartRound) {
        
        //clear all the ui
        self.setupQuestionUI()
        self.clockLabel.text = ""
        self.nameBoard.hidden = true
        
    }
    func didReceiveRoundResult(game: GStackGame, win: GStackGameRoundResult) {
        
        self.nameBoard.hidden = false
        
    }
    func didReceiveQuestion(game: GStackGame, question: GStackGameQuestion){
        
        self.setupQuestionUI()
        
        //reset the submitted answer
        self.currentSumbittedAnswer = -1
        self.isAllowSubmit = false
        self.currentQuestion = question
        
        //set question
        self.questionLabel.text = question.formattedQuestion()!
        
        //set timer
        self.time = (question.timer as? Int)! / 1000
        self.timeNow = Double(self.time!)
        
        self.clockLabel.text = String(self.time!)
        
        let delayInSeconds = Double(question.promptTime!)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds / 1000 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let ans = question.formattedAnswers()
            //set answers' labels
            for var i = 0; i < 4; i++ {
                self.answers[i].setTitle(ans[i], forState: .Normal)
            }
            self.isAllowSubmit = true
            
            //set timer for timebar
            self.timeBarTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "startTimer", userInfo: nil, repeats: true)
            
        }
        
        
    }
    func didReceivePlayerInfo(game: GStackGame, playerInfo: GStackGamePlayerInfo){
        
        var info = [String]()
        for array in playerInfo.teamNames! {
            info.append(array[0])
        }
        self.playersNames = info
        print(self.playersNames)
        
        for var i = 0; i < 8; i++ {
            let label = self.firstRoundPlayers[i]
            label.text = self.playersNames![i]
        }
        
    }
    func didReceiveCorrectAnswer(game: GStackGame, correctAnswer: GStackGameCorrectAnswer){
        
        self.timeBarTimer?.invalidate()
        
        self.isAllowSubmit = false
        
        let correct = correctAnswer.correctAnswer as! Int
        
        self.answersView[correct].backgroundColor = UIColor.greenColor()
        
        if self.currentSumbittedAnswer >= 0 {
            
            if self.currentSumbittedAnswer != correct {
                self.answersView[self.currentSumbittedAnswer].backgroundColor = UIColor.redColor()
            }
        }
    }
    func didReceiveUpdatedScore(game: GStackGame, updatedScore: GStackGameUpdatedScore){
        //implement latter
    }
    func didReceiveGameResult(game: GStackGame, result: GStackGameResult){
        
        for var i = 0; i < 8; i++ {
            
            if result.teamAlive![i].integerValue != self.alivePlayers[i] {
                
                self.alivePlayers[i] = 0;
                
                self.thirdRoundPlaysAlive[i/4].backgroundColor = UIColor.redColor()
                if i/4 % 2 != 0 {
                    self.thirdRoundPlaysAlive[i/4-1].backgroundColor = UIColor.greenColor()
                } else {
                    self.thirdRoundPlaysAlive[i/4+1].backgroundColor = UIColor.greenColor()
                }

            }
        }

        
        
        
    }
    func didReceiveOtherGameFinished(game: GStackGame,alive:GStackGameOtherGameFinished){
        
        
        for var i = 0; i < 8; i++ {
            
            print("I am in looppppppp")
            
            if alive.alive![i].integerValue != self.alivePlayers[i] {
                
                self.alivePlayers[i] = 0;
                
                print("I am in not alive")
                
                if Int(alive.round!) == 1 {
                    
                    print("I am in round 1")
                    
                    self.firstRoundPlaysAlive[i].backgroundColor = UIColor.redColor()
                    if i % 2 != 0 {
                        self.firstRoundPlaysAlive[i-1].backgroundColor = UIColor.greenColor()
                    } else {
                        self.firstRoundPlaysAlive[i+1].backgroundColor = UIColor.greenColor()
                    }
                    
                    
                } else if Int(alive.round!) == 2 {
                    
                    if self.firstInRoundTwo {
                        
                        self.firstRoundPlaysAlive[i].backgroundColor = UIColor.redColor()
                        if i % 2 != 0 {
                            self.firstRoundPlaysAlive[i-1].backgroundColor = UIColor.greenColor()
                        } else {
                            self.firstRoundPlaysAlive[i+1].backgroundColor = UIColor.greenColor()
                        }
                        
                        //set the names
                        
                        for var j = 0; j < 8; j++ {
                            
                            if self.alivePlayers[j] == 1 {
                                self.secondRoundPlayers[j / 2].text = self.playersNames![j]
                            }
                            
                        }
                        
                        self.firstInRoundTwo = false
                        
                    } else {
                        
                        self.secondRoundPlaysAlive[i/2].backgroundColor = UIColor.redColor()
                        if i/2 % 2 != 0 {
                            self.secondRoundPlaysAlive[i/2-1].backgroundColor = UIColor.greenColor()
                        } else {
                            self.secondRoundPlaysAlive[i/2+1].backgroundColor = UIColor.greenColor()
                        }
                    }
                    
                } else {
                    
                    if self.firstInRoundThree {
                        
                        self.secondRoundPlaysAlive[i/2].backgroundColor = UIColor.redColor()
                        if i/2 % 2 != 0 {
                            self.secondRoundPlaysAlive[i/2-1].backgroundColor = UIColor.greenColor()
                        } else {
                            self.secondRoundPlaysAlive[i/2+1].backgroundColor = UIColor.greenColor()
                        }
                        
                        for var j = 0; j < 8; j++ {
                            
                            if self.alivePlayers[j] == 1 {
                                self.thirdRoundPlayers[j / 4].text = self.playersNames![j]
                            }
                            
                        }
                        
                        self.firstInRoundThree = false
                        
                    }
                }
            }
        }
    }
}
