
import Foundation

class TimerCore {
    
    var timerStamp = TimeInterval()
    var timerSpan = TimeInterval()
    
    enum Status:Int {
        case start = 1
        case stop = 2
        case pause = 3
        case run = 4
        case fixed = 5
    }
    
    var timerStatus: Status
    
    init?(timeStatus: Status, timeStamp: TimeInterval, timeSpan: TimeInterval) {
        timerStatus = timeStatus
        timerStamp = timeStamp
        timerSpan = timeSpan
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init(timeStatus: decoder.decodeObject(forKey: "timerStatus") as! Status, timeStamp: decoder.decodeObject(forKey: "timerStamp") as! TimeInterval, timeSpan: decoder.decodeObject(forKey: "timerSpan") as! TimeInterval)!
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(timerStatus, forKey: "timerStatus")
        coder.encode(timerStamp, forKey: "timerStamp")
        coder.encode(timerSpan, forKey: "timerSpan")
    }
}
