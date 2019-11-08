
import Foundation

class Schedule {
    
    enum TimerScheduleType {
        case Once
        case Daily
        case Weekly
        case Monthly
        case Yearly
        case Custom
    }
    
    var timerScheduleType = TimerScheduleType.Once
    
    var timerScheduleName: String = "Default Timer Schedule"
    var timerScheduleDescription: String = "The default timer schedule only occurring once"
    
    //var instant: Bool
    
    //var days = [Bool]()
    //var scheduledTime = TimeInterval()
    
    //var repeater: Bool
    
    //init?()
    //{

    //}
    
    //init?(name: String, description: String) {
      //  self.name = name
       // self.description = description
        
       // self.instant = true
       // self.repeater = false
        
        //if name.isEmpty {
          //  return nil
       // }
   // }
    
    //func setup(days: [Bool], repeater: Bool, scheduledTime: TimeInterval) {
      //  self.days = days
        //self.repeater = repeater
        //self.scheduledTime = scheduledTime
        
        //self.instant = false
    //}
}

