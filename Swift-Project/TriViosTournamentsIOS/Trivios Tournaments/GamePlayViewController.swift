//
//  GamePlayViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/4/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, gStackGameDelegate {
    
    @IBOutlet var topHUDSuperview: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var averageTimeLabel: UILabel!
    @IBOutlet var highScoreAverageTimeLabel: UILabel!
    
    @IBOutlet var questionTextLabel: UILabel!
    
    @IBOutlet var answerTableView: UITableView!
    @IBOutlet var correctAnswersLabel: UILabel!
    
    @IBOutlet var bottomHUDSuperview: UIView!
    @IBOutlet var prizeImageView: UIImageView!
    @IBOutlet var dynamicAnswersView: UIView! //This is an IB placeholder for:
    var answerDotsView: CorrectAnswerDotsView?
    @IBOutlet var highScoreCorrectAnswersLabel: UILabel!
    
    @IBOutlet var myScoreLabelLabel: UILabel!
    @IBOutlet var leaderScoreLabelLabel: UILabel!
    @IBOutlet var myTimeLabelLabel: UILabel!
    @IBOutlet var leaderTimeLabelLabel: UILabel!
    
    var tournament: gStackTournament?
    
    var game: gStackGame? {
        didSet {
            if game != nil {
                game!.delegate = self
            }
            
        }
    }
    
    var currentQuestion: gStackGameQuestion?
    var currentCorrectAnswer: gStackGameCorrectAnswer?
    var currentUpdatedScore: gStackGameUpdatedScore?
    
    var numberOfCorrectAnswers = 0
    
    var numberOfSecondsRemaining = -1
    var gameTimer: NSTimer?
    
    var avatarImageString = ""
    var averageTime = 0.0
    
    var questions = Array<gStackGameQuestion>()
    var correctAnswers = Array<gStackGameCorrectAnswer>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startThings()
        
        addGestureRecognizerToTimer()
        
        configureDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDisplay() {
        let backgroundColor = UIColor(patternImage: UIImage(named: "gameplay-background")!)
        view.backgroundColor = backgroundColor
        
        answerTableView.backgroundColor = UIColor.clearColor()
        answerTableView.separatorColor = UIColor.clearColor()
        
        questionTextLabel.textColor = UIColor.whiteColor()
        
        for label in [correctAnswersLabel,highScoreCorrectAnswersLabel,timerLabel,averageTimeLabel,highScoreAverageTimeLabel] {
            label.textColor = kGamePageTextColor
        }
        for label in [myScoreLabelLabel,leaderScoreLabelLabel,myTimeLabelLabel,leaderTimeLabelLabel] {
            label.textColor = UIColor.whiteColor()
        }
    }
    
    func drawCircles() {
        for label in [correctAnswersLabel,highScoreCorrectAnswersLabel,timerLabel,averageTimeLabel,highScoreAverageTimeLabel] {
            let padding = CGFloat(3)
            let circleLayer = CAShapeLayer()
            circleLayer.path = UIBezierPath(ovalInRect: CGRectMake(label.frame.origin.x-padding, label.frame.origin.y-padding, label.frame.width+padding*2, label.frame.height+padding*2)).CGPath
            circleLayer.fillColor = kUnansweredBackgroundColor.CGColor
            circleLayer.strokeColor = UIColor.whiteColor().CGColor
            if label == highScoreAverageTimeLabel || label == highScoreCorrectAnswersLabel {
                circleLayer.fillColor = UIColor.whiteColor().CGColor
                circleLayer.strokeColor = kUnansweredBackgroundColor.CGColor
            }
            circleLayer.lineWidth = 1
            view.layer.insertSublayer(circleLayer, atIndex: 0)
        }
    }
    
    var firstLayout = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let yCoordinate = timerLabel.frame.origin.y //If this is <0, VDLS is a lying bastard and it hasn't really laid out the subviews yet
        if firstLayout == true && yCoordinate >= 0 {
            firstLayout = false
            
            drawCircles()
        }
    }
    
    var placedCorrectAnswerDots = false
    func placeAnswerDots() {
        if placedCorrectAnswerDots == false {
            placedCorrectAnswerDots = true
            
            let frame = view.convertRect(dynamicAnswersView.frame, fromView: bottomHUDSuperview)
            var gameLength = 0
            if let _gameLength = currentQuestion?.gameLength {
                gameLength = _gameLength.integerValue
            }
            
            answerDotsView?.removeFromSuperview()
            
            answerDotsView = CorrectAnswerDotsView(frame: frame, howManyDots: gameLength)
            view.addSubview(answerDotsView!)
        }
    }
    
    
    func startThings() {
        numberOfCorrectAnswers = 0
        
        gameTimer?.invalidate()
        
        avatarImageString = ""
        averageTime = 0.0
        
        placedCorrectAnswerDots = false
        
        dispatch_async(dispatch_get_main_queue(), {
            self.averageTimeLabel.text = "0.00"
            self.correctAnswersLabel.text = "0"
        })
        
        questions = Array<gStackGameQuestion>()
        correctAnswers = Array<gStackGameCorrectAnswer>()
        
        loadTournamentInformation()
        loadHighScoreInformation()
    }

    
    //Gesture Recognizers
    func addGestureRecognizerToTimer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "timerPressed")
        timerLabel.userInteractionEnabled = true
        timerLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    func timerPressed() {
        let alertController = UIAlertController(title: "Forfeit?", message: "Are you sure you want to forfeit?", preferredStyle: UIAlertControllerStyle.Alert)
        let forfeitAction = UIAlertAction(title: "Forfeit", style: UIAlertActionStyle.Destructive, handler: { action in
            self.game?.endGame()
            self.gameTimer?.invalidate()
            self.game?.delegate = nil
            self.game = nil
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(forfeitAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GameOverSegue" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! GameOverViewController
            destinationVC.tournament = tournament
            destinationVC.avatarImageString = avatarImageString
            destinationVC.numberOfCorrectAnswers = numberOfCorrectAnswers
            destinationVC.averageTime = averageTime
            destinationVC.presenterViewController = self
            destinationVC.questions = questions
            destinationVC.correctAnswers = correctAnswers
            destinationVC.answerDotsView = answerDotsView
        }
    }
    
    
    
    func loadTournamentInformation() {
        if tournament != nil {
            if let tournamentPrize = tournament?.prizes?.first {
                if let prizeImageString = tournamentPrize.image {
                    let imageURLString = "http://" + prizeImageString
                    prizeImageView.imageURL = NSURL(string: imageURLString)
                }
            }
        }
    }
    
    
    func loadHighScoreInformation() {
        if tournament != nil {
            gStackFetchLeaderboardForTournament(tournament!, completion: {
                error, leaderboard in
                if error != nil {
                    print("Error fetching leaderboard: \(error!)")
                } else if leaderboard!.leaders.count > 0 {
                    let leader = leaderboard!.leaders.first!
                    let numberCorrect = leader.correct!.doubleValue
                    let correctTime = leader.correctTime!.doubleValue
                    let averageTime = correctTime / Double(numberCorrect * 1000)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.highScoreCorrectAnswersLabel.text = leader.correct!.stringValue
                        self.highScoreAverageTimeLabel.text = String(format: "%.2f", averageTime)
                    })
                }
            })
        }
    }
    

    
    func onGameTimer() {
        if numberOfSecondsRemaining == 0 {
            gameTimer?.invalidate()
        }
        else {
            numberOfSecondsRemaining -= 1
            dispatch_async(dispatch_get_main_queue(), {
                self.timerLabel.text = String(self.numberOfSecondsRemaining)
            })
        }
    }
    
    
    var shouldHideAnswers = false
    
    func configureUserInterfaceForQuestion(question: gStackGameQuestion) {
        self.timerLabel.text = String(self.numberOfSecondsRemaining)
        
        shouldHideAnswers = true
        answerTableView.reloadData()
        fadeInQuestionNumber()
    }
    
    func fadeInQuestionNumber() {
        questionTextLabel.text = "Question \(currentQuestion!.questionNum!.intValue+1)"
        questionTextLabel.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: {
            self.questionTextLabel.alpha = 1
            }, completion: {
                completed in
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.5) * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.fadeOutQuestionNumber()
                })
        })
    }
    
    func fadeOutQuestionNumber() {
        UIView.animateWithDuration(0.5, animations: {
            self.questionTextLabel.alpha = 0
            }, completion: {
                completed in
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.25) * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.fadeInQuestion()
                })
        })
    }
    
    func fadeInQuestion() {
        questionTextLabel.text = currentQuestion?.formattedQuestion()
        UIView.animateWithDuration(0.5, animations: {
            self.questionTextLabel.alpha = 1
            }, completion: {
                completed in
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.5) * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.fadeInAnswers()
                })
        })
    }
    
    var shouldFadeInAnswers = false
    
    func fadeInAnswers() {
        shouldFadeInAnswers = true
        answerTableView.reloadData()
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "onGameTimer", userInfo: nil, repeats: true)
    }
    
    
    
    
    
    
    //MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnswerCell", forIndexPath: indexPath) 
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        let clear = UIView()
        clear.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = clear
        
        let answerLabel = cell.viewWithTag(1) as! UILabel
        let buttonView = cell.viewWithTag(2) as! UIImageView
        
        switch indexPath.section {
        case 0:
            answerLabel.text = currentQuestion?.formattedAnswers()[0]
        case 1:
            answerLabel.text = currentQuestion?.formattedAnswers()[1]
        case 2:
            answerLabel.text = currentQuestion?.formattedAnswers()[2]
        case 3:
            answerLabel.text = currentQuestion?.formattedAnswers()[3]
        default:
            break
        }
        
        if shouldHideAnswers {
            answerLabel.alpha = 0
        }
        
        buttonView.image = UIImage(named: "answerbar-normal")
        if currentCorrectAnswer != nil {
            if currentUpdatedScore != nil && currentUpdatedScore!.answerNumber!.integerValue != currentCorrectAnswer!.correctAnswer!.integerValue && indexPath.section == currentUpdatedScore!.answerNumber!.integerValue {
                buttonView.image = UIImage(named: "answerbar-wrong")
            }
            else if indexPath.section == currentCorrectAnswer!.correctAnswer!.integerValue {
                buttonView.image = UIImage(named: "answerbar-correct")
            }
            
            if currentUpdatedScore != nil && indexPath.section == currentUpdatedScore!.answerNumber!.integerValue {
                //This is the button we clicked
                animateImageFun(buttonView)
            }
        }
        
        if shouldFadeInAnswers {
            UIView.animateWithDuration(1.0, animations: {
                answerLabel.alpha = 1
            })
        }
        
        if indexPath.section == 3 {
            shouldFadeInAnswers = false
            shouldHideAnswers = false
        }
        
        return cell
    }
    
    
    //MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentQuestion != nil {
            game?.submitAnswerForQuestion(currentQuestion!, answerIndex: indexPath.section)
        }
    }
    
    
    
    func animateImageFun(imageView: UIImageView) {
        UIView.animateWithDuration(0.3, animations: {
            imageView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: {
                completion in
                UIView.animateWithDuration(0.3, animations: {
                    imageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    }, completion: {
                        completion in
                        imageView.transform = CGAffineTransformIdentity
                })
        })
    }
    
    
    //MARK: - Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //MARK: - gStackGame Delegate
    
    func gameDidStart(){
        print("Game did start")
    }
    func willAttemptToReconnect(options: PrimusReconnectOptions){
        print("Will attempt to reconnect")
    }
    func didReconnect(){
        print("Did reconnect")
    }
    func didLoseConnection(){
        print("Did lose connection")
    }
    func didEstablishConnection(){
        print("Did establish connection")
    }
    func didEncounterError(error: NSError){
        print("Did encounter error: \(error)")
    }
    func connectionDidEnd(){
        print("Connection did end")
    }
    func connectionDidClose(){
        print("Connection did close")
    }
    func didReceiveTimer(timer:gStackGameTimer){
        
    }
    func didReceiveOtherGameFinished(alive:gStackGameOtherGameFinished){
        
    }
    func didReceiveStartRound(round:gStackGameStartRound){
        
    }
    func didReceiveRoundResult(win:gStackGameRoundResult){
        
    }
    func didReceiveErrorMsg(error:gStackGameErrorMsg){
        
    }

    func didReceiveQuestion(question: gStackGameQuestion) {
        print("Did receive question: \(question)")
        currentQuestion = question
        questions.append(question)
        currentCorrectAnswer = nil
        currentUpdatedScore = nil
        numberOfSecondsRemaining = question.timer!.integerValue / 1000
        
        dispatch_async(dispatch_get_main_queue(), {
            self.placeAnswerDots()
            self.configureUserInterfaceForQuestion(question)
        })
    }
    
    func didReceivePlayerInfo(playerInfo: gStackGamePlayerInfo) {
        print("Did receive player info: \(playerInfo)")
        dispatch_async(dispatch_get_main_queue(), {
            //let fullAvatarString = playerInfo.teamAvatars![0][0]
            //let shortenedAvatarString = fullAvatarString.substringFromIndex(fullAvatarString.startIndex.advancedBy(5))
            //self.avatarImageString = shortenedAvatarString
            //self.avatarImageView.image = UIImage(named: self.avatarImageString)
        })
    }
    func didReceiveCorrectAnswer(correctAnswer: gStackGameCorrectAnswer) {
        print("Did receive correct answer \(correctAnswer)")
        currentCorrectAnswer = correctAnswer
        correctAnswers.append(correctAnswer)
        
        if currentUpdatedScore != nil && correctAnswer.correctAnswer!.integerValue == currentUpdatedScore!.answerNumber!.integerValue {
            numberOfCorrectAnswers += 1
            dispatch_async(dispatch_get_main_queue(), {
                self.correctAnswersLabel.text = String(self.numberOfCorrectAnswers)
                
                self.answerDotsView?.correctIndexes.append(correctAnswer.questionNum!.integerValue+1)
                self.answerDotsView?.setNeedsLayout()
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                self.answerDotsView?.incorrectIndexes.append(correctAnswer.questionNum!.integerValue+1)
                self.answerDotsView?.setNeedsLayout()
            })
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.answerTableView.reloadData()
        });
        
        self.gameTimer?.invalidate()
    }
    func didReceiveUpdatedScore(updatedScore: gStackGameUpdatedScore) {
        print("Did receive update score \(updatedScore)")
        currentUpdatedScore = updatedScore
        
        dispatch_async(dispatch_get_main_queue(), {
            let answerTimes = updatedScore.teamAnswersTime![0]
            var totalTime = 0
            for idx in 0...self.currentQuestion!.questionNum!.integerValue {
                totalTime += answerTimes[idx].integerValue
            }
            self.averageTime = (Double(totalTime) / 1000.0) / Double(self.currentQuestion!.questionNum!.integerValue+1)
            self.averageTimeLabel.text = String(format: "%.2f", arguments: [self.averageTime])
        })
    }
    func didReceiveGameResult(result: gStackGameResult) {
        print("Did receive game result: \(result)")
        self.game!.endGame()
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("GameOverSegue", sender: nil)
        })
    }
}