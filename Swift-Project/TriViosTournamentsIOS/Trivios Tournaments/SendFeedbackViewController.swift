//
//  SendFeedbackViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/25/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class SendFeedbackViewController: UIViewController, UITextViewDelegate {
    
    var reportVC: ReportQuestionTableViewController?
    var tournament: gStackTournament?
    var question: gStackGameQuestion?

    @IBOutlet var feedbackTextView: UITextView!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: - UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            submit()
        } else {
            let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
            if newText.characters.count > 0 {
                submitButton.enabled = true
            } else {
                submitButton.enabled = false
            }
        }
        return true
    }
    
    
    @IBAction func submit() {
        if tournament!.questions!._zone == nil {
            tournament!.questions!._zone = ""
        }
        if tournament!.questions!.category == nil{
            tournament!.questions!.category = ""
        }
        let flaggableQuestion = gStackQuestion(aZone: tournament!.questions!._zone!, _category: tournament!.questions!.category!, _questionBody: question!.question!, _reason: feedbackTextView.text)
        gStackFlagQuestion(flaggableQuestion, completion: {
            error in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: "There was an error: \(error!.domain)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Success", message: "The question was successfully reported. Thanks!", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "You're Welcome", style: UIAlertActionStyle.Default, handler: { action in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.reportVC?.shouldPop = true
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            })
        })
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
