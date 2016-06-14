//
//  AccountField.swift
//  TriviaSwag
//
//  Created by Jared Eisenberg on 6/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class AccountField: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var fieldTitle: UILabel!
    @IBOutlet weak var fieldBody: UITextField!
    @IBOutlet weak var fieldOutline: UIView!
    
    weak var owner : AccountInfomationTableViewController?
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        owner?.fieldTracker[fieldTitle.text!] = fieldBody.text
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fieldOutline.layer.cornerRadius = 7
        fieldBody.delegate = self
    }
    
}
