//
//  Time Formatting.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/3/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import Foundation

func stringForTournamentTimeComparedToNow(tournament: gStackTournament) -> String {
    switch tournament.status() {
    case .Active:
        let endDate = tournament.stopTime!
        
        let secondsUntilEnd = endDate.timeIntervalSinceNow
        let hoursUntilEnd = Int(secondsUntilEnd / 3600)
        let minutesUntilEnd = (Int(secondsUntilEnd) - hoursUntilEnd * 3600) / 60
        
        var hoursUnit = "Hour"
        if hoursUntilEnd != 1 {
            hoursUnit += "s"
        }
        
        var minutesUnit = "Minute"
        if minutesUntilEnd != 1 {
            minutesUnit += "s"
        }
        
        return "\(hoursUntilEnd) \(hoursUnit) \(minutesUntilEnd) \(minutesUnit) Remaining"
    case .Expired:
        let endDate = tournament.stopTime!
        
        let secondsSinceEnd = abs(endDate.timeIntervalSinceNow)
        let hoursSinceEnd = Int(secondsSinceEnd / 3600)
        let minutesSinceEnd = (Int(secondsSinceEnd) - hoursSinceEnd * 3600) / 60
        
        var hoursUnit = "Hour"
        if hoursSinceEnd != 1 {
            hoursUnit += "s"
        }
        
        var minutesUnit = "Minute"
        if minutesSinceEnd != 1 {
            minutesUnit += "s"
        }
        
        return "Ended \(hoursSinceEnd) \(hoursUnit) \(minutesSinceEnd) \(minutesUnit) Ago"
    case .Upcoming:
        let startDate = tournament.startTime!
        
        let secondsUntilStart = startDate.timeIntervalSinceNow
        let hoursUntilStart = Int(secondsUntilStart / 3600)
        let minutesUntilStart = (Int(secondsUntilStart) - hoursUntilStart * 3600) / 60
        
        var hoursUnit = "Hour"
        if hoursUntilStart != 1 {
            hoursUnit += "s"
        }
        
        var minutesUnit = "Minute"
        if minutesUntilStart != 1 {
            minutesUnit += "s"
        }
        
        return "Starts in \(hoursUntilStart) \(hoursUnit) \(minutesUntilStart) \(minutesUnit)"
    }
}

func stringForChatMessageTimeComparedToNow(message: triviaTournamentChatMessage) -> String {
    if message.date == nil {
        return "???"
    } else {
        let minutes = NSDate().minutesAfterDate(message.date!)
        if minutes == 0 {
            var seconds = NSDate().timeIntervalSinceDate(message.date!)
            if seconds < 0 {
                seconds = 0
            }
            return String(Int(seconds))+"s"
        }
        else if minutes < 60 {
            return String(minutes)+"m"
        } else {
            let hours = NSDate().hoursAfterDate(message.date!)
            if hours < 24 {
                return String(hours)+"h"
            } else {
                let days = NSDate().daysAfterDate(message.date!)
                if days < 7 {
                    return String(days)+"d"
                } else {
                    let weeks = days / 7
                    if weeks < 52 {
                        return String(weeks)+"w"
                    } else {
                        let years = weeks / 52
                        return String(years)+"y"
                    }
                }
            }
        }
    }
}

func stringForDateComparedToNow(date: NSDate) -> String {
    let minutes = NSDate().minutesAfterDate(date)
    if minutes == 0 {
        var seconds = NSDate().timeIntervalSinceDate(date)
        if seconds < 0 {
            seconds = 0
        }
        return String(Int(seconds))+" seconds ago"
    }
    else if minutes < 60 {
        return String(minutes)+" minutes ago"
    } else {
        let hours = NSDate().hoursAfterDate(date)
        if hours < 24 {
            return String(hours)+" hours ago"
        } else {
            let days = NSDate().daysAfterDate(date)
            if days < 7 {
                return String(days)+" days ago"
            } else {
                let weeks = days / 7
                if weeks < 52 {
                    return String(weeks)+" weeks ago"
                } else {
                    let years = weeks / 52
                    return String(years)+" years ago"
                }
            }
        }
    }
}