
import Foundation
import UIKit
import CloudKit

class LoadViewController: UIViewController {
    
    let container = UIView()
    let redSquare = UIView()
    let greenSquare = UIView()
    
    let container2 = UIView()
    let redSquare2 = UIView()
    let greenSquare2 = UIView()
    
    @IBOutlet weak var statusLabel: UILabel?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        self.statusLabel?.text = "LOADING RESOURCES"
        //self.statusLabel?.text = ""
        
        let x = self.view.center.x
        let y = self.view.center.y
        
        self.statusLabel?.center.y = y - 80
        self.statusLabel?.center.x = x + 80
        
        // set container frame and add to the screen
        self.container.frame = CGRect(x: x-168, y: y-94, width: 64, height: 64)
        self.view.addSubview(container)

        self.redSquare.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        self.greenSquare.frame = redSquare.frame
        
        self.redSquare.backgroundColor = UIColor.red
        self.greenSquare.backgroundColor = UIColor.green
        
        //self.container.addSubview(self.redSquare)
        

        // set container frame and add to the screen
        self.container2.frame = CGRect(x: x-100, y: y-94, width: 64, height: 64)
        self.view.addSubview(container2)
        
        self.redSquare2.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        self.greenSquare2.frame = redSquare2.frame
        
        // set background colors
        self.redSquare2.backgroundColor = UIColor.red
        self.greenSquare2.backgroundColor = UIColor.green
        
        // for now just add the redSquare
        // we'll add blueSquare as part of the transition animation
        //self.container2.addSubview(self.redSquare2)

        let onyx = CAShapeLayer()
        let aluminum = CAShapeLayer()
        let bandGreen = CAShapeLayer()
        let bandRed = CAShapeLayer()
        let dial = CAShapeLayer()
        
        
        
        self.view.layer.addSublayer(bandGreen)
        self.view.layer.addSublayer(bandRed)
        self.view.layer.addSublayer(onyx)
        self.view.layer.addSublayer(aluminum)
        //self.view.layer.addSublayer(dial)
        
