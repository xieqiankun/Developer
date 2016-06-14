//
//  GameViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/23/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kTimebarColor = UIColor.yellowColor()

class GameViewController: UIViewController {
    
    var currentTournament: gStackTournament?
    var game: gStackGame?
    
    // for submit answer
    var isAllowSubmit = false
    var selectedLocation: CGPoint?
    
    var currentQuestion: gStackGameQuestion?
    
    var questions = [gStackGameQuestion]()
    var answers = [gStackGameCorrectAnswer]()
    
    // MARK: - IBOutlet
    // constraints for animations
    @IBOutlet var headerHeightConstrain: NSLayoutConstraint!
    @IBOutlet var questionHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var resultHeightConstrain:NSLayoutConstraint!
    @IBOutlet weak var resultWidthConstrain:NSLayoutConstraint!
    
    @IBOutlet weak var questionBackgroundPrepareHeightConstrain:NSLayoutConstraint!
    @IBOutlet weak var questionBackgroundPlayingHeightConstrain:NSLayoutConstraint!
    
    @IBOutlet weak var timebarWidthConstrain:NSLayoutConstraint!


    
    // container views
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    // answer view part
    @IBOutlet weak var answer1: UIView!
    @IBOutlet weak var answer2: UIView!
    @IBOutlet weak var answer3: UIView!
    @IBOutlet weak var answer4: UIView!
    
    @IBOutlet weak var answerLabel1: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var answerLabel3: UILabel!
    @IBOutlet weak var answerLabel4: UILabel!
    
    
    // question view part
    @IBOutlet weak var questionBackgroundView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    // header part
    @IBOutlet weak var tournamentNameLabel: UILabel!
    @IBOutlet weak var tournamentQuestionNumberLabel: UILabel!

    
    // clock part
    @IBOutlet weak var clock: UIStackView!
    @IBOutlet weak var clockView: UIView!
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var clockbar: UIView!
    
    // result part
    @IBOutlet weak var resultBackgroundView: UIView!
    @IBOutlet weak var avatorGif: UIImageView!
    @IBOutlet weak var avatorGif_Incorrect: UIImageView!

    @IBOutlet weak var funnyGif: AnimatedImageView!
    @IBOutlet weak var funnyGif_Incorrect: AnimatedImageView!

    @IBOutlet weak var funnyLabel: UILabel!
    @IBOutlet weak var funnyLabel_Incorrect: UILabel!


    // botton part
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userScore: UILabel!
    
    @IBOutlet weak var leaderDisplayName: UILabel!
    @IBOutlet weak var leaderScore: UILabel!
    
    @IBOutlet var questionMarkers: [UIView]!
    @IBOutlet var questionMarkerIndicators: [UIImageView]!
    @IBOutlet var questionMakerLabels: [UILabel]!
    
