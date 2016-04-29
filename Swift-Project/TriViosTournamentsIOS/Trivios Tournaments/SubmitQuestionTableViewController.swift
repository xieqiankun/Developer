//
//  SubmitQuestionTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/11/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class EnterQuestionDataTableViewCell: UITableViewCell {
    @IBOutlet var inputTextField: UITextField?
    @IBOutlet var inputTextView: UITextView? //Do this to allow multiline input
}

class SubmitQuestionDataTableViewCell: UITableViewCell {
    @IBOutlet var submitButton: UIButton!
    
    @IBAction func submitButtonPressed() {
        NSNotificationCenter.defaultCenter().postNotificationName("SubmitButtonPressed", object: nil)
    }
}

class SubmitQuestionTableView: UITableView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName("QTVTouchesBegan", object: nil)
    }
}

class SubmitQuestionTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var category = "General Knowledge"
    var subcategory = ""
    var questionBody = ""
    var correctAnswer = ""
    var wrongAnswer1 = ""
    var wrongAnswer2 = ""
    var wrongAnswer3 = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cancellingTouch", name: "QTVTouchesBegan", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "submit", name: "SubmitButtonPressed", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Question Categories"
        case 1:
            let remaining = 150 - questionBody.characters.count
            return "Question Body ("+String(remaining)+"/150)"
        case 2:
            return "Question Answers"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 88
        }
        else {
            return 44
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmitCell", forIndexPath: indexPath) as! SubmitQuestionDataTableViewCell
            
            return cell
        }
        else {
            var identifier = "InputCell"
            if indexPath.section == 0 && indexPath.row == 0 {
                identifier = "CategoryCell"
            }
            if indexPath.section == 1 {
                identifier = "QuestionBodyCell"
            }
            
             cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! EnterQuestionDataTableViewCell
            
            // Configure the cell...
            
            let inputTextField = (cell as! EnterQuestionDataTableViewCell).inputTextField
            //We have to cast again for some stupid fucking reason
            let inputTextView = (cell as! EnterQuestionDataTableViewCell).inputTextView
            
            let inputToolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.width, 50))
            let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "cancellingTouch")
            //Add next/prev buttons?
            let items = [flexibleSpaceItem,doneButton]
            inputToolbar.items = items
            
            inputTextField?.inputAccessoryView = inputToolbar
            inputTextView?.inputAccessoryView = inputToolbar
            
            switch (indexPath.section,indexPath.row) {
            case (0,0):
                inputTextField!.text = category
                let pickerView = UIPickerView()
                pickerView.dataSource = self
                pickerView.delegate = self
                inputTextField?.inputView = pickerView
            case (0,1):
                inputTextField!.placeholder = "Subcategory (optional)"
                inputTextField!.enablesReturnKeyAutomatically = false
            case (1,0):
                inputTextView!.text = "Question Body (max. 150 characters)"
            case (2,0):
                inputTextField!.placeholder = "Correct Answer"
            default:
                inputTextField!.placeholder = "Wrong Answer "+String(indexPath.row)
            }
            
            if indexPath.section == 2 && indexPath.row == 3 {
                inputTextField!.returnKeyType = .Go
            }
            
            return cell
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - PickerView Data Source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    var categories = ["General Knowledge","Sports","Entertainment"]
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    //MARK: - PickerView Delegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row]
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EnterQuestionDataTableViewCell
        cell.inputTextField?.text = category
    }
    
    
    //MARK: - Text View Delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newString = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        if newString.characters.count <= 150 {
            questionBody = newString
        }
        else {
            return false
        }
        let remaining = 150 - questionBody.characters.count
        tableView.headerViewForSection(1)?.textLabel!.text = "Question Body ("+String(remaining)+"/150)"
        
        return true
    }
    
    //MARK: - Text Field Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let indexPath = tableView.indexPathForCell(textField.superview?.superview as! UITableViewCell)!
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        switch (indexPath.section,indexPath.row) {
        case (0,1):
            subcategory = newString
        case (2,0):
            correctAnswer = newString
        case (2,1):
            wrongAnswer1 = newString
        case (2,2):
            wrongAnswer2 = newString
        case (2,3):
            wrongAnswer3 = newString
        default:
            break
        }
        
        return true
    }
    
    var indexPathOfSelectedTextField = NSIndexPath(forRow: 0, inSection: 0)
    
    func textFieldDidBeginEditing(textField: UITextField) {
        indexPathOfSelectedTextField = tableView.indexPathForCell(textField.superview?.superview as! UITableViewCell)!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        var nextIndex = (0,1)
        switch (indexPathOfSelectedTextField.section,indexPathOfSelectedTextField.row) {
        case (0,1):
            nextIndex = (1,0)
        case (2,0):
            nextIndex = (2,1)
        case (2,1):
            nextIndex = (2,2)
        case (2,2):
            nextIndex = (2,3)
        case (2,3):
            submit()
            return false
        default:
            break
        }
        
        if let nextTextField = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: nextIndex.1, inSection: nextIndex.0)) as! EnterQuestionDataTableViewCell).inputTextField {
            nextTextField.becomeFirstResponder()
        }
        else if let nextTextView = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: nextIndex.1, inSection: nextIndex.0)) as! EnterQuestionDataTableViewCell).inputTextView {
            nextTextView.becomeFirstResponder()
        }
        
        return false
    }
    
    func cancellingTouch() {
        for cell in tableView.visibleCells {
            if cell.isKindOfClass(EnterQuestionDataTableViewCell.self) {
                if (cell as! EnterQuestionDataTableViewCell).inputTextField?.isFirstResponder() == true {
                    (cell as! EnterQuestionDataTableViewCell).inputTextField!.resignFirstResponder()
                }
                else if (cell as! EnterQuestionDataTableViewCell).inputTextView?.isFirstResponder() == true {
                    (cell as! EnterQuestionDataTableViewCell).inputTextView!.resignFirstResponder()
                }
            }
        }
    }
    
    
    //MARK: - Submit
    func submit() {
        if category.characters.count > 0 && questionBody.characters.count > 0 && correctAnswer.characters.count > 0 && wrongAnswer1.characters.count > 0 && wrongAnswer2.characters.count > 0 && wrongAnswer3.characters.count > 0 {
            print("SUBMIT")
            let question = gStackQuestion(aZone: category, _category: subcategory, _questionBody: questionBody, _answers: [correctAnswer,wrongAnswer1,wrongAnswer2,wrongAnswer3])
            gStackSubmitQuestion(question, completion: { error in
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil {
                        let alert = UIAlertController(title: "There Was An Error", message: "It was: "+error!.description, preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Success", message: "Your question was submitted!", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                            dispatch_async(dispatch_get_main_queue(), {
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            })
        }
        else {
            let alert = UIAlertController(title: "Empty Field", message: "One or more of the required fields is empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
