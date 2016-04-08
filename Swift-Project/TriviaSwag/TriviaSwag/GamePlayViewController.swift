//
//  GamePlayViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController,gStackGameDelegate {

    var tournament: gStackTournament?
    var game: gStackGame?
    
    
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
        self.setupAnimation(self.leftScoreBoardView)
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
        
        //clear all the ui

        
    }
    func didReceiveRoundResult( win: gStackGameRoundResult) {
        
    }
    func didReceiveQuestion(question: gStackGameQuestion){
        
        
    }
    func didReceivePlayerInfo(playerInfo: gStackGamePlayerInfo){
        
        
    }
    func didReceiveCorrectAnswer(correctAnswer: gStackGameCorrectAnswer){
        
    }
    
    func didReceiveUpdatedScore(updatedScore: gStackGameUpdatedScore){
        //implement latter
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
        }
        
    }
    

}
