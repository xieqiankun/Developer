//
//  PlayTraditionalViewController.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class PlayTraditionalViewController: UIViewController,GStackGameDelegate {

    
    var tournament: GStackTournament?
    var game: GStackGame?
    
    //for ui
    //for question label
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionLabelView: UIView!
    
    //for answers
    @IBOutlet var answers: [UIButton]!
    @IBOutlet var answersView: [UIView]!
    
    //for timebar
    @IBOutlet weak var timeBarBackGround: UIView!
    @IBOutlet weak var timeBar: UIView!
    
    @IBOutlet weak var clock: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    
    //for game control
    
    var isAllowSubmit = false
    
    var currentSumbittedAnswer = -1
    
    var currentQuestion: GStackGameQuestion?
    
    var playersNames: [String]?
    
    var isNeedToForfeit = true
    
    //timer
    var timeBarTimer: NSTimer?
    var timeNow: Double?
    var time: Int?
    
    
    /**
     Prepare to start the game and set the GStackGame Instance's delegate to self
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIInit()
        
        GStack.sharedInstance.GStackStartGameForTournament(tournament!) { (error, game) -> Void in
            
            //prepare for starting game
            self.game = game
            game?.delegate = self
            game?.startGame()
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        //use endgame func to disconnect with server
        game?.endGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - setup UI
    func UIInit() {
        
        //set background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)

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
    

    
    //MARK: - helper func and action
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

    
    @IBAction func backToMain(sender: AnyObject) {
        
        //we need to dialog box asking if the user want to forfeit, and if so we send a forefeit message to the server
        if isNeedToForfeit {
        
        let title = "Back to Main"
        let message = "Are you sure"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Forfeit", style: UIAlertActionStyle.Destructive, handler: {
            (action) -> Void in
            
            //send forfeit message
            self.game?.sendForfeitMessage()
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.game = nil
                self.tournament = nil
            })
            // self.performSegueWithIdentifier("Main", sender: self)
            
        })
        ac.addAction(deleteAction)
        
        //present the alert controller
        presentViewController(ac, animated: true, completion: nil)
            
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
 
    
    @IBAction func submitAnswer(sender: UIButton) {
        
        if self.isAllowSubmit {
            
            let index:Int = self.answers.indexOf(sender)!
            
            self.currentSumbittedAnswer = index
            
            self.game?.submitAnswerForQuestion(self.currentQuestion!, answerIndex: index)
            
            self.isAllowSubmit = false
        }
    }
    
    
    
    // MARK: - Delegation part

    
    func gameDidStart(){
        print("Game did start")
    }
    func willAttemptToReconnect(options: PrimusReconnectOptions) {
        print("Will attempt to reconnect")
    }
    func didReconnect() {
        print("Did reconnect")
    }
    func didLoseConnection() {
        print("Did lose connection")
    }
    func didEstablishConnection() {
        print("Did establish connection")
    }
    func didEncounterError(error: NSError) {
        print("Did encounter error: \(error)")
    }
    func connectionDidEnd() {
        print("Connection did end")
    }
    func connectionDidClose() {
        print("Connection did close")
    }
    func didReceiveTimer(timer:GStackGameTimer){
        //for helping the ui
    }
    func didReceiveErrorMsg(error:GStackGameErrorMsg){
        print("Receive an error: \(error.error)")
    }
    func didReceiveStartRound( round: GStackGameStartRound) {
        
        //clear all the ui
        self.setupQuestionUI()
        self.clockLabel.text = ""
        
    }
    func didReceiveRoundResult( win: GStackGameRoundResult) {
        
    }
    func didReceiveQuestion(question: GStackGameQuestion){
        
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
            for i in 0 ..< 4 {
                self.answers[i].setTitle(ans[i], forState: .Normal)
            }
            self.isAllowSubmit = true
            
            //set timer for timebar
            self.timeBarTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "startTimer", userInfo: nil, repeats: true)
            
        }
        
        
    }
    func didReceivePlayerInfo(playerInfo: GStackGamePlayerInfo){
        
        var info = [String]()
        for array in playerInfo.teamNames! {
            info.append(array[0])
        }
        self.playersNames = info
        
    }
    func didReceiveCorrectAnswer(correctAnswer: GStackGameCorrectAnswer){
        
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
    func didReceiveUpdatedScore(updatedScore: GStackGameUpdatedScore){
        //implement latter
    }
    func didReceiveGameResult(result: GStackGameResult){

        self.setupQuestionUI()
        self.questionLabel.text = "Game Over"
        
        self.isNeedToForfeit = false
        
        
        //auto go back to main
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.game = nil
                self.tournament = nil
            })
        }
        
    }
    func didReceiveOtherGameFinished(alive:GStackGameOtherGameFinished){
        
        
    }
}
