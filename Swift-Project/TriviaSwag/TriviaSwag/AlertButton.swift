//
//  AlertButtonView.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

enum AlertButtonStyle {
    case Custom, Normal,Cancel
}

class AlertButton: UIButton {
    
    var function: (() -> ())?
    
    init(title: String, imageNames images:[String], style: AlertButtonStyle, action:(() -> ())?) {
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        function = action
        
        switch style {
        case .Custom:
            configureCustom(images)
        case .Normal:
            configureNormal(title)
        case .Cancel:
            configureCancel()
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
        // add action
        self.addTarget(self, action: #selector(AlertButton.handleTap), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func configureNormal(title: String){
        let imageUntouch = UIImage(named:"GenericButton-Untouched")
        let imageTouch = UIImage(named: "GenericButton-Touched")
        self.setImage(imageTouch, forState: .Highlighted)
        self.setImage(imageUntouch, forState: .Normal)
        
        self.setTitle(title, forState: .Normal)
        self.addTarget(self, action: #selector(AlertButton.handleTap), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func configureCancel(){
        let imageUntouch = UIImage(named:"DismissButton-Untouched")
        let imageTouch = UIImage(named: "DismissButton-Touched")
        self.setImage(imageTouch, forState: .Highlighted)
        self.setImage(imageUntouch, forState: .Normal)
        
        self.addTarget(nil, action: #selector(AlertViewController.close), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func handleTap() {
        
        function?()
        print("tap")
    }
    
}
