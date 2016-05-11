//
//  StoryboardViewControllerFactory.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

protocol AlertViewControllerFactory {
    func createAlertViewController(alertButtons:[AlertButton], title: String, message: String) -> AlertViewController
    func createAlertViewController(error:NSError) -> AlertViewController
}

class StoryboardAlertViewControllerFactory: AlertViewControllerFactory {
    
    func createAlertViewController(alertButtons: [AlertButton], title: String, message: String) -> AlertViewController {

        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        print(#function)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AlertViewController") as! AlertViewController
        vc.alertButtons = alertButtons
        vc.alertTitle = title
        vc.alertMessage = message
        
        vc.error = NSError(domain: "", code: -1, userInfo: nil)

        return vc
    }
    
    func createAlertViewController(error: NSError) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AlertViewController") as! AlertViewController
        vc.error = error
        
        vc.alertButtons = []
        vc.alertMessage = ""
        vc.alertTitle = ""
        
        return vc
    }
    
    
}
