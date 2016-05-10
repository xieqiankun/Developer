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
}

class StoryboardAlertViewControllerFactory: AlertViewControllerFactory {
    
    func createAlertViewController(alertButtons: [AlertButton], title: String, message: String) -> AlertViewController {

        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AlertViewController") as! AlertViewController
        vc.alertButtons = alertButtons
        vc.alertMessage = title
        vc.alertMessage = message
        
        return vc
    }
    
}