//
//  ReviewQuestionsPageViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/24/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ReviewQuestionsPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var questions = Array<gStackGameQuestion>()
    var correctAnswers = Array<gStackGameCorrectAnswer>()
    var tournament: gStackTournament?
    var answerDotsView: CorrectAnswerDotsView?
    
    var reviewQuestionViewControllers = [ReviewQuestionViewController]()
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        
        instantiateViewControllers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "jumpToQuestion:", name: "AnswerDotTapped", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    func instantiateViewControllers() {
        let storyboardID = "ReviewQuestionVC"
        
        for idx in 0...questions.count-1 {
            let questionViewController = storyboard?.instantiateViewControllerWithIdentifier(storyboardID) as! ReviewQuestionViewController
            questionViewController.question = questions[idx]
            questionViewController.correctAnswer = correctAnswers[idx]
            questionViewController.tournament = tournament
            questionViewController.pageViewController = self
            reviewQuestionViewControllers.append(questionViewController)
        }
        setViewControllers([reviewQuestionViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        currentIndex = reviewQuestionViewControllers.indexOf(viewController as! ReviewQuestionViewController)!
        
        if currentIndex > 0 {
            currentIndex -= 1
            return reviewQuestionViewControllers[currentIndex]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        currentIndex = reviewQuestionViewControllers.indexOf(viewController as! ReviewQuestionViewController)!
        
        if currentIndex < reviewQuestionViewControllers.count - 1 {
            currentIndex += 1
            return reviewQuestionViewControllers[currentIndex]
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return reviewQuestionViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0 //Is this right??
    }
    
    
    func jumpToQuestion(notification: NSNotification) {
        let index = (notification.userInfo!["Index"] as! Int) - 1
        if index != currentIndex {
            currentIndex = index
            setViewControllers([reviewQuestionViewControllers[index]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
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

}
