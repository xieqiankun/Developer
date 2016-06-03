
import UIKit

let userCalendar = NSCalendar.currentCalendar()

// Let's create an NSDate for Valentine's Day
// using NSDateComponents
let valentinesDayComponents = NSDateComponents()
valentinesDayComponents.year = 2015
valentinesDayComponents.month = 2
valentinesDayComponents.day = 14
let valentinesDay = userCalendar.dateFromComponents(valentinesDayComponents)!

// Let's create an NSDate for St. Patrick's Day
// using NSDateFormatter
let dateMakerFormatter = NSDateFormatter()
dateMakerFormatter.calendar = userCalendar
dateMakerFormatter.dateFormat = "yyyy/MM/dd"
let stPatricksDay = dateMakerFormatter.dateFromString("2015/03/17")!


valentinesDay.earlierDate(stPatricksDay)
valentinesDay.laterDate(stPatricksDay)

valentinesDay.timeIntervalSinceDate(stPatricksDay)
stPatricksDay.timeIntervalSinceDate(valentinesDay)

// How many days between Valentine's Day and St. Patrick's Day?
let dayCalendarUnit: NSCalendarUnit = [.Month, .Day, .Hour, .Minute]
let stPatricksValentinesDayDifference = userCalendar.components(
    dayCalendarUnit,
    fromDate: valentinesDay,
    toDate: stPatricksDay,
    options: [])
// The result should be 31
stPatricksValentinesDayDifference.month
stPatricksValentinesDayDifference.day

valentinesDay.compare(stPatricksDay) == .OrderedAscending

