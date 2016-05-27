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
        
    }
    func didReceiveErrorMsg(error:gStackGameErrorMsg){
        print("Receive an error: \(error.error)")
    }
    func didReceiveStartRound( round: gStackGameStartRound) {
        
    }
    func didReceiveRoundResult( win: gStackGameRoundResult) {
        
    }
    func didReceiveQuestion(question: gStackGameQuestion){

        self.currentQuestion = question
        self.isAllowSubmit = true
        
        setQuestionLabelWithCurrentQuestion()
        setCurrentQuestionNumber()
        if let num = question.questionNum?.integerValue{
            setCurrentQuestionMarker(num)
        }
        
        self.prepareState(true, completion:{
            (true) in
            self.setAnswerLabelsWithCurrentQuestion()
            self.clearAnswerBackground()
            self.setUntouchButtons()
        })


        let delayInSeconds = Double(question.promptTime!)  / 1000
        
        // need to minus animation time for preparing aniamtin
        delay(delayInSeconds - 0.5) {
            self.playingState(true,completion: {
                (true) in
                // Timer
                self.setTimer()
                self.startCountdown()
            })
        }

        
    }
    func didReceivePlayerInfo(playerInfo: gStackGamePlayerInfo){
        
        
    }
    func didReceiveCorrectAnswer(correctAnswer: gStackGameCorrectAnswer){
        // in case user didn't answer
        stopCountdown()
        resultState(true)
        
        let correct = correctAnswer.correctAnswer?.integerValue
        // reuse for displaying the right answer
        setCorrectButton(correct!)
        startRightOrWrongAnimation(1, selected: correct!)
        
        let timer = correctAnswer.timer?.integerValue
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(timer! - 800) / 1000 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { 
            //self.clearLabels()
        }
    }
    
    func didReceiveUpdatedScore(updatedScore: gStackGameUpdatedScore){
        
        stopCountdown()
        
        let seleted = updatedScore.answerNumber?.integerValue
        
        // 0 means wrong 1 means right
        if (updatedScore.rightOrWrong?.integerValue)! == 0 {
            if let num = seleted {
                startRightOrWrongAnimation(0, selected: num)
                setIncorrectResult()
                // change button border for incorrect
                setIncorrectButton(num)
                if let num = updatedScore.questionNum?.integerValue{
                    setIncorrectQuestionMarker(num)
                }
            }
        } else {
            if let num = seleted {
                startRightOrWrongAnimation(1, selected: num)
                setCorrectResult()
                if let num = updatedScore.questionNum?.integerValue{
                    setCorrectQuestionMarker(num)
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
            updateUserScore(temp)
        }
        
        
    }
    
    func didReceiveGameResult(result: gStackGameResult){
        //        self.soundGameover?.play()
        stopCountdown()
    }
    
    func didReceiveOtherGameFinished(alive:gStackGameOtherGameFinished){
        
        
    }
    
    
    
    
}