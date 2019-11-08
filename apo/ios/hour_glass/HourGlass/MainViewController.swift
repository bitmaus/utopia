import Foundation
import UIKit

@objc
protocol MainViewControllerDelegate {
    @objc optional func toggleSelection()
    @objc optional func toggleSettings()
    @objc optional func collapsePanels()
}

class MainViewController: UITableViewController {

    var delegate: MainViewControllerDelegate?
    
    var navigation: UINavigationController!
    var viewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gridView.backgroundColor = .clear
        //gridView.layer.cornerRadius = 5
        //gridView.layer.borderWidth = 2
        //gridView.layer.borderColor = UIColor.gray.cgColor
        
        let stats = Statistics()
        
        //statsLabelTotalTime.text = TimeView.convertTime(appConstants.userTimers)
        
    }
    
    @IBOutlet weak var navControl: UINavigationController!
    
    @IBOutlet weak var settingsButton: UIButton?
    
    @IBOutlet weak var gridView: UIButton!
    @IBOutlet weak var listView: UIButton!
    @IBOutlet weak var timeView: UIButton!
    
    @IBOutlet weak var statsLabelTotalTime: UILabel!
    @IBOutlet weak var statsLabelPriority: UILabel!
    @IBOutlet weak var statsLabelActiveTimer: UILabel!
    @IBOutlet weak var statsLabelEvents: UILabel!
    
    @IBAction func selectionTapped(sender: AnyObject) {
        delegate?.toggleSelection?()
    }
    
    @IBAction func settingsTapped(sender: AnyObject) {
        delegate?.toggleSettings?()
    }
    
    func handlePanGesture(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        animateStatsPanelXPosition(targetPosition:translation.y)
    }
    
    @IBAction func openControlPanel(){
        //let storyboard = UIStoryboard(name: "ControlPanel", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ControlPanelStart") as UIViewController
        //vc.transitioningDelegate = self.transitions
        //self.transitioningDelegate = self.transitions
        self.performSegue(withIdentifier: "testSegue", sender: self)
        
        //self.present((self.navigationController?.visibleViewController)!, animated: true, completion: nil)
        //self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func unloadNow (sender: UIStoryboardSegue){
        //self.transitioningDelegate = self.transitions
        //sender.destination.transitioningDelegate = self.transitions
        //let storyboard = UIStoryboard(name: "ControlPanel", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ControlPanelStart") as UIViewController
        //self.present(sender.destination, animated: true, completion: nil)
    }

    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        if sender.identifier == "idFirstSegueUnwind" {
            let originalColor = self.view.backgroundColor
            self.view.backgroundColor = UIColor.red
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.view.backgroundColor = originalColor
            })
        }
    }

    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "idFirstSegueUnwind" {
                let unwindSegue = CustomUnwindSegue(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }
    
    func showFirstViewController() {
        self.performSegue(withIdentifier: "idFirstSegueUnwind", sender: self)
    }

    func animateStatsPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.navigation.view.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    public func resetPanels() {
        
    }
}
