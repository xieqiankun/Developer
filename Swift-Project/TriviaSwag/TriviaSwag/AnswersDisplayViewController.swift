//
//  AnswersDisplayViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/8/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

public protocol triviaGameSubmitAnswerDelegate: class{
    
    // help submit answer
    func submitAnswer(num: Int)
}

class AnswersDisplayViewController: UIViewController {

    
    weak var delegate: triviaGameSubmitAnswerDelegate?
    
    deinit{
        
        print("deinit the answer view controller")
    }
    
    @IBOutlet var answerViews: [UIView]!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    // temp store the image views
    var imageViewContainer = [UIImageView]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideAnswerViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAnswersButtons(){
        
        if self.imageViewContainer.count != 0 {
            
            for imageView in self.imageViewContainer{
                
                imageView.removeFromSuperview()
                self.imageViewContainer.removeAtIndex((self.imageViewContainer.indexOf(imageView))!)
            }
            
        }
        
        for view in self.answerViews {
            
            let width = view.bounds.size.width
            let height = view.bounds.size.height
            
            let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
            imageViewBackground.image = UIImage(named: "AnswerUntouched")
            
            imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
            view.backgroundColor = UIColor.clearColor()
            view.addSubview(imageViewBackground)
            view.sendSubviewToBack(imageViewBackground)
            self.imageViewContainer.append(imageViewBackground)

        }

    }
    
    func hideAnswerViews() {
        
        for view in self.answerViews {
            view.hidden = true
        }
        
    }
    
    func displayAnswerViews() {
        
        for view in self.answerViews {
            view.hidden = false
        }
        
    }
    
    // For display the answers when it is ready
    func readyForDisplayAnswerViews(answers: [String]) {
        
        self.setupAnswersButtons()
        self.displayAnswerViews()
        
        for i in 0 ..< 4 {
            let btn = self.answerButtons[i]
            btn.setTitle(answers[i], forState: .Normal)
        }
        
        self.displayAnimationForButtons()
    }
    
    func displayAnimationForButtons(){
        
        for i in 0 ..< 4 {
            let imageView = self.answerViews[i].subviews[0]
            let temp = imageView.bounds
            imageView.bounds = CGRectMake(0, 0, 0, 0)
            imageView.alpha = 0
            
            
            let label = self.answerButtons[i].titleLabel
            label?.transform = CGAffineTransformScale((label?.transform)!, 0.1, 0.1)
            label?.alpha = 0
            
            UIView.animateWithDuration(0.5, delay:Double(i)/8 , usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .CurveEaseInOut, animations: {
                
                label?.transform = CGAffineTransformScale((label?.transform)!, 10, 10)
                imageView.bounds = temp
                imageView.alpha = 1
                label?.alpha = 1
                }, completion: nil)
            
        }
    }
    
    // buttons disappear
    func answerButtonsFadeOut(){
        
        for i in 0 ... 3 {
            
            let imageView = self.answerViews[i].subviews[0]
            let label = self.answerButtons[i].titleLabel

            UIView.animateWithDuration(0.5, delay: Double(i)/8, options: [], animations: { 
                
                label?.alpha = 0
                imageView.alpha = 0
                
                }, completion: { (true) in
                    // Avoid multiple submit
                    self.hideAnswerViews()
            })
        }
 
    }
    
    // display red layer when answer is wrong
    func displayForWrongAnswer(num: Int){
        
        let wrongImageView = self.imageViewContainer[num]
        
        let image = UIImage(named: "AnswerIncorrect")
        wrongImageView.image = image
        
        wrongImageView.alpha = 0
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            wrongImageView.alpha = 1
            }, completion: nil)

    }
    
    func displayForRightAnswer(num: Int){
        
        let rightImageView = self.imageViewContainer[num]
        
        let image = UIImage(named: "AnswerCorrect")
        rightImageView.image = image
        
        rightImageView.alpha = 0
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: [], animations: {
            rightImageView.alpha = 1
            }, completion: nil)
        
    }
    
    
    
    
    @IBAction func submitAnswer(sender: UIButton) {
        
        let index = self.answerButtons.indexOf(sender)
        
        delegate?.submitAnswer(index!)
        
        print("submit answer num: \(index!)")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     //
    }
    */

}
