//
//  GameViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/23/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

//let kQuestionBorderColor = UIColor.blueColor()
//let kQuestionBackgroundColor = UIColor.blueColor()
//let kAnswerBorderColor = UIColor.blueColor()
//let kAnswerBackgroundColor = UIColor.darkGrayColor()
//let kRightAnswerColor = UIColor.greenColor()
//let kWrongAnswerColor = UIColor.redColor()
//let kQuestionMarkerNormalColor = UIColor.blueColor()
//let kQuestionMarkerAnsweringColor = UIColor.yellowColor()
//let kQuestionMarkerCorrectColor = UIColor.greenColor()
//let kQuestionMarkerIncorrectColor = UIColor.redColor()
//let kTimebarNormalColor = UIColor.yellowColor()
//let kResultCorrectColor = UIColor.greenColor()
//let kResultIncorrectColor = UIColor.redColor()

let kTimebarColor = UIColor.yellowColor()

class GameViewController: UIViewController {
    
    var currentTournament: gStackTournament?
    var game: gStackGame?
    
    // for submit answer
    var isAllowSubmit = false
    var selectedLocation: CGPoint?
    
    var currentQuestion: gStackGameQuestion?
    
    
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
    @IBOutlet weak var funnyGif: UIImageView!
    @IBOutlet weak var funnyGif_Incorrect: UIImageView!

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
        prepareState(false,completion:nil)
        
        // test network
        SimplePingClient.pingHost { latency in
            print("latency is: \(latency)")
            
            if let lat = latency {
                let num = Int(lat)
                // set the max delay to 3 seconds
                if num <= 3000 {
                    self.startgame()
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let button1 = AlertButton(title: "", imageNames: ["PlayNowButton-Untouched","PlayNowButton-Touched"], style: .Custom,action: {
                            self.startgame()
                        })
                        let button2 = AlertButton(title: "", imageNames: [], style: .Cancel, action: nil)
                        let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button1,button2], title: "Slimmy Internet!", message: "Are you sure you want to play?")
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func startgame() {
        
        if let tournament = self.currentTournament {
            gStackStartGameForTournament(tournament) { (error, game) in
                
                if error == nil {
                    self.game = game
                    game?.delegate = self
                    
                }
            }
        }
        
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
                view.layer.borderColor = kGameplayFutureQuestionCircleStroke.CGColor
                view.layer.borderWidth = 3.0
            }
            
        }
        
        // set correct gif and incorrect gif border
        funnyGif.layer.cornerRadius = 20
        funnyGif.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        funnyGif.layer.borderWidth = 3.0
        funnyGif.clipsToBounds = true
        
        funnyGif_Incorrect.layer.cornerRadius = 20
        funnyGif_Incorrect.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        funnyGif_Incorrect.layer.borderWidth = 3.0
        funnyGif_Incorrect.clipsToBounds = true

        
        for label in questionMakerLabels {
            label.textColor = kGameplayFutureQuestionCircleStroke
        }
        for imageview in questionMarkerIndicators{
            imageview.hidden = true
        }
        
        
        
