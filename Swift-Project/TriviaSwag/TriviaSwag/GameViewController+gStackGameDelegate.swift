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
        //cache the question
        self.questions.append(question)
        self.isAllowSubmit = true
        
        setQuestionLabelWithCurrentQuestion()
        setCurrentQuestionNumber()
        if let num = question.questionNum?.integerValue{
            setCurrentQuestionMarker(num)
        }
        
        self.prepareState(true, completion:{
            (true) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.setGifs()
                self.setAnswerLabelsWithCurrentQuestion()
                self.clearAnswerBackground()
                self.setUntouchButtons()
            })
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
        //cache answers
        answers.append(correctAnswer)
        // in case user didn't answer
        stopCountdown()
        if isAllowSubmit {
            setIncorrectResult()
        }
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
        
        NSLog("receive update scores")

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
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func didReceiveOtherGameFinished(alive:gStackGameOtherGameFinished){
        
        
    }
    
    
    
    
}