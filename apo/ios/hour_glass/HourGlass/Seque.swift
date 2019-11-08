
import Foundation
import UIKit

class RightPanelSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let firstView = source.view as UIView!
        let secondView = destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        //let screenHeight = UIScreen.main.bounds.size.height
        
        secondView?.frame = (secondView?.frame)!.offsetBy(dx: screenWidth, dy: 0.0)
        //secondView?.transform = (secondView?.transform)!.scaledBy(x: 0.9, y: 0.9)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondView!, aboveSubview: firstView!)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            firstView?.transform = (firstView?.transform.scaledBy(x: 0.99, y: 0.99))!
            firstView?.frame = ((firstView?.frame)?.offsetBy(dx: -screenWidth, dy: 0.0))!
            
            secondView?.transform = CGAffineTransform.identity
            secondView?.frame = (secondView?.frame.offsetBy(dx: -screenWidth, dy: 0.0))!
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
    }
}


class CustomSegue2: UIStoryboardSegue {
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func perform() {

    let firstVCView = destination.view as UIView!
    let thirdVCView = source.view as UIView!
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    firstVCView?.frame = (firstVCView?.frame)!.offsetBy(dx: 0.0, dy: screenHeight)
    firstVCView?.transform = (firstVCView?.transform)!.scaledBy(x: 0.001, y: 0.001)
    
    let window = UIApplication.shared.keyWindow
    window?.insertSubview(firstVCView!, aboveSubview: thirdVCView!)
    
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
    
    thirdVCView?.transform = (thirdVCView?.transform.scaledBy(x: 0.001, y: 0.001))!
    thirdVCView?.frame = ((thirdVCView?.frame)?.offsetBy(dx: 0.0, dy: -screenHeight))!
    
    firstVCView?.transform = CGAffineTransform.identity
    firstVCView?.frame = (firstVCView?.frame.offsetBy(dx: 0.0, dy: -screenHeight))!
    
    }) { (Finished) -> Void in
    
    self.source.dismiss(animated: false, completion: nil)
    }
    }
}

class CustomSegue: UIStoryboardSegue {
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func perform() {
        
        let firstVCView = self.source.view as UIView!
        let secondVCView = self.destination.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView?.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView?.frame = ((firstVCView?.frame)?.offsetBy(dx: 0.0, dy: -screenHeight))!
            secondVCView?.frame = (secondVCView?.frame)!.offsetBy(dx: 0.0, dy: -screenHeight)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }
        
    }
}

class CustomUnwindSegue: UIStoryboardSegue
{
    override func perform() {
        // Assign the source and destination views to local variables.
        let secondVCView = self.source.view as UIView!
        let firstVCView = self.destination.view as UIView!
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(firstVCView!, aboveSubview: secondVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView?.frame = (firstVCView?.frame.offsetBy(dx: 0.0, dy: screenHeight))!
            secondVCView?.frame = ((secondVCView?.frame)?.offsetBy(dx: 0.0, dy: screenHeight))!
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
    }
}

class CustomUnwindSegue2: UIStoryboardSegue
{
    override func perform() {
        let firstVCView = destination.view as UIView!
        let thirdVCView = source.view as UIView!
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        firstVCView?.frame = (firstVCView?.frame)!.offsetBy(dx: 0.0, dy: screenHeight)
        firstVCView?.transform = (firstVCView?.transform)!.scaledBy(x: 0.001, y: 0.001)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(firstVCView!, aboveSubview: thirdVCView!)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            thirdVCView?.transform = (thirdVCView?.transform.scaledBy(x: 0.001, y: 0.001))!
            thirdVCView?.frame = (thirdVCView?.frame)!.offsetBy(dx: 0.0, dy: -screenHeight)
            
            firstVCView?.transform = CGAffineTransform.identity
            firstVCView?.frame = (firstVCView?.frame.offsetBy(dx: 0.0, dy: -screenHeight))!
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
    }
}
