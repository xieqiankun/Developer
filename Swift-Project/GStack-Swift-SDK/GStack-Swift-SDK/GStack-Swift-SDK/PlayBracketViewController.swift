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
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var questionLabelView: UIView!
    
    //TO-DO make the player one and player two
    
    @IBOutlet var answers: [UIButton]!
    
    @IBOutlet var answersView: [UIView]!
    
    @IBOutlet weak var timeBarBackGround: UIView!
    @IBOutlet weak var timeBar: UIView!
    
    @IBOutlet weak var clock: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    
    @IBOutlet weak var nameBoard: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        self.UIInit()
        
        
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
        
        //set answers
        
        for view in self.answersView {
            
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            view.layer.borderWidth = 2.0
            view.backgroundColor = UIColor.clearColor()
        }
        
        //set time bar and clock
        self.timeBarBackGround.layer.borderColor = UIColor.whiteColor().CGColor
        self.timeBarBackGround.layer.cornerRadius = 18
        self.timeBarBackGround.layer.masksToBounds = true
        self.timeBarBackGround.layer.borderWidth = 2.0
        self.timeBarBackGround.backgroundColor = UIColor.clearColor()
        
        self.timeBar.layer.cornerRadius = 18
        self.timeBar.layer.masksToBounds = true
        
        self.clock.layer.cornerRadius = 25
        self.clock.layer.masksToBounds = true
        
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
        
    }
    func didReceiveQuestion(game: GStackGame, question: GStackGameQuestion){
        
    }
    func didReceivePlayerInfo(game: GStackGame, playerInfo: GStackGamePlayerInfo){
        
    }
    func didReceiveCorrectAnswer(game: GStackGame, correctAnswer: GStackGameCorrectAnswer){
        
    }
    func didReceiveUpdatedScore(game: GStackGame, updatedScore: GStackGameUpdatedScore){
        //implement latter
    }
    func didReceiveGameResult(game: GStackGame, result: GStackGameResult){
        
    }
    func didReceiveOtherGameFinished(game: GStackGame,alive:GStackGameOtherGameFinished){
        
    }
    
    

}
