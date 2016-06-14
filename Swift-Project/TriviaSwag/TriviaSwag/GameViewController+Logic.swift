//
//  GameViewController+Logic.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/13/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension GameViewController{
    
    
    
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
        
        avatorGif.hidden = false
        avatorGif_Incorrect.hidden = false
        
        if let center = triviaCurrentDataCenter,let store = center.gifStore {
            
            let correct = store.getRandomGif(true)
            
            if let correctURL = NSURL(string: correct.image!){
                //                task1 = UIImage.gifWithRemoteUrl(correctURL, completion: { [weak self](image) in
                //                    if let strongSelf = self {
                //                            strongSelf.funnyGif.image = image
                //                    }
                //                })
                //task1 = funnyGif.loadGifWithURL(correctURL)
                funnyGif.kf_setImageWithURL(correctURL)
                
            }
            funnyLabel.text = correct.text!
            
            let incorrect = store.getRandomGif(false)
            
            if let incorrectURL = NSURL(string: incorrect.image!){
                //                task2 = UIImage.gifWithRemoteUrl(incorrectURL, completion: { [weak self](image) in
                //                    if let strongSelf = self {
                //                            strongSelf.funnyGif_Incorrect.image = image
                //                    }
                //                })
                //task2 = funnyGif_Incorrect.loadGifWithURL(incorrectURL)
                funnyGif_Incorrect.kf_setImageWithURL(incorrectURL)
            }
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
        
        avatorGif_Incorrect.hidden = true
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
        avatorGif.hidden = true
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
    
    

    func setTimer(){
        
        if let question = currentQuestion {
            if let time = question.timer?.intValue {
                clockLabel.text = String(format: "%.2f", Double(time)/1000)
                
                step = timebarWidthConstrain.constant / CGFloat(time/1000) * CGFloat(timeInterval)
                
            }
        }
    }
    
    func startCountdown() {
        
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(GameViewController.countingdown), userInfo: nil, repeats: true)
        
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
                clockLabel.text = String(format: "%.2f", currentTime - timeInterval)
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
            
        }
        if timebarWidthConstrain.constant - step > 0 {
            timebarWidthConstrain.constant = timebarWidthConstrain.constant - step
        }
    }
    
    func clearGifCache() {
        
        funnyGif.image = nil
        funnyGif_Incorrect.image = nil
        avatorGif_Incorrect.image = nil
        avatorGif.image = nil
        
        let cache = KingfisherManager.sharedManager.cache
        cache.clearMemoryCache()
    }
    
    
    
    
    
    
    
    
}