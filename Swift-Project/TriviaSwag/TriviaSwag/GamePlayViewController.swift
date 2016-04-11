//
//  GamePlayViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController,gStackGameDelegate,triviaGameSubmitAnswerDelegate {

    var tournament: gStackTournament?
    var game: gStackGame?
    
    // for submit answer
    var isAllowSubmit = false
    var currentQuestion: gStackGameQuestion?

    
    // Outlets from storyboard
    @IBOutlet weak var timebarContainerView: UIView!
    @IBOutlet weak var centerControlContainerView: UIView!
    @IBOutlet weak var leftScoreBarContainerView: UIView!
    @IBOutlet weak var rightScoreBarContainerView: UIView!
    @IBOutlet weak var leftAvatarView: UIView!
    @IBOutlet weak var rightAvatorView: UIView!
    
    @IBOutlet weak var leftScoreBoardView: UIView!
    @IBOutlet weak var rightScoreBoardView: UIView!
    @IBOutlet weak var gameInfoView: UIView!
    
    //references for all parts of controllers
    var embedQuestionDisplayController: QuestionDisplayViewController?
    var embedAnswersDisplayController: AnswersDisplayViewController?
    var embedTimeBarController: TimeBarViewController?
    var embedProcessBarController: ProgressBarViewController?
    
    
    deinit{
        
        print("deinit the game view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackground()
        
        //start the game
        gStackStartGameForTournament(self.tournament!) { (error, game) in
            
            if error == nil {
                self.game = game
                game?.delegate = self
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBackground(){
        
        // For controller view
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "GameplayBackground.png")
        
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
        // For left and right score bar
        self.addBackgroundForUIView(self.leftScoreBarContainerView, figureName: "ProgressBarBackground.png")
        self.addBackgroundForUIView(self.rightScoreBarContainerView, figureName: "ProgressBarBackground.png")
       
        // For center view background
        self.addBackgroundForUIView(self.centerControlContainerView, figureName: "QuestionArea.png")
        
        // left and right avatar view
        self.addBackgroundForUIView(self.leftAvatarView, figureName: "AvatarBackground")
        self.addBackgroundForUIView(self.rightAvatorView, figureName: "AvatarBackground")

        // time bar
        self.addBackgroundForUIView(self.timebarContainerView, figureName: "TimeBar.png")
        
    }
    
    func addBackgroundForUIView(view: UIView, figureName: String){
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: figureName)
        
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
    }

    
    
    // Doing Animation for setup
    
    func setupAnimations() {
        
        self.setupAnimation(self.leftAvatarView)
        self.setupAnimation(self.leftScoreBarContainerView)
        self.setupAnimation(self.rightAvatorView)
        self.setupAnimation(self.rightScoreBarContainerView)
        self.setupAnimation(self.timebarContainerView)
        self.setupAnimation(self.leftScoreBoardView)
        self.setupAnimation(self.rightScoreBoardView)
        self.setupAnimation(self.gameInfoView)
        
    }
    
    func setupAnimation(view: UIView){
        
        let backgroundView = view.subviews[0]
        let tempBounds = backgroundView.bounds
        backgroundView.bounds = CGRectMake(0, 0, 0, 0)
        backgroundView.alpha = 0;
        
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            
            backgroundView.bounds = tempBounds
            backgroundView.alpha = 1
            
            }, completion: nil)
        
    }

    
    
    @IBAction func testButton(sender: AnyObject) {
        
            game?.endGame()
        
            self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // triviaGameSubmitAnswerDelegate function
    
    func submitAnswer(num: Int){
        
        if self.isAllowSubmit {
            
            self.game?.submitAnswerForQuestion(self.currentQuestion!, answerIndex: num)
            
            // stop time bar
            self.embedTimeBarController?.invalidateTimer()
            
            self.isAllowSubmit = false
        }
        
    }
 
    
    
    // gStackGame Delegate Functions
    
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
    func didReceiveTimer(timer:gStackGameTimer){
        //for helping the ui
        
    }
    func didReceiveErrorMsg(error:gStackGameErrorMsg){
        print("Receive an error: \(error.error)")
    }
    func didReceiveStartRound( round: gStackGameStartRound) {
        
    }
    func didReceiveRoundResult( win: gStackGameRoundResult) {
        
    }
    func didReceiveQuestion(question: gStackGameQuestion){
        
        // reset submit value
        self.currentQuestion = question
        self.isAllowSubmit = true
        
        let questionText = question.formattedQuestion()
        
        self.embedQuestionDisplayController?.readyForDisplayQuestionLabel(questionText!)
        
        let answers = question.formattedAnswers()
        
        let delayInSeconds = Double(question.promptTime!)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds / 1000 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.embedTimeBarController?.initTimeBar()

            self.embedAnswersDisplayController?.readyForDisplayAnswerViews(answers)
            
            self.embedTimeBarController?.startTiming((question.timer?.integerValue)!)
            
        }
        
    }
    func didReceivePlayerInfo(playerInfo: gStackGamePlayerInfo){
        
        
    }
    func didReceiveCorrectAnswer(correctAnswer: gStackGameCorrectAnswer){
        
        let timer = correctAnswer.timer?.integerValue
        
        // display right answer
        let correct = correctAnswer.correctAnswer?.integerValue
        self.embedAnswersDisplayController?.displayForRightAnswer(correct!)
        
        // Display correct for a while before fade out
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(timer! - 2000) / 1000 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
        
            self.embedQuestionDisplayController?.questionLabelFadeOut()
            self.embedAnswersDisplayController?.answerButtonsFadeOut()
            self.embedTimeBarController?.clearTimebar()
        }
    }
    
    func didReceiveUpdatedScore(updatedScore: gStackGameUpdatedScore){
        
        //update the progressbar
        self.embedProcessBarController?.updateProgressBarScore(updatedScore.teamScores!)
        
        if updatedScore.rightOrWrong?.integerValue == 0 {
            self.embedAnswersDisplayController?.displayForWrongAnswer((updatedScore.answerNumber?.integerValue)!)
        }
        
    }
    
    func didReceiveGameResult(result: gStackGameResult){
        
    }
    
    func didReceiveOtherGameFinished(alive:gStackGameOtherGameFinished){
        
        
    }

    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let embeddedViewController = segue.destinationViewController as? QuestionDisplayViewController where segue.identifier == "EmbedQuestionDisplaySegue" {
            self.embedQuestionDisplayController = embeddedViewController
        } else if let embeddedViewController = segue.destinationViewController as? AnswersDisplayViewController where segue.identifier == "EmbedAnswersDisplaySegue" {
            self.embedAnswersDisplayController = embeddedViewController
            embeddedViewController.delegate = self
        } else if let embeddedViewController = segue.destinationViewController as? TimeBarViewController where segue.identifier == "EmbedFirstTimeBarSegue" {
            self.embedTimeBarController = embeddedViewController
            embeddedViewController.playerNum = "TimePlayer1"
        } else if let embeddedViewController = segue.destinationViewController as? ProgressBarViewController where segue.identifier == "EmbedFirstProgressBarSegue" {
            self.embedProcessBarController = embeddedViewController
            
        }
        
    }
    

}
