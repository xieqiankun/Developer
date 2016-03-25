//
//  PromotionsViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/24/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class PromotionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var promoCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        gStackRedeemPromoCode(textField.text!, completion: {
            error, summary in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "There was an error: \(error!.domain)", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Promo Code Redeemed", message: summary!, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Neat", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if promoCodeTextField.isFirstResponder() && touch!.view != promoCodeTextField {
            promoCodeTextField.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
}
