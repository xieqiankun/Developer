//
//  GameViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/23/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kQuestionBorderColor = UIColor.blueColor()
let kQuestionBackgroundColor = UIColor.blueColor()
let kAnswerBorderColor = UIColor.blueColor()
let kAnswerBackgroundColor = UIColor.darkGrayColor()
let kRightAnswerColor = UIColor.greenColor()
let kWrongAnswerColor = UIColor.redColor()

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
    
    // result part
    @IBOutlet weak var avatorGif: UIImageView!
    @IBOutlet weak var funnyGif: UIImageView!
    @IBOutlet weak var funnyLabel: UILabel!


    
    // MARK: - prepare the ui and labels
    deinit{
        // clear it cause using strong reference
        headerHeightConstrain = nil
        questionHeightConstrain = nil
        print("deinit the game view controller")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareState(false,completion:nil)
        initGamePlayUI()
        
        
        //start the game
        if let tournament = self.currentTournament {
            gStackStartGameForTournament(tournament) { (error, game) in
                
                if error == nil {
                    self.game = game
                    game?.delegate = self
                    
                }
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initGamePlayUI() {
        
        // clear container background
        //        questionView.backgroundColor = UIColor.clearColor()
        //        resultView.backgroundColor = UIColor.clearColor()
        //        answersView.backgroundColor = UIColor.clearColor()
        //        headerView.backgroundColor = UIColor.clearColor()
        //        statusView.backgroundColor = UIColor.clearColor()
        
        // setup
        questionBackgroundView.layer.cornerRadius = 15
        questionBackgroundView.layer.borderColor = kQuestionBorderColor.CGColor
        questionBackgroundView.layer.borderWidth = 3.0
        
        answer1.layer.cornerRadius = 20
        answer1.layer.borderColor = kQuestionBorderColor.CGColor
        answer1.layer.borderWidth = 3.0
        
        answer2.layer.cornerRadius = 20
        answer2.layer.borderColor = kQuestionBorderColor.CGColor
        answer2.layer.borderWidth = 3.0
        
        answer3.layer.cornerRadius = 20
        answer3.layer.borderColor = kQuestionBorderColor.CGColor
        answer3.layer.borderWidth = 3.0
        
        answer4.layer.cornerRadius = 20
        answer4.layer.borderColor = kQuestionBorderColor.CGColor
        answer4.layer.borderWidth = 3.0
        
        questionBackgroundView.backgroundColor = kQuestionBackgroundColor
        
        //setup tournament Name
        if currentTournament != nil {
            tournamentNameLabel.text = currentTournament!.name
        }
        
        //hide clock
        clock.alpha = 0
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
        rippleAnimation(answer2, relativeLoaction: CGPointZero, color: kRightAnswerColor)
        
        
    }
    @IBAction func test3() {
        
        //resultState(true)
        //rippleAnimation(answer3, relativeLoaction: CGPointZero, color: UIColor.blackColor())
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
                self.clock.alpha = 1
                self.view.layoutIfNeeded()
            }
            UIView.animateWithDuration(0.25, delay: 0.25, options: [], animations: {
                self.timebarWidthConstrain.constant = self.questionBackgroundView.frame.width - self.ballView.frame.width - self.clockView.frame.width
                self.questionLabel.alpha = 1
                }, completion: completion)
            
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
            
            if isAllowSubmit {
                // a little bit complicated, test tapping and submit answer
                if view.hitTest(location, withEvent: nil) == answer1 {
                    let relativeLocation = t.locationInView(answer1)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(0)
                    
                } else if view.hitTest(location, withEvent: nil) == answer2 {
                    let relativeLocation = t.locationInView(answer2)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(1)
                    
                }  else if view.hitTest(location, withEvent: nil) == answer3 {
                    let relativeLocation = t.locationInView(answer3)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(2)
                    
                } else if view.hitTest(location, withEvent: nil) == answer4 {
                    let relativeLocation = t.locationInView(answer4)
                    self.selectedLocation = relativeLocation
                    stopCountdown()
                    submitAnswer(3)
                }
            }
            
        }
        
    }
    
    func submitAnswer(num: Int){
        
        if self.isAllowSubmit {
            
            self.game?.submitAnswerForQuestion(self.currentQuestion!, answerIndex: num)
            
            // stop time bar
            //stop clock
            
            self.isAllowSubmit = false
        }
        
    }
    // ripple animation for submit the question
    func rippleAnimation(view:UIView, relativeLoaction: CGPoint, color: UIColor){
        
        var option = Ripple.option()
        //configure
        option.borderWidth = CGFloat(2.0)
        option.radius = CGFloat(150.0)
        option.duration = CFTimeInterval(0.8)
        option.borderColor = color
        option.fillColor = color
        option.scale = CGFloat(5.0)
        
        Ripple.run(view, absolutePosition: relativeLoaction, option: option){
            view.backgroundColor = color
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
    
    
    // MARK: - Game logic part
    
    func clearAnswerBackground() {
        answer1.backgroundColor = kAnswerBackgroundColor
        answer2.backgroundColor = kAnswerBackgroundColor
        answer3.backgroundColor = kAnswerBackgroundColor
        answer4.backgroundColor = kAnswerBackgroundColor
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
        
        avatorGif.image = UIImage.gifWithName("Win-BlueMonster")
        funnyGif.image = UIImage.gifWithName("shooterMcGavin")
        funnyLabel.text = "You eat pieces of 💩 for breakfast?"
    }
    
    func setIncorrectResult() {
        
        avatorGif.image = UIImage.gifWithName("Lose-BlueMonster")
        funnyGif.image = UIImage.gifWithName("powerrangers")
        funnyLabel.text = "Ahhhhh my brain!"

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
                rippleAnimation(answer1, relativeLoaction: location, color: kRightAnswerColor)
            case 1:
                rippleAnimation(answer2, relativeLoaction: location, color: kRightAnswerColor)
            case 2:
                rippleAnimation(answer3, relativeLoaction: location, color: kRightAnswerColor)
            case 3:
                rippleAnimation(answer4, relativeLoaction: location, color: kRightAnswerColor)
            default:
                break
            }
        } else {
            switch selected {
            case 0:
                rippleAnimation(answer1, relativeLoaction: location, color: kWrongAnswerColor)
            case 1:
                rippleAnimation(answer2, relativeLoaction: location, color: kWrongAnswerColor)
            case 2:
                rippleAnimation(answer3, relativeLoaction: location, color: kWrongAnswerColor)
            case 3:
                rippleAnimation(answer4, relativeLoaction: location, color: kWrongAnswerColor)
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
                print("------------")
                print(timebarWidthConstrain.constant)
                print(step)
                print("------------")

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
































