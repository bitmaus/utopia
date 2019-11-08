
import UIKit
import QuartzCore

enum SlideState {
    case BothCollapsed
    case BothExpanded
    case SettingsExpanded
    case SelectionExpanded
}

class ControlViewController: UIViewController {
    
    
    var navigation: UINavigationController!
    var mainViewController: MainViewController!
    
    var selectionController: UIViewController?
    var settingsController: UIViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    var currentState: SlideState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow: shouldShowShadow)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewController = UIStoryboard.centerViewController()
        mainViewController.delegate = self

        navigation = UINavigationController(rootViewController: mainViewController)
        view.addSubview(navigation.view)
        addChildViewController(navigation)
        
        navigation.didMove(toParentViewController: self)
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let gestureIsDraggingFromBottomToTop = (recognizer.velocity(in: view).y < 0)
        
        switch(recognizer.state) {
        case .began:
            if (currentState == .BothCollapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                
                showShadowForCenterViewController(shouldShowShadow: true)
            }
        case .changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
            recognizer.setTranslation(CGPoint(x: 0,y :0), in: view)
        case .ended:
            if (settingsController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            } else if (selectionController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.y < 0
                animateTopPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
            if (gestureIsDraggingFromBottomToTop) {
                animateLogo()
            }
        default:
            break
        }
    }
}

extension ControlViewController: MainViewControllerDelegate {
    
    func toggleSelection() {
        let notAlreadyExpanded = (currentState != .SelectionExpanded)
        
        if notAlreadyExpanded {
            addTopPanelViewController()
        }
        
        animateTopPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleSettings() {
        let notAlreadyExpanded = (currentState != .SettingsExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapsePanels() {
        switch (currentState) {
        case .BothExpanded:
            toggleSettings()
            toggleSelection()
        case .SettingsExpanded:
            toggleSettings()
        case .SelectionExpanded:
            toggleSelection()
        default:
            break
        }
    }
    
    func addTopPanelViewController() {
        if (selectionController == nil) {
            selectionController = UIStoryboard.topViewController()
   
            addChildSidePanelController(sidePanelController: selectionController!)
        }
    }
    
    func addLeftPanelViewController() {
        if (settingsController == nil) {
            settingsController = UIStoryboard.leftViewController()

            addChildSidePanelController(sidePanelController: settingsController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: UIViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateTopPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .SelectionExpanded
            
            animateCenterPanelYPosition(targetPosition: navigation.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelYPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.selectionController!.view.removeFromSuperview()
                self.selectionController = nil
            }
        }
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .SettingsExpanded
            
            animateCenterPanelXPosition(targetPosition: navigation.view.frame.width - centerPanelExpandedOffset)
            navigation?.view.layer.shadowOpacity = 0.8
            mainViewController.settingsButton?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.settingsController!.view.removeFromSuperview()
                self.settingsController = nil
                
                self.navigation?.view.layer.shadowOpacity = 0.0
                self.mainViewController.settingsButton?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    func animateLogo () {
        mainViewController.resetPanels()
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.navigation.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func animateCenterPanelYPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.navigation.view.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            //navigation.view.layer.shadowOpacity = 0.8
            selectionController?.view.layer.shadowOpacity = 0.8
        } else {
            navigation.view.layer.shadowOpacity = 0.0
        }
    }
}

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func topViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SelectionController") as? UIViewController
    }
    
    class func leftViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SettingsController") as? UIViewController
    }
    
    class func centerViewController() -> MainViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "ControlController") as? MainViewController
    }
}
