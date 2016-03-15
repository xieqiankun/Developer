//
//  DetailViewController.swift
//  Homeowner
//
//  Created by 谢乾坤 on 3/10/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var serialNumberField: UITextField!
    
    @IBOutlet weak var valueField: UITextField!

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            
        } else {
            
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        //place it on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //why don't need to add override before, maybe they don't imple them before
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //put that image on the screen
        imageView.image = image
        
        imageStore.setImage(image, forKey: item.itemKey)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        
        //clear first responser
        view.endEditing(true)
        
        
    }
    
    let numberFormatter:NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
       // valueField.text = "\(item.valueInDollars)"
       // dateLabel.text = "\(item.dateCreated)"
        
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
        
        //get uuid
        let key = item.itemKey
        
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //clear first responser
        view.endEditing(true)
        
        //save changes
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
            
            item.valueInDollars = value.integerValue
            
        }
        else {
            item.valueInDollars = 0
        }
    }
    
    //UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true

    }
    
    

    
    
}
