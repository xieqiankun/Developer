//
//  gStackCacheDataManager.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/12/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

var gStackFetchTournamentsNotificationName = "gStackFetchTournamentsNotification"
var gStackFetchTournamentLeaderboardName = "gStackFetchTournamentLeaderboardNotification"

class gStackCacheDataManager: NSObject {

    static let sharedInstance = gStackCacheDataManager()
    
    private var cachedTournaments:[gStackTournament] = [gStackTournament]() {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName(gStackFetchTournamentsNotificationName, object: nil)
        }
    }
    
    private var cachedLeaderboard:[String:gStackTournamentLeaderboard] = [String:gStackTournamentLeaderboard]()
    
    private var timer:NSTimer?

    deinit{
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func refresh() {
        cachedLeaderboard.removeAll()
        
    }
    
    func setTournaments(tournaments:[gStackTournament]) {
        cachedTournaments = tournaments
    }
    
    func getTournaments() -> [gStackTournament]{
        return cachedTournaments
    }
    
    func refreshTournaments() {
        gStackFetchTournaments { (error, tournaments) in
            
        }
    }
    
    func setLeaderboard(uid: String, leaderboard: gStackTournamentLeaderboard) {
    
        cachedLeaderboard[uid] = leaderboard
        
    }
    
    func getLeaderboard(tournament: gStackTournament) -> gStackTournamentLeaderboard? {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: #selector(gStackCacheDataManager.refresh), userInfo: nil, repeats: true)
        }
        if let leaderboard = cachedLeaderboard[tournament.uuid!]{
            return leaderboard
        } else {
            gStackFetchLeaderboardForTournament(tournament, completion: { (error, leaderboard) in
                if error == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(gStackFetchTournamentLeaderboardName, object: nil)
                }
            })
            return nil
        }
    }
    
    
    func preLoadData() {
        
        gStackFetchTournaments { (error, tournaments) in
            
        }
    }
    
    
    
}
