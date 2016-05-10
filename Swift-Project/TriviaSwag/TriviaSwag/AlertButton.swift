//
//  AlertButtonView.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

enum AlertButtonStyle {
    case Custom, Normal
}

class AlertButton: UIButton {
    
    init(title: String, imageNames images:[String], style: AlertButtonStyle) {
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        
        switch style {
        case .Custom:
            configureCustom(images)
        case .Normal:
            configureNormal(title)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustom(str:[String]){
        let imageUntouch = UIImage(named: str[0])
        let imageTouch = UIImage(named: str[1])
    
        self.setImage(imageTouch, forState: .Highlighted)
        self.setImage(imageUntouch, forState: .Normal)
    
    }
    
    func configureNormal(title: String){
        let imageUntouch = UIImage(named:"GenericButton-Untouched")
        let imageTouch = UIImage(named: "GenericButton-Touched")
        self.setImage(imageTouch, forState: .Highlighted)
        self.setImage(imageUntouch, forState: .Normal)
        
        self.setTitle(title, forState: .Normal)
    }
    
}
