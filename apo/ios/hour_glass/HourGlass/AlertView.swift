
// or use UIAlertController?

import Foundation
import UIKit

class AlertView: UIViewController {
    
var customView: UIView!
    
override func viewDidLoad()
{
    super.viewDidLoad()
    customView.isHidden = true
}

func ViewFunc()
{
    customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 200))
    view.addSubview(customView)
    customView.isHidden = false
    // then you create whatever you want to code
    // for example if I want to add OK button to your view
    
    let OkayButton = UIButton(frame: CGRect(x: 40, y: 100, width: 50, height: 50))
    customView.addSubview(OkayButton)
    
    OkayButton.addTarget(self, action: "okButtonImplementation:", for: UIControlEvents.touchUpInside)
    
    // from now any object you add that object to the customView subview :)
    
}


func okButtonImplementation(sender:UIButton)
{
    // do whatever you want
    // make view disappears again
}


@IBAction func RateButton(sender:UIBarButtonItem)
{
    // this is barButton located at the top of your tableview navigation bar
    
    ViewFunc()
}
}
