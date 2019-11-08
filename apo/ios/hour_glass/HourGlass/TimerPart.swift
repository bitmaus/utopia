
import UIKit

class TimerPart {
    
    var core: TimerCore
    
    // parameters
    var timerName: String!
    var timerDescription: String!
    var timerColor: UIColor!
    var timerIcon: String!
    var timerPicture: String!
    
    var timerDisplay: String = "00:00"
    var timerShow: Bool = true
    var timerGroup: String = "Basic"
    var timerLevel: Int = 1
    
    // special features
    var timerLog: Bool = true
    var timerSave: Bool = true
    
    var timerSchedule = Schedule()
    var timerNotification = Notification()
    var timerEvent = Event()
    
    func start() {
        core.timerStatus = TimerCore.Status.start
    }
    
    func pause() {
        core.timerStatus = TimerCore.Status.pause
    }
    
    func stop() {
        core.timerStatus = TimerCore.Status.stop
    }
    
    func restart() {
        core.timerStatus = TimerCore.Status.start
    }
    
    init?(timeType: TimerCore.Status, timeStamp: TimeInterval, timeSpan: TimeInterval) {
        
        core = TimerCore(timeStatus: timeType, timeStamp: timeStamp, timeSpan: timeSpan)!
        
        switch timeType {
            
        case .stop:
            timerName = "Timer"
            timerDescription = "timer description"
            timerColor = UIColor.green
            timerIcon = "circle"
            timerPicture = "basic_timer"

        case .fixed:
            timerName = "Event"
            timerDescription = "event description"
            timerColor = UIColor.blue
            timerIcon = "square"
            timerPicture = "basic_event"
        
        default:
            break
        }
    }
    
    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: duration)!
    }
    
    //for d in [12600.0, 90000.0, 900.0, 13500.0] {
    //let str = format(d)
    //print("\(d): \(str)")
    //}
}
