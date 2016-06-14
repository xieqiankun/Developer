//
//  GameViewController+PreGame.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension GameViewController {
    
    func preGameAnimationInit() {
        
        pre_height1.active = true
        pre_height2.active = true
        pre_height3.active = true
        
        precount_height1.active = true
        precount_height2.active = true
        precount_height3.active = true
        
        self.pre_11.active = true
        self.pre_12.active = true
        self.pre_13.active = true
        
        self.precount_11.active = true
        self.precount_21.active = true
        self.precount_31.active = true
        
        self.pre_21.active = true
        self.pre_22.active = true
        self.pre_23.active = true
        
        self.precount_12.active = true
        self.precount_22.active = true
        self.precount_32.active = true
        
        self.finishPrepare.constant = 0
        
        
    }
    
    func preGameAnimation() {
        
        pre_height1.active = false
        pre_height2.active = false
        pre_height3.active = false
        
        precount_height1.active = false
        precount_height2.active = false
        precount_height3.active = false
        
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { 
            self.view.layoutIfNeeded()
            self.pregameLoading.alpha = 1
            
            }, completion: {
                finished in
        })
     
    }
    
    func preGameStartTimer(time: Double){
        
        self.pre_11.active = false
        self.pre_12.active = false
        self.pre_13.active = false
        
        self.precount_11.active = false
        self.precount_21.active = false
        self.precount_31.active = false
        
        UIView.animateWithDuration(time/3, delay: time / 3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.pre_21.active = false
                self.pre_22.active = false
                self.pre_23.active = false
                
                self.precount_12.active = false
                self.precount_22.active = false
                self.precount_32.active = false
                
                UIView.animateWithDuration(time/3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
        })
        
    }
    
    
    func preGameToGaming() {
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: [], animations: { 
            self.finishPrepare.constant = self.view.bounds.width
            }, completion: {
                finished in

        })
    }
    
    
    
    
    
}