    // MARK: - prepare the ui and labels
    deinit{
        // clear it cause using strong reference
        headerHeightConstrain = nil
        questionHeightConstrain = nil

        print("deinit the game view controller")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initGamePlayUI()

    }
    var isAllowToStart = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAllowToStart {
           isAllowToStart = false
            
            prepareState(false,completion:nil)

            preGameAnimationInit()
            
            prepareGamePlayUI()
            
            // test network
            SimplePingClient.pingHost { [weak self]latency in
                print("latency is: \(latency)")
                if let lat = latency {
                    let num = Int(lat)
                    // set the max delay to 3 seconds
                    if num <= 3000 {
                        if let strongSelf = self {
                            strongSelf.startgame()
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            let button1 = AlertButton(title: "", imageNames: ["PlayNowButton-Untouched","PlayNowButton-Touched"], style: .Custom,action: {
                                if let strongSelf = self {
                                    strongSelf.startgame()
                                }
                            })
                            let button2 = AlertButton(title: "", imageNames: [], style: .Cancel, action: nil)
                            let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button1,button2], title: "Slimmy Internet!", message: "Are you sure you want to play?")
                            if let strongSelf = self {
                                strongSelf.presentViewController(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }

            
            
        }
       
    }
    
    func startgame() {
        preGameAnimation()

        if let tournament = self.currentTournament {
            gStackStartGameForTournament(tournament) { (error, game) in
                
                if error == nil {
                    self.game = game
                    game?.delegate = self
                    
                }
            }
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        endGame()

    }
    override func viewDidLayoutSubviews() {
        
        ballView.layer.cornerRadius = ballView.bounds.height / 2
        ballView.backgroundColor = kTimebarColor
        
        clockView.layer.cornerRadius = clockView.bounds.height / 2
        clockView.layer.borderColor = kTimebarColor.CGColor
        clockView.layer.borderWidth = 1.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func initGamePlayUI() {
        
        // clear container background
        questionView.backgroundColor = UIColor.blackColor()
        resultView.backgroundColor = UIColor.blackColor()
        answersView.backgroundColor = UIColor.blackColor()
        headerView.backgroundColor = UIColor.blackColor()
        statusView.backgroundColor = UIColor.blackColor()
        
        for view in questionMarkers {
            view.backgroundColor = UIColor.clearColor()
        }

        // setup
        questionBackgroundView.layer.cornerRadius = 15
//        questionBackgroundView.layer.borderColor = kQuestionBorderColor.CGColor
//        questionBackgroundView.layer.borderWidth = 3.0
        
        
        answer1.layer.cornerRadius = 20
        answer1.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer1.layer.borderWidth = 3.0
        
        answer2.layer.cornerRadius = 20
        answer2.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer2.layer.borderWidth = 3.0
        
        answer3.layer.cornerRadius = 20
        answer3.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer3.layer.borderWidth = 3.0
        
        answer4.layer.cornerRadius = 20
        answer4.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer4.layer.borderWidth = 3.0
        
        questionBackgroundView.backgroundColor = kGameplayQuestionAreaFill
        
        //setup tournament Name and colors
        if currentTournament != nil {
            tournamentNameLabel.text = currentTournament!.name
            tournamentNameLabel.textColor = kGameplayFutureQuestionCircleStroke
        }
        tournamentQuestionNumberLabel.textColor = kTimebarColor
        funnyLabel.textColor = kTimebarColor
        funnyLabel_Incorrect.textColor = kTimebarColor

        //clock part
        clockbar.backgroundColor = kTimebarColor
        clockView.backgroundColor = UIColor.blackColor()
        
        clock.alpha = 0

        //user score part
        userDisplayName.text = gStackDisplayName
        userScore.text = "$0.0"
        
        if let num = currentTournament?.questions?.num?.integerValue {
            for index in num...9 {
                print(index)
                questionMarkers[num].removeFromSuperview()
                questionMarkers.removeAtIndex(num)
                questionMakerLabels.removeAtIndex(num)
                questionMarkerIndicators.removeAtIndex(num)
            }
            
            self.view.layoutIfNeeded()
            
            for view in questionMarkers {
                view.layer.cornerRadius = view.bounds.height / 2
                //view.layer.borderColor = kGameplayFutureQuestionCircleStroke.CGColor
                view.layer.borderWidth = 3.0
            }
            
        }
        
        // set correct gif and incorrect gif border
        funnyGif.layer.cornerRadius = 20
        funnyGif.layer.borderWidth = 3.0
        funnyGif.clipsToBounds = true
        
        funnyGif_Incorrect.layer.cornerRadius = 20
        funnyGif_Incorrect.layer.borderWidth = 3.0
        funnyGif_Incorrect.clipsToBounds = true

        
        // set avatar gifs
        pregameLoading.image = UIImage.gifWithName("PregameLoading")
        go.image = UIImage.gifWithName("Go2")
        onYourMonster.image = UIImage.gifWithName("OnYourMonster2")
        goSet.image = UIImage.gifWithName("GetSet2")
    }
    
    
    func prepareGamePlayUI() {
        
        // set game leader
        // TODO: - there be may a bug for not cacheing the leaderboard
        if let t = currentTournament where t.isPractice == true {
            leaderDisplayName.text = "Practice"
            leaderScore.text = "Mode"
        } else if let uuid = currentTournament?.uuid, let leaderboard = gStackCacheDataManager.sharedInstance.getLeaderboard(currentTournament!){
            if let leader = leaderboard.leaders.first{
                leaderDisplayName.text = leader.displayName
                if let score = leader.correctTime?.doubleValue{
                    leaderScore.text = String(score / 1000)
                }
            }
        }
        
        funnyGif.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        funnyGif_Incorrect.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor

        for view in questionMarkers {
            view.layer.borderColor = kGameplayFutureQuestionCircleStroke.CGColor
        }
        for label in questionMakerLabels {
            label.hidden = false
            label.textColor = kGameplayFutureQuestionCircleStroke
        }
        for view in questionMarkerIndicators {
            view.hidden = true
        }
        //set gif
        avatorGif.image = UIImage.gifWithName("Win-BlueMonster(reduced)")
        avatorGif_Incorrect.image = UIImage.gifWithName("Lose-BlueMonster(reduced)")
        
    }
    
    
    // MARK: - End Game
    var isForfeit = false
    
    func stopPlaying() {
        
        let button1 = AlertButton(title: "Forfeit", imageNames: [], style: .Normal,action: {
            self.isForfeit = true
            self.game?.sendForfeitMessage()
            self.endGame()
            self.performSegueWithIdentifier("backToMain", sender: nil)

        })
        let button2 = AlertButton(title: "", imageNames: [], style: .Cancel, action: nil)
        let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button1,button2], title: "Forfeit!", message: "Are you sure you want to stop?")
        
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func endGame() {
        
        if game != nil {
            game!.endGame()
            game = nil
        }
        
    }
    
    
    //MARK: - Animation part, define three state of game: prepare state, playing state, result state
    //        using antolayout to set the animation for the ui
    
    func prepareState(animate:Bool, completion: (Void -> Void)?){
        
        headerHeightConstrain.active = true
        questionHeightConstrain.active = true
        
        questionBackgroundPlayingHeightConstrain.priority = 998
        questionBackgroundPrepareHeightConstrain.priority = 999
        
        timebarWidthConstrain.constant = 1
        
        if animate {
 
            UIView.animateWithDuration(0.3, animations: { 
                self.questionView.alpha = 1
                self.questionLabel.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    if completion != nil {
                        completion!()
                    }
            })

        } else {
            self.view.layoutIfNeeded()
            if completion != nil {
                completion!()
            }
        }
    }
    
    func playingState(animate: Bool, completion:(Void -> Void)?){
        
        // change active or not to change the constraint
        headerHeightConstrain.active = false
        questionHeightConstrain.active = false
        
        questionBackgroundPlayingHeightConstrain.priority = 999
        questionBackgroundPrepareHeightConstrain.priority = 998
        
        if animate {
            UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
                self.questionLabel.alpha = 0
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.view.setNeedsLayout()
            })
            UIView.animateWithDuration(0.2, delay: 0.3, options: [], animations: {
                self.timebarWidthConstrain.constant = self.questionBackgroundView.frame.width - self.ballView.frame.width - self.clockView.frame.width
                self.clock.alpha = 1
                self.questionLabel.alpha = 1
                }, completion: {
                    finished in
                    if completion != nil {
                        completion!()
                    }
            })

        } else {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func resultState(animate: Bool) {
        
        // change priority to change the constraint
        resultWidthConstrain.priority = 250
        resultHeightConstrain.priority = 250
        self.view.layoutIfNeeded()
        
        if animate {
            UIView.animateWithDuration(0.2, animations: {
                self.questionView.alpha = 0
                self.clock.alpha = 0
            })
            UIView.animateWithDuration(0.2, delay: 0.10, options: [], animations: {
                self.resultWidthConstrain.priority = 999
                self.resultHeightConstrain.priority = 999
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            questionView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    // MARK: - Touching for submitting answer
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        for touch: AnyObject in touches {
            
            let t: UITouch = touch as! UITouch
            let location = t.locationInView(self.view)
            
            if view.hitTest(location, withEvent: nil) == clockView{
                stopPlaying()
            }
            
            if isAllowSubmit {
                
//                setNotTouchButtons()
                // a little bit complicated, test tapping and submit answer
                if view.hitTest(location, withEvent: nil) == answer1 {
                    let relativeLocation = t.locationInView(answer1)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(0)
                    setNotTouchButtons(answer1)
                    
                } else if view.hitTest(location, withEvent: nil) == answer2 {
                    let relativeLocation = t.locationInView(answer2)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(1)
                    setNotTouchButtons(answer2)

                    
                }  else if view.hitTest(location, withEvent: nil) == answer3 {
                    let relativeLocation = t.locationInView(answer3)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(2)
                    setNotTouchButtons(answer3)

                    
                } else if view.hitTest(location, withEvent: nil) == answer4 {
                    let relativeLocation = t.locationInView(answer4)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(3)
                    setNotTouchButtons(answer4)

                }
            }
            
        }
        
    }
    
    func submitAnswer(num: Int){
        
        if self.isAllowSubmit {
            
            self.game?.submitAnswerForQuestion(self.currentQuestion!, answerIndex: num)
            
            // stop time bar
            //stop clock
            NSLog("submit answer")
            self.isAllowSubmit = false
        }
        
    }
    // ripple animation for submit the question
    func rippleAnimation(view:UIView, relativeLoaction: CGPoint, color: UIColor){
        
        NSLog("prepare aniamtion")

        var option = Option()
        //configure
        option.radius = CGFloat(150.0)
        option.duration = CFTimeInterval(0.3)
        option.fillColor = color
        
        rippleTouchAnimation(view, location: relativeLoaction, option: option)
        
        NSLog("run aniamtion")

        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Game logic part variable
    
  
    var timer: NSTimer?
    var step = CGFloat(0.0)
    var timeInterval = 0.03
    
    
    
    // pre game aniamtion
    @IBOutlet weak var pregameView:UIView!
    @IBOutlet weak var pregameLoading: UIImageView!
    
    @IBOutlet weak var goSet: UIImageView!
    @IBOutlet weak var go: UIImageView!
    @IBOutlet weak var onYourMonster: UIImageView!

    
    @IBOutlet  var pre_11: NSLayoutConstraint!
    @IBOutlet  var pre_12: NSLayoutConstraint!
    @IBOutlet  var pre_13: NSLayoutConstraint!
    @IBOutlet  var pre_21: NSLayoutConstraint!
    @IBOutlet  var pre_22: NSLayoutConstraint!
    @IBOutlet  var pre_23: NSLayoutConstraint!
    @IBOutlet  var pre_31: NSLayoutConstraint!
    @IBOutlet  var pre_32: NSLayoutConstraint!
    @IBOutlet  var pre_33: NSLayoutConstraint!
    
    @IBOutlet  var pre_height1: NSLayoutConstraint!
    @IBOutlet  var pre_height2: NSLayoutConstraint!
    @IBOutlet  var pre_height3: NSLayoutConstraint!
    
    @IBOutlet  var precount_11: NSLayoutConstraint!
    @IBOutlet  var precount_12: NSLayoutConstraint!
    @IBOutlet  var precount_13: NSLayoutConstraint!
    @IBOutlet  var precount_21: NSLayoutConstraint!
    @IBOutlet  var precount_22: NSLayoutConstraint!
    @IBOutlet  var precount_23: NSLayoutConstraint!
    @IBOutlet  var precount_31: NSLayoutConstraint!
    @IBOutlet  var precount_32: NSLayoutConstraint!
    @IBOutlet  var precount_33: NSLayoutConstraint!


    @IBOutlet  var precount_height1: NSLayoutConstraint!
    @IBOutlet  var precount_height2: NSLayoutConstraint!
    @IBOutlet  var precount_height3: NSLayoutConstraint!

    @IBOutlet weak var preImage_1: UIImageView!
    @IBOutlet weak var preImage_2: UIImageView!
    @IBOutlet weak var preImage_3: UIImageView!

    @IBOutlet weak var finishPrepare: NSLayoutConstraint!
    
    var isFirstQuestion = true
    
}
































