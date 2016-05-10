//
//  SubmitQuestion ViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/28/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class SubmitQuestionTableViewController: UITableViewController, SubmitQuestionButtonDelegate {

    
    var category = "General Knowledge"
    var subcategory = ""
    var questionBody = ""
    var correctAnswer = ""
    var wrongAnswer1 = ""
    var wrongAnswer2 = ""
    var wrongAnswer3 = ""
    
    var currentFirstResponder: UIView?
    var currentEditTextField: NSIndexPath?
    
    deinit{
        print("be killed")
    }
    
    var categoryPickerVisible = false
    
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // categoryPicker delegate and datasource
//        self.categoryPicker.delegate = self
//        self.categoryPicker.dataSource = self
//        
        pickerData = ["General Knowledge", "Sports", "Entertainment"]
        // Do any additional setup after loading the view.
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SubmitQuestionTableViewController.hideKeyboard(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard(gesture: UIGestureRecognizer) {

        let point = gesture.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath != nil && indexPath?.section == 1 && indexPath?.section == 2 {
            if indexPath?.section == 1 {
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! QuestionCellTableViewCell
                self.currentFirstResponder = cell.textView
            } else if indexPath?.section == 2 {
                print("I am in here")
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! AnswerCellTableViewCell
                self.currentFirstResponder = cell.answerText
            }
            return
        }
        
        self.currentFirstResponder?.resignFirstResponder()
        
    }
    
    
    func showCategoryPicker() {

        let indexPathCategoryRow = NSIndexPath(forRow: 0, inSection: 0)
        let indexPathCategoryPicker = NSIndexPath(forRow: 1, inSection: 0)
        
        categoryPickerVisible = true
        
        if let categoryCell = tableView.cellForRowAtIndexPath(indexPathCategoryRow) {

            categoryCell.detailTextLabel?.textColor = categoryCell.detailTextLabel?.tintColor
        }
        
        tableView.beginUpdates()
        //tableView.reloadRowsAtIndexPaths([indexPathCategoryRow], withRowAnimation: .None)
        tableView.insertRowsAtIndexPaths([indexPathCategoryPicker], withRowAnimation: .Fade)
        tableView.endUpdates()

        
    }
    
    
    func hideCategoryPicker() {
        
        if categoryPickerVisible {
            categoryPickerVisible = false
            
            let indexPathCategoryRow = NSIndexPath(forRow: 0, inSection: 0)
            let indexPathCategoryPicker = NSIndexPath(forRow: 1, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPathCategoryRow) {
                cell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            //tableView.reloadRowsAtIndexPaths([indexPathCategoryRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathCategoryPicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
        
    }
    
    //MARK: - TableView Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 4
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            if categoryPickerVisible {
                return 2
            } else {
                return 1
            }
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    // Change cell color
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // TODO: - Change the color to background color
        view.tintColor = SettingSlaveTintColor
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Change the color of all cells
        cell.backgroundColor = SettingSlaveCellColor
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("categoryPickerCell", forIndexPath: indexPath) as! CategoryPickerTableViewCell

                cell.categoryPicker.delegate = self
                cell.categoryPicker.dataSource = self
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
                return cell
            }
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("questionBodyCell", forIndexPath: indexPath) as! QuestionCellTableViewCell
            
            cell.textView.text = "Question Body (max. 150 characters)"
            cell.textView.delegate = self
            
            return cell
            
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("inputCell", forIndexPath: indexPath) as! AnswerCellTableViewCell
            
            cell.answerText.delegate = self
            
            cell.index = indexPath.row
            
            if indexPath.row == 0{
                cell.answerText.placeholder = "Correct Answer"
            } else {
                cell.answerText.placeholder = "Incorrect Answer" + String(indexPath.row)
            }
            return cell
            
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("submitCell", forIndexPath: indexPath) as! SubmitQuestionButtonTableViewCell
            
            cell.delegate = self
            
            return cell
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0 && indexPath.row == 1 {
            return 120
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            return 120
            
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            if !categoryPickerVisible {
                showCategoryPicker()
            } else {
                hideCategoryPicker()
            }
        }
        
    }
    
    
    //MARK: - Submit Question Delegate
    func submitAction() {
        print(self.wrongAnswer1)
        print(self.wrongAnswer2)
        print(self.wrongAnswer3)
        print(self.correctAnswer)

        
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


// UIPicker
extension SubmitQuestionTableViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)){
            cell.detailTextLabel?.text = self.pickerData[row]
            self.category = self.pickerData[row]
        }
        
        
    }
    
    
    
}


extension SubmitQuestionTableViewController:  UITextFieldDelegate, UITextViewDelegate {
    
    // Text View Delegate
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

    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
        self.currentFirstResponder = textView
    }
    
    
    // Text Field Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentFirstResponder = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let indexPath = self.currentEditTextField
        {
            var nextIndex:(Int,Int)?
            switch (indexPath.section,indexPath.row) {
            case (2,0):
                nextIndex = (2,1)
            case (2,1):
                nextIndex = (2,2)
            case (2,2):
                nextIndex = (2,3)
            case (2,3):
                return false
            default:
                break
            }
            
            if let next = nextIndex {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: next.1, inSection: next.0)) as! AnswerCellTableViewCell
                cell.answerText.becomeFirstResponder()
                
            }
                
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = tableView.indexPathForCell(textField.superview?.superview as! UITableViewCell)!
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        switch (indexPath.section,indexPath.row) {
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
        
        currentEditTextField = indexPath
        
        return true
        
        
        
        
    }
    
    
}














