//
//  QuestionDisplayViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/8/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class QuestionDisplayViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func readyForDisplayQuestionLabel(question: String) {
        
        self.questionLabel.text = question
        
        self.displayAnimationForQustion()
        
    }
    
    func displayAnimationForQustion() {
        
        self.questionLabel.transform = CGAffineTransformScale(self.questionLabel.transform, 0.1, 0.1)
        self.questionLabel.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            
            self.questionLabel.alpha = 1
            self.questionLabel.transform = CGAffineTransformScale(self.questionLabel.transform, 10, 10)
            
            }, completion: nil)
    }
    
    func questionLabelFadeOut() {
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.questionLabel.bounds = CGRectMake(0, 0, 0, 0)
            self.questionLabel.alpha = 0
            
            }, completion: nil)
        
        //self.questionLabel.bounds = temp
        
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
