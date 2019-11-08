
import Foundation
import CoreLocation

class Event
{
    var timerLocation = CLLocation()
    
    enum EventType {
        case startTimer
        case stopTimer
    }

    var timerEventType = EventType.stopTimer
}
