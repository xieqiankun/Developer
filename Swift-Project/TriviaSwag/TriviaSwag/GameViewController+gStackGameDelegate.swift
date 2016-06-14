//
//  GameViewController+gStackGameDelegate.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/24/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension GameViewController: gStackGameDelegate{
    
    // MARK: - gStackGame Delegate Functions
    
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
        if let num = timer.timer?.doubleValue{
            let num = num / 1000
            preGameStartTimer(num)
        }
    }
    
    func didReceiveErrorMsg(error:gStackGameErrorMsg){
        print("Receive an error: \(error.error)")
    }
    func didReceiveStartRound( round: gStackGameStartRound) {
        
    }
    func didReceiveRoundResult( win: gStackGameRoundResult) {
        
    }

    func didReceiveQuestion(question: gStackGameQuestion){
        
        if isFirstQuestion {
            isFirstQuestion = false
            
            self.preGameToGaming()
        }
        
        self.currentQuestion = question
        //cache the question
        self.questions.append(question)
        
        self.setQuestionLabelWithCurrentQuestion()
        self.setCurrentQuestionNumber()
        if let num = question.questionNum?.integerValue{
            self.setCurrentQuestionMarker(num)
        }
        
        self.prepareState(true, completion:{
            self.setGifs()
            self.setAnswerLabelsWithCurrentQuestion()
            self.clearAnswerBackground()
            self.setUntouchButtons()
        })
        
        let delayInSeconds = Double(question.promptTime!)  / 1000
        
        // need to minus animation time for preparing aniamtin
        delay(delayInSeconds - 0.5) {
            self.playingState(true, completion: {
                self.isAllowSubmit = true
                // Timer
                self.setTimer()
                self.startCountdown()
            })
        }
    }
    
    func didReceivePlayerInfo(playerInfo: gStackGamePlayerInfo){
        
        
    }
    
    func didReceiveCorrectAnswer(correctAnswer: gStackGameCorrectAnswer){
        //cache answers
        self.answers.append(correctAnswer)
        // in case user didn't answer
        self.stopCountdown()
        if self.isAllowSubmit {
            self.setIncorrectResult()
        }
        self.resultState(true)
        
        let correct = correctAnswer.correctAnswer?.integerValue
        // reuse for displaying the right answer
        self.setCorrectButton(correct!)
        self.startRightOrWrongAnimation(1, selected: correct!)
        
        
        let timer = correctAnswer.timer?.integerValue
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(timer! - 800) / 1000 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            //self.clearLabels()
        }
    }
    
    func didReceiveUpdatedScore(updatedScore: gStackGameUpdatedScore){
        
        self.stopCountdown()
        
        let seleted = updatedScore.answerNumber?.integerValue
        
        // 0 means wrong 1 means right
        if (updatedScore.rightOrWrong?.integerValue)! == 0 {
            if let num = seleted {
                self.startRightOrWrongAnimation(0, selected: num)
                self.setIncorrectResult()
                // change button border for incorrect
                self.setIncorrectButton(num)
                if let num = updatedScore.questionNum?.integerValue{
                    self.setIncorrectQuestionMarker(num)
                }
            }
        } else {
            if let num = seleted {
                self.startRightOrWrongAnimation(1, selected: num)
                self.setCorrectResult()
                if let num = updatedScore.questionNum?.integerValue{
                    self.setCorrectQuestionMarker(num)
                }
            }
        }
        
        // update score
        if let scores = updatedScore.teamScores {
            var temp = [Double]()
            for item in scores {
                if let score = item as? Double {
                    temp.append(score)
                }
            }
            self.updateUserScore(temp)
        }
        
        
        
    }
    
    func didReceiveGameResult(result: gStackGameResult){
        //        self.soundGameover?.play()
        if !isForfeit{
            self.stopCountdown()
            let sb = UIStoryboard(name: "GameOver", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! GameOverViewController
            
            vc.tournament = self.currentTournament
            vc.answers = self.answers
            vc.questions = self.questions
            vc.numOfQuestion = (result.teamScores?[0].count)!
            var correct = 0
            for num in result.teamScores![0] {
                let score = num.doubleValue
                if score != 0 {
                    correct  = correct + 1
                }
            }
            vc.numOfCorrect = correct
            var time = 0.0
            for num in result.teamAnswersTime![0] {
                let score = num.doubleValue
                if score != 0 {
                    time  = time + score
                }
            }
            vc.totalTime = time
            vc.restartDelegate = self
            self.presentViewController(vc, animated: true) {
                self.clearGifCache()
            }

        }
        
        self.endGame()
    }
    
    func didReceiveOtherGameFinished(alive:gStackGameOtherGameFinished){
        
        
    }
    
    
    
    
}