
import Foundation
import UIKit

class Statistics {
    var totalRunTime: Int?
    var remainingRunTime: Int?
    
    var totalEventTime: Int?
    var remainingEventTime: Int?
    
    var numTimers: Int?
    var numEvents: Int?
    
    var activeTimers: Int?
    
    var savedTimers: Int?
    var savedEvents: Int?
    
    func updateStatistics(timerSet: TimerBox)
    {
        for i in 1...timerSet.timerBox.count {
            let tempTimer = timerSet.timerBox[i]
            
            switch tempTimer.core.timerStatus {
            case TimerCore.Status.fixed:
                //numEvents += 1
                
                totalEventTime = 0
                remainingEventTime = 0
                
                if tempTimer.timerSave
                {
                  //  savedEvents += 1
                }
                
                break
            case TimerCore.Status.run, TimerCore.Status.pause:
               // numTimers += 1
                //activeTimers += 1
                
                totalRunTime = 0
                remainingRunTime = 0
                
                if tempTimer.timerSave {
                 //   savedTimers += 1
                }
                
                break
            case TimerCore.Status.stop:
              //  numTimers += 1
                
                if tempTimer.timerSave {
                //    savedTimer += 1
                }
                
                break
            default:
                break
            }
        }
    }
}

class TimeView {
    
    func setRemainingTime(timer: TimerPart) // core functionality in the box of timers...
    {
        let currentTime = NSDate()
        
        switch timer.core.timerStatus
        {
        case TimerCore.Status.fixed:
            timer.core.timerSpan = timer.core.timerStamp - currentTime.timeIntervalSinceNow
            break
        case TimerCore.Status.start:
            timer.core.timerStamp = currentTime.timeIntervalSince1970 - timer.core.timerStamp
            timer.core.timerStatus = TimerCore.Status.run
            break
        case TimerCore.Status.run:
            
            break
        case TimerCore.Status.pause:
            timer.core.timerStamp = currentTime.timeIntervalSince1970 - timer.core.timerStamp
            timer.core.timerStatus = TimerCore.Status.stop
            break
        default:
            break
        }
        
        NSLog("%@", "\(timer.core.timerStamp) => \(timer.core.timerSpan)")
    }
    
    func getRemainingTime(timer: TimerPart) -> String // complements core function above...
    {
        let currentTime = NSDate()
        
        switch timer.core.timerStatus
        {
        case TimerCore.Status.fixed:
            return convertTime(outputTime: timer.core.timerSpan)
            
        default:
            //return String(format: "%02d", timer.core.timerStamp)
            return convertTime(outputTime: currentTime.timeIntervalSince1970 - timer.core.timerStamp)
            
        }
    }
    
    private class func days(outputTime: TimeInterval) -> UInt8 {
        return UInt8(outputTime / 60.0)
    }
    
    private class func hours(outputTime: TimeInterval) -> UInt8 {
        var elapsedTime = outputTime
        
        let days = self.days(outputTime: outputTime)
        elapsedTime -= (TimeInterval(days) * 60)
        
        return UInt8(elapsedTime / 24.0) //was 1440?
    }
    
    private class func minutes(outputTime: TimeInterval) -> UInt8 {
        var elapsedTime = outputTime
        
        let days = self.days(outputTime: outputTime)
        elapsedTime -= (TimeInterval(days) * 60)
        
        let hours = self.hours(outputTime: outputTime)
        elapsedTime -= (TimeInterval(hours) * 24)
        
        return UInt8(elapsedTime / 60.0)
    }
    
    public func convertTime(outputTime: TimeInterval) -> String {
        var elapsedTime = outputTime
        
        //let months = UInt8(elapsedTime / )
        
        let years = UInt8(elapsedTime / 31536000.0)
        elapsedTime -= (TimeInterval(years) * 31536000)
        
        let days = UInt8(elapsedTime / 86400.0)
        elapsedTime -= (TimeInterval(days) * 86400)
        
        let hours = UInt8(elapsedTime / 1440.0) //was 24
        elapsedTime -= (TimeInterval(hours) * 1440)
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        let strDays = String(format: "%02d", days)
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        if (days != 0) {
            return "\(strDays):\(strHours):\(strMinutes)"
        }
        else {
            return "\(strHours):\(strMinutes):\(strSeconds)"
        }
    }
    
}
