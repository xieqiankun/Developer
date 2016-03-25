//
//  ReviewQuestionViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/24/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ReviewQuestionViewController: UIViewController {
    
    var question: gStackGameQuestion?
    var correctAnswer: gStackGameCorrectAnswer?
    var tournament: gStackTournament?
    var pageViewController: ReviewQuestionsPageViewController?
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answer1Label: UILabel!
    @IBOutlet var answer2Label: UILabel!
    @IBOutlet var answer3Label: UILabel!
    @IBOutlet var answer4Label: UILabel!
    
    @IBOutlet var goodQuestionSuperview: UIView!
    @IBOutlet var questionVotesLabel: UILabel!
    
    @IBOutlet var dynamicAnswerView: UIView!
    var answerView: CorrectAnswerDotsView?
    
    @IBOutlet var downVoteButton: UIButton!
    @IBOutlet var upVoteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var laidOut = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if laidOut == false {
            laidOut = true
            answerView = CorrectAnswerDotsView(frame: dynamicAnswerView.frame, howManyDots: pageViewController!.answerDotsView!.numberOfDots)
            answerView!.correctIndexes = pageViewController!.answerDotsView!.correctIndexes
            answerView!.incorrectIndexes = pageViewController!.answerDotsView!.incorrectIndexes
            view.addSubview(answerView!)
            answerView?.layoutSubviews()
            answerView?.layoutSubviews() //Call twice so it will paint the result dots
            print("Lay out subviews")
        }
    }
    
    
    
    
    func configureUI() {
        questionLabel.text = question?.formattedQuestion()
        answer1Label.text = question?.formattedAnswers()[0]
        answer2Label.text = question?.formattedAnswers()[1]
        answer3Label.text = question?.formattedAnswers()[2]
        answer4Label.text = question?.formattedAnswers()[3]
        
        switch correctAnswer!.correctAnswer!.integerValue {
        case 0:
            answer1Label.textColor = UIColor.greenColor()
        case 1:
            answer2Label.textColor = UIColor.greenColor()
        case 2:
            answer3Label.textColor = UIColor.greenColor()
        case 3:
            answer4Label.textColor = UIColor.greenColor()
        default:
            break
        }
        
        questionVotesLabel.text = question?.votes?.stringValue
        
        if question?.voted == true {
            upVoteButton.enabled = false
            downVoteButton.enabled = false
        }
    }
    
    
    
    @IBAction func doneButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func upVoteButtonPressed() {
        gStackUpVoteQuestion(tournament!, question: question!, completion: {
            error in
            if error != nil {
                print("Error upvoting quesiton: \(error!)")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.upVoteButton.enabled = false
                    self.downVoteButton.enabled = false
                    var number = self.question!.votes!.integerValue
                    number += 1
                    self.question!.votes = NSNumber(integer: number)
                    self.question!.voted = true
                    self.questionVotesLabel.text = self.question!.votes!.stringValue
                })
            }
        })
    }
    
    @IBAction func downVoteButtonPressed() {
        gStackDownVoteQuestion(tournament!, question: question!, completion: {
            error in
            if error != nil {
                print("Error downvoting quesiton: \(error!)")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.upVoteButton.enabled = false
                    self.downVoteButton.enabled = false
                    var number = self.question!.votes!.integerValue
                    number -= 1
                    self.question!.votes = NSNumber(integer: number)
                    self.question!.voted = true
                    self.questionVotesLabel.text = self.question!.votes!.stringValue
                })
            }
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ReportQuestion" {
            let destinationVC = segue.destinationViewController as! ReportQuestionTableViewController
            destinationVC.question = question
            destinationVC.tournament = tournament
        }
    }
    

}
