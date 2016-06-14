//
//  GameViewController+RestartGame.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/13/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension GameViewController: RestartGame{
    
    func restartGame() {
        self.isAllowToStart = true
        self.isFirstQuestion = true
    }
    
}

