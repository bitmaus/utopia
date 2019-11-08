
import Foundation

class TimerBox {
    
    //@IBOutlet weak var upController:TimerListViewController?
    
    var timerBox = [TimerPart]()
    var timerHelper = TimeView()
    
    var timer:Timer = Timer()
    
    func addTimer(timerType: TimerCore.Status, timerStamp: TimeInterval, timerSpan: TimeInterval)
    {
        let newTimer = TimerPart(timeType: timerType, timeStamp: timerStamp, timeSpan: timerSpan)
        timerBox.append(newTimer!)
    }
    
    init?()
    {

    }
    
    func startCycle()
    {
        if (!self.timer.isValid) {
            let aSelector : Selector = #selector(self.updateTime)
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            //pausedTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    @objc func updateTime() {
        
        for userTimer in timerBox {
            timerHelper.setRemainingTime(timer: userTimer)
            userTimer.timerDisplay = timerHelper.getRemainingTime(timer: userTimer)
        }
        
        //upController?.updateTimers()
    }
    
    func stopBox()
    {
        timer.invalidate()
    }
}
