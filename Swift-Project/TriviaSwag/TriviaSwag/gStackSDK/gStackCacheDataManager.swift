//
//  gStackCacheDataManager.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/12/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class gStackCacheDataManager: NSObject {

    var cachedTournaments:[gStackTournament]{
        get {
            return gStackCachedTournaments
        }
    }
    
    var cachedLeaderboard:[String:gStackTournamentLeaderboard]{
        get {
            return gStackCachedLeaderBoard
        }
    }
    
    
}