        onyx.fillColor = UIColor.red.cgColor
        aluminum.fillColor = UIColor.green.cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:x-10, y:y-30))
        path.addLine(to: CGPoint(x:x-10, y:y-60))
        path.addLine(to: CGPoint(x:x+10, y:y-60))
        path.addLine(to: CGPoint(x:x+10, y:y-30))
        path.addLine(to: CGPoint(x:x-10, y:y-30))
        path.close()
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x:x-100, y:y-30))
        path2.addLine(to: CGPoint(x:x-100, y:y-94))
        path2.addLine(to: CGPoint(x:x-36, y:y-94))
        path2.addLine(to: CGPoint(x:x-36, y:y-30))
        path2.addLine(to: CGPoint(x:x-100, y:y-30))
        path2.close()
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x:x+10, y:y-30))
        path3.addLine(to: CGPoint(x:x+10, y:y-60))
        path3.addLine(to: CGPoint(x:x+30, y:y-60))
        path3.addLine(to: CGPoint(x:x+30, y:y-30))
        path3.addLine(to: CGPoint(x:x+10, y:y-30))
        path3.close()
        
        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x:x-168, y:y-30))
        path4.addLine(to: CGPoint(x:x-168, y:y-94))
        path4.addLine(to: CGPoint(x:x-104, y:y-94))
        path4.addLine(to: CGPoint(x:x-104, y:y-30))
        path4.addLine(to: CGPoint(x:x-168, y:y-30))
        path4.close()
        
        let animationSquare = CABasicAnimation(keyPath: "path")
        animationSquare.toValue = path2
        animationSquare.duration = 1 // duration is 1 sec
        animationSquare.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animationSquare.fillMode = kCAFillModeBoth // keep to value after finishing
        animationSquare.isRemovedOnCompletion = false // don't remove after finishing

        //square.add(animationSquare, forKey: animationSquare.keyPath)
        
        let startAluminum = path3.cgPath//UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 40, height: 40), cornerRadius: 10).cgPath
        let endAluminum = path4.cgPath//UIBezierPath(roundedRect: CGRect(x: x+100, y: y, width: 64, height: 64), cornerRadius: 16).cgPath
        
        aluminum.path = startAluminum
        
        let animationAluminum = CABasicAnimation(keyPath: "path")
        animationAluminum.toValue = endAluminum
        animationAluminum.duration = 1 // duration is 1 sec
        animationAluminum.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animationAluminum.fillMode = kCAFillModeBoth // keep to value after finishing
        animationAluminum.isRemovedOnCompletion = false // don't remove after finishing
        
        aluminum.add(animationAluminum, forKey: animationAluminum.keyPath)
        
        let startOnyx = path.cgPath// UIBezierPath(roundedRect: CGRect(x: x, y: y-20, width: 20, height: 20), cornerRadius: 16).cgPath
        let endOnyx = path2.cgPath//UIBezierPath(roundedRect: CGRect(x: x-100, y: y-32, width: 64, height: 64), cornerRadius: 16).cgPath
        
        onyx.path = startOnyx
        
        let animationOnyx = CABasicAnimation(keyPath: "path")
        animationOnyx.toValue = endOnyx
        animationOnyx.duration = 1 // duration is 1 sec
        animationOnyx.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animationOnyx.fillMode = kCAFillModeBoth // keep to value after finishing
        animationOnyx.isRemovedOnCompletion = false // don't remove after finishing
        
        onyx.add(animationOnyx, forKey: animationOnyx.keyPath)
        
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: 1)
        bandGreen.bounds = rect
        bandGreen.position.x = x
        bandGreen.position.y = y + 20
        bandGreen.path = UIBezierPath(rect:rect).cgPath
        bandGreen.lineWidth = 4
        bandGreen.strokeColor = UIColor.green.cgColor
        let animationBandGreen = CABasicAnimation(keyPath: "lineWidth")
        animationBandGreen.toValue = 10
        animationBandGreen.duration = 1 // duration is 1 sec
        animationBandGreen.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animationBandGreen.fillMode = kCAFillModeBoth // keep to value after finishing
        animationBandGreen.isRemovedOnCompletion = false // don't remove after finishing
        bandGreen.add(animationBandGreen, forKey: animationBandGreen.keyPath)
        
        bandRed.bounds = rect
        bandRed.position.x = x
        bandRed.position.y = y + 16
        bandRed.path = UIBezierPath(rect:rect).cgPath
        bandRed.lineWidth = 4
        bandRed.strokeColor = UIColor.red.cgColor
        
        let animationBandRed = CABasicAnimation(keyPath: "lineWidth")
        animationBandRed.toValue = 10
        animationBandRed.duration = 1 // duration is 1 sec
        animationBandRed.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animationBandRed.fillMode = kCAFillModeBoth // keep to value after finishing
        animationBandRed.isRemovedOnCompletion = false // don't remove after finishing
        bandRed.add(animationBandRed, forKey: animationBandRed.keyPath)
    
        let appTimers = appSetup()
    
        self.statusLabel?.text = "LOADING RESOURCES"
    
        let cloudHook = Cloud()
    
        cloudHook.syncCloud(timerBox: appTimers.constants.userTimers!)
    
        // add delay...
        let whenIcon = DispatchTime.now() + 2

        DispatchQueue.main.asyncAfter(deadline: whenIcon) {
            let whenIcon2 = DispatchTime.now() + 1
            self.container.addSubview(self.greenSquare)
            self.container2.addSubview(self.redSquare2)
            
            DispatchQueue.main.asyncAfter(deadline: whenIcon2) {
            self.view.layer.replaceSublayer(onyx, with: bandGreen)
            self.view.layer.replaceSublayer(aluminum, with: bandRed)
            
            self.animateSquares()
            
            let rect2 = CGRect(x: x - 20, y: y + 180, width: 40, height: 40)
            dial.bounds = rect2
            dial.position.x = x
            dial.position.y = y + 180
            dial.strokeColor = UIColor.green.cgColor
            dial.path = UIBezierPath(ovalIn: dial.bounds).cgPath
            dial.lineWidth = 4.0
            dial.strokeColor = UIColor.black.cgColor
            dial.fillColor = UIColor.clear.cgColor
            dial.strokeStart = 0
            dial.strokeEnd = 0.5

            let start = CABasicAnimation(keyPath: "strokeStart")
            start.toValue = 0.7
            let end = CABasicAnimation(keyPath: "strokeEnd")
            end.toValue = 1
            
            let group = CAAnimationGroup()
            group.animations = [start, end]
            group.duration = 1.5
            group.autoreverses = true
            group.repeatCount = HUGE // repeat forver
            dial.add(group, forKey: nil)
            }}

        let when = DispatchTime.now() + 10
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.statusLabel?.text = "STARTING APPLICATION..."
            self.performSegue(withIdentifier: "ControlPanelLoad", sender: self)
        }
    }
    
    func animateSquares()
    {
        
        
        

        // create a 'tuple' (a pair or more of objects assigned to a single variable)
        let views = (frontView: self.redSquare, backView: self.greenSquare)
        
        // set a transition style
        let transitionOptions = UIViewAnimationOptions.transitionFlipFromTop
        
        if ((self.redSquare.superview) != nil) {
        UIView.transition(with: self.container, duration: 1.0, options: transitionOptions, animations: {
            // remove the front object...
            views.frontView.removeFromSuperview()
            
            // ... and add the other object
            self.container.addSubview(views.backView)
            
        }, completion: { finished in
            // any code entered here will be applied
            // .once the animation has completed
            // create a 'tuple' (a pair or more of objects assigned to a single variable)
            let views2 = (frontView: self.redSquare2, backView: self.greenSquare2)
            
            // set a transition style
            let transitionOptions2 = UIViewAnimationOptions.transitionFlipFromTop
            
            if ((self.redSquare2.superview) != nil) {
            UIView.transition(with: self.container2, duration: 1.0, options: transitionOptions2, animations: {
                // remove the front object...
                views2.frontView.removeFromSuperview()
                
                // ... and add the other object
                self.container2.addSubview(views2.backView)
                
            }, completion: { finished in
                self.animateSquares()
            })}
            else {
                UIView.transition(with: self.container2, duration: 1.0, options: transitionOptions2, animations: {
                    // remove the front object...
                    views2.frontView.removeFromSuperview()
                    
                    // ... and add the other object
                    self.container2.addSubview(views2.frontView)
                    
                }, completion: { finished in
                    self.animateSquares()
                })
            
            }
            
            
            })
            
        }
        else {
            UIView.transition(with: self.container, duration: 1.0, options: transitionOptions, animations: {
                // remove the front object...
                views.frontView.removeFromSuperview()
                
                // ... and add the other object
                self.container.addSubview(views.frontView)
                
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
                // create a 'tuple' (a pair or more of objects assigned to a single variable)
                let views2 = (frontView: self.redSquare2, backView: self.greenSquare2)
                
                // set a transition style
                let transitionOptions2 = UIViewAnimationOptions.transitionFlipFromTop
                
                if (self.redSquare2.superview) != nil {
                    UIView.transition(with: self.container2, duration: 1.0, options: transitionOptions2, animations: {
                        // remove the front object...
                        views2.frontView.removeFromSuperview()
                        
                        // ... and add the other object
                        self.container2.addSubview(views2.backView)
                        
                    }, completion: { finished in
                        self.animateSquares()
                    })}
                else {
                    UIView.transition(with: self.container2, duration: 1.0, options: transitionOptions2, animations: {
                        // remove the front object...
                        views2.frontView.removeFromSuperview()
                        
                        // ... and add the other object
                        self.container2.addSubview(views2.frontView)
                        
                    }, completion: { finished in
                        self.animateSquares()
                    })
                    
                }
                
                
            })

        }

    }
}
