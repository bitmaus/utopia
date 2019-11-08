
// application constants

import Foundation
import UIKit

struct appConstants {
    
    static let appName: String = "Hour Glass"
    static var userTheme = AppTheme.standard
    
    var userTimers = TimerBox()
}

enum AppTheme:Int {
    case standard = 1
    case wood = 2
    case metal = 3
    case rubber = 4
    case stone = 5
    case clean = 6
}

struct Theme {
    var themeName: String = "themeName"
    
    static let textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    static let borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    static let backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    
    static let goTime: String = "goColor"
    static let elapsedTime: String = "elapsedColor"
    static let stopTime: String = "stopColor"
    
    static let backgroundImage: String = "backgroundImage"
    static let tapSound: String = "tapSound"
    static let slidgeSound: String = "slideSound"
}

class appSetup {
    var constants = appConstants()
    var theme = Theme()
    
    func setTheme()
    {
      //  theme.themeName = constants.userTheme.rawValue
        //tempTheme.textColor =
        // inititalize theme variables using Assets...
    }
}