        // set game leader
        if let uuid = currentTournament?.uuid, let leaderboard = gStackCachedLeaderBoard[uuid]{
            if let leader = leaderboard.leaders.first{
                leaderDisplayName.text = leader.displayName
                if let score = leader.correctTime?.doubleValue{
                    leaderScore.text = String(score / 1000)
                }
            }
        }
    }
    

    @IBAction func test () {
        
        if headerHeightConstrain.active {
            playingState(true, completion: nil)
        } else {
            prepareState(true,completion: nil)
        }
        
    }
    
    @IBAction func test2() {
        
        //resultState(true)
        rippleAnimation(answer2, relativeLoaction: CGPointZero, color: kGameplayAnswerButtonTouchedCorrectStroke)
        
        
    }
    @IBAction func test3() {
        
        //resultState(true)
        //rippleAnimation(answer3, relativeLoaction: CGPointZero, color: UIColor.blackColor())
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func stopPlaying() {
        
        game?.sendForfeitMessage()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //MARK: - Animation part, define three state of game: prepare state, playing state, result state
    //        using antolayout to set the animation for the ui
    
    func prepareState(animate:Bool, completion: ((Bool)-> Void)?){
        
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
                }, completion: completion)

        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    func playingState(animate: Bool, completion:((Bool) -> Void)?){
        
        // change active or not to change the constraint
        headerHeightConstrain.active = false
        questionHeightConstrain.active = false
        
        questionBackgroundPlayingHeightConstrain.priority = 999
        questionBackgroundPrepareHeightConstrain.priority = 998
        
        
        if animate {
            UIView.animateWithDuration(0.3) {
                self.questionLabel.alpha = 0
               
                self.view.layoutIfNeeded()
            }
            UIView.animateWithDuration(0.2, delay: 0.28, options: [], animations: {
                self.timebarWidthConstrain.constant = self.questionBackgroundView.frame.width - self.ballView.frame.width - self.clockView.frame.width
                self.clock.alpha = 1
                self.questionLabel.alpha = 1
                }, completion: completion)
//            UIView.animateWithDuration(0.1, delay: 0.4, options: [], animations: {
//
//                }, completion: completion)
            
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
        option.duration = CFTimeInterval(0.4)
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
    
    
    // MARK: - Game logic part
    
    func clearAnswerBackground() {
        answer1.backgroundColor = kGameplayAnswerButtonUntouchedFill
        answer2.backgroundColor = kGameplayAnswerButtonUntouchedFill
        answer3.backgroundColor = kGameplayAnswerButtonUntouchedFill
        answer4.backgroundColor = kGameplayAnswerButtonUntouchedFill
    }
    
    func clearLabels() {
        

            self.answerLabel1.text = ""
            self.answerLabel2.text = ""
            self.answerLabel3.text = ""
            self.answerLabel4.text = ""
            self.questionLabel.text = ""
        
        
    }
    
    func setQuestionLabelWithCurrentQuestion() {
        if let question = self.currentQuestion {
            questionLabel.text = question.formattedQuestion()
            
        }
    }
    
    func setGifs() {
        funnyLabel.hidden = false
        funnyGif.hidden = false
        funnyLabel_Incorrect.hidden = false
        funnyGif_Incorrect.hidden = false
        
        if let store = triviaCurrentGifStore {
            
            let correct = store.getRandomGif(true)
            let correctURL = NSURL(string: correct.image!)
            funnyGif.image = UIImage.animatedImageWithAnimatedGIFURL(correctURL!)
            funnyLabel.text = correct.text!
            
            let incorrect = store.getRandomGif(false)
            let incorrectURL = NSURL(string: incorrect.image!)
            funnyGif_Incorrect.image = UIImage.animatedImageWithAnimatedGIFURL(incorrectURL!)
            funnyLabel_Incorrect.text = incorrect.text!

        }
        
    }
    
    func setAnswerLabelsWithCurrentQuestion() {
        if let question = self.currentQuestion {
            
            answerLabel1.text = question.formattedAnswers()[0]
            answerLabel2.text = question.formattedAnswers()[1]
            answerLabel3.text = question.formattedAnswers()[2]
            answerLabel4.text = question.formattedAnswers()[3]
        }
    }
    
    func setCurrentQuestionNumber(){
        
        if let question = currentQuestion {
            
            self.tournamentQuestionNumberLabel.text = "Question: \((question.questionNum?.intValue)! + 1)"
            
        }
        
    }
    
    
    
    func setCorrectResult() {
        
        resultBackgroundView.layer.cornerRadius = 15
        resultBackgroundView.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        resultBackgroundView.layer.borderWidth = 3.0
        
        resultBackgroundView.backgroundColor = kGameplayAnswerButtonTouchedCorrectFill
        
        //let (str, img) = GIFStore.sharedInstance.getRandomGif(true)
        
        avatorGif.image = UIImage.gifWithName("Win-BlueMonster")
        //funnyGif.image = img
        //funnyLabel.text = str
        funnyLabel_Incorrect.hidden = true
        funnyGif_Incorrect.hidden = true
    }
    
    func setIncorrectResult() {
        
        resultBackgroundView.layer.cornerRadius = 15
        resultBackgroundView.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        resultBackgroundView.layer.borderWidth = 3.0
        
        resultBackgroundView.backgroundColor = kGameplayAnswerButtonTouchedIncorrectFill
        
        //let (str, img) = GIFStore.sharedInstance.getRandomGif(false)

        avatorGif.image = UIImage.gifWithName("Lose-BlueMonster")
//        funnyGif.image = img
//        funnyLabel.text = str
        funnyLabel.hidden = true
        funnyGif.hidden = true

    }
    
    func setIncorrectButton(num: Int){
        switch num {
        case 0:
            answer1.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        case 1:
            answer2.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        case 2:
            answer3.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        case 3:
            answer4.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        default:
            break
        }
    }
    
    func setCorrectButton(num: Int){
        
        switch num {
        case 0:
            answer1.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        case 1:
            answer2.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        case 2:
            answer3.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        case 3:
            answer4.layer.borderColor = kGameplayAnswerButtonTouchedCorrectStroke.CGColor
        default:
            break
        }
    }
    
    func setUntouchButtons(){
        
        answer1.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer2.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer3.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor
        answer4.layer.borderColor = kGameplayAnswerButtonUntouchedStroke.CGColor

    }
    
    func setNotTouchButtons(view: UIView){
        
        view.layer.borderColor = kGameplayAnswerButtonNotTouchedIncorrectStroke.CGColor
    }
    
    
    func setCurrentQuestionMarker(num: Int) {

        let v = questionMarkers[num]
        v.layer.borderColor = kGameplayCurrentQuestionCircleStroke.CGColor
        let l = questionMakerLabels[num]
        l.textColor = kGameplayCurrentQuestionCircleStroke
        
    }
    func setCorrectQuestionMarker(num: Int) {
        
        let v = questionMarkers[num]
        v.layer.borderColor = kGameplayAnswerButtonTouchedCorrectFill.CGColor
        let l = questionMakerLabels[num]
        l.hidden = true
    
        let i = questionMarkerIndicators[num]
        if let image = UIImage(named: "CorrectIcon"){
            i.image = image
            i.hidden = false
        }
        
    }
    func setIncorrectQuestionMarker(num: Int) {
        
        let v = questionMarkers[num]
        v.layer.borderColor = kGameplayAnswerButtonTouchedIncorrectStroke.CGColor
        let l = questionMakerLabels[num]
        l.hidden = true
        let i = questionMarkerIndicators[num]
        if let image = UIImage(named: "IncorrectIcon"){
            i.image = image
            i.hidden = false
        }
        
    }
    
    func updateUserScore(scores:[Double]) {
        
        var res = 0.0
        
        for val in scores {
            res = val + res
        }
        
        userScore.text = "$\(res)"
    }
    
    func startRightOrWrongAnimation(correct: Int, selected: Int) {
        
        var location: CGPoint!
        if selectedLocation == nil {
            location = CGPointZero
        } else {
            location = selectedLocation!
        }
        
        print(selectedLocation)

        if correct == 1 {
            switch selected {
            case 0:
                rippleAnimation(answer1, relativeLoaction: location, color: kGameplayAnswerButtonTouchedCorrectFill)
            case 1:
                rippleAnimation(answer2, relativeLoaction: location, color: kGameplayAnswerButtonTouchedCorrectFill)
            case 2:
                rippleAnimation(answer3, relativeLoaction: location, color: kGameplayAnswerButtonTouchedCorrectFill)
            case 3:
                rippleAnimation(answer4, relativeLoaction: location, color: kGameplayAnswerButtonTouchedCorrectFill)
            default:
                break
            }
        } else {
            switch selected {
            case 0:
                rippleAnimation(answer1, relativeLoaction: location, color: kGameplayAnswerButtonTouchedIncorrectFill)
            case 1:
                rippleAnimation(answer2, relativeLoaction: location, color: kGameplayAnswerButtonTouchedIncorrectFill)
            case 2:
                rippleAnimation(answer3, relativeLoaction: location, color: kGameplayAnswerButtonTouchedIncorrectFill)
            case 3:
                rippleAnimation(answer4, relativeLoaction: location, color: kGameplayAnswerButtonTouchedIncorrectFill)
            default:
                break
            }
        }
    }

    
    private var timer: NSTimer?
    private var step = CGFloat(0.0)
    
    func setTimer(){
        
        if let question = currentQuestion {
            if let time = question.timer?.intValue {
                clockLabel.text = String(format: "%.2f", Double(time)/1000)

                step = timebarWidthConstrain.constant / CGFloat(time/1000) * 0.01
//                print("------------")
//                print(timebarWidthConstrain.constant)
//                print(step)
//                print("------------")

            }
        }
    }
    
    func startCountdown() {
        
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
            
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameViewController.countingdown), userInfo: nil, repeats: true)
        
    }
    
    func stopCountdown() {
        
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
        
    }
    
    func countingdown() {

        if let currentTime = Double(clockLabel.text!){
            
            if currentTime > 0 {
                clockLabel.text = String(format: "%.2f", currentTime - 0.01)
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        
        }
        if timebarWidthConstrain.constant - step > 0 {
            timebarWidthConstrain.constant = timebarWidthConstrain.constant - step
        }
    }
    
    

}
































