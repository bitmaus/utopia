
import Foundation

//NSString *path = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"txt"];
//NSString *userAgreement = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

import QuartzCore
import UIKit


class BookShelfController: UICollectionViewController
{
    var _bookViewOrignCenter = CGPoint()
    var _modalTransitionStyle: UIModalTransitionStyle!
    
    enum UIModalTransitionStyleCustom {
        case UIModalTransitionStyleOpenBooks// = 0x01 << 7
    
    }

    @IBOutlet weak var _bookView: UIView!
    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var content: UIView!
    
    var pageTurn = PageTurnViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        books = BookStore.sharedInstance.loadBooks("Books")
        
        recognizer = UIPinchGestureRecognizer(target: self, action: #selector(BookShelfController.handlePinch(_:)))
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil)
    {
    _modalTransitionStyle = viewControllerToPresent.modalTransitionStyle
    //if (_modalTransitionStyle == UIModalTransitionStyleCustom.UIModalTransitionStyleOpenBooks) {
        
        //_bookView.
        //content = viewControllerToPresent.view
        
        var scaleX = CGFloat()
        var scaleY = CGFloat()
        scaleX = self.view.bounds.size.width / _bookView.bounds.size.width
        scaleY = self.view.bounds.size.height / _bookView.bounds.size.height
        content.isHidden = false
        _bookView.insertSubview(content, aboveSubview: cover)
        //[_bookView insertSubview:_bookView.content aboveSubview:_bookView.cover]
        
        content.transform = CGAffineTransform(scaleX: 1/scaleX, y: 1/scaleY)
        
        content.frame = CGRect(x: 0, y: 0, width: _bookView.frame.width, height: _bookView.frame.height)
        //CGRectMake(0, 0,CGRectGetWidth(_bookView.frame), CGRectGetHeight(_bookView.frame))
        
        var transformblank = CATransform3D()
        transformblank = CATransform3DMakeRotation(CGFloat(-M_PI_2) / 1.01, 0.0, 1.0, 0.0)
        transformblank.m34 = 1.0 / 250.0
        
        //_bookView.
        cover.layer.anchorPoint = CGPoint(x:0, y:0.5)
        cover.center = CGPoint(x:0.0, y:cover.bounds.size.height/2.0)//compensate for anchor offset
        
        cover.isOpaque = true
        
        _bookViewOrignCenter = _bookView.center
        
        var duringTime = CGFloat()
        duringTime = 1.0
        
        if (!flag) {
            duringTime = 0.0
        }
        
        UIView.animate(withDuration: TimeInterval(duringTime), delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.showHideTransitionViews], animations: {
            
            self._bookView.transform = CGAffineTransform(scaleX: scaleX,y: scaleY)
            self._bookView.center = self.view.center
            
            self.cover.layer.transform = transformblank
            self._bookView.bringSubview(toFront: self.cover)
            //[_bookView bringSubviewToFront:_bookView.cover]
            
        }, completion:{(value: Bool)  in
            if (value) {
                
                self.cover.layer.isHidden = true
                
                if (completion != nil) {
                    //completion()
                }
            }
            
        })
        
        //UIView.animateWithDuration:duringTime delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionShowHideTransitionViews animations:^{
            
          //  _bookView.transform = CGAffineTransform(scaleX: scaleX,y: scaleY)
           // _bookView.center = self.view.center
            
            //cover.layer.transform = transformblank
            
            //[_bookView bringSubviewToFront:_bookView.cover]
            
            //} completion:^(BOOL finished) {
            //if (finished) {
            
            //cover.layer.hidden = YES
            
          //  if (completion != nil) {
           // completion()
            //}
           // }
            
            //} ]
    //}
    //else
    //{
       // super.present(viewControllerToPresent, animated: flag, completion: ((Bool) -> finished))
        //[super presentViewController:viewControllerToPresent animated:flag completion:completion]
    //}
    }
    
    @IBAction func showBook() {
    //content = viewControllerToPresent.view
        content = pageTurn.view
    
    var scaleX = CGFloat()
    var scaleY = CGFloat()
    scaleX = self.view.bounds.size.width / _bookView.bounds.size.width
    scaleY = self.view.bounds.size.height / _bookView.bounds.size.height
    content.layer.isHidden = false
    _bookView.insertSubview(content, aboveSubview: cover)
    //[_bookView insertSubview:_bookView.content aboveSubview:_bookView.cover]
    
    content.transform = CGAffineTransform(scaleX: 1/scaleX, y: 1/scaleY)
    
    content.frame = CGRect(x: 0, y: 0, width: _bookView.frame.width, height: _bookView.frame.height)
    //CGRectMake(0, 0,CGRectGetWidth(_bookView.frame), CGRectGetHeight(_bookView.frame))
    
    var transformblank = CATransform3D()
    transformblank = CATransform3DMakeRotation(CGFloat(-M_PI_2) / 1.01, 0.0, 1.0, 0.0)
    transformblank.m34 = 1.0 / 250.0
    
    //_bookView.
    cover.layer.anchorPoint = CGPoint(x:0, y:0.5)
    cover.center = CGPoint(x:0.0, y:cover.bounds.size.height/2.0)//compensate for anchor offset
    
    cover.isOpaque = true
    
    _bookViewOrignCenter = _bookView.center
    
    var duringTime = CGFloat()
    duringTime = 1.0
    
    //if (!flag) {
    //duringTime = 0.0
    //}
    
    UIView.animate(withDuration: TimeInterval(duringTime), delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.showHideTransitionViews], animations: {
    
    self._bookView.transform = CGAffineTransform(scaleX: scaleX,y: scaleY)
    self._bookView.center = self.view.center
    
    self.cover.layer.transform = transformblank
    self._bookView.bringSubview(toFront: self.cover)
    //[_bookView bringSubviewToFront:_bookView.cover]
    
    }, completion:{(value: Bool)  in
    if (value) {
    
    self.cover.layer.isHidden = true
    
    
    //if (completion != nil) {
    //completion()
    //}
    }
    
    })
    
    //UIView.animateWithDuration:duringTime delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionShowHideTransitionViews animations:^{
    
    //  _bookView.transform = CGAffineTransform(scaleX: scaleX,y: scaleY)
    // _bookView.center = self.view.center
    
    //cover.layer.transform = transformblank
    
    //[_bookView bringSubviewToFront:_bookView.cover]
    
    //} completion:^(BOOL finished) {
    //if (finished) {
    
    //cover.layer.hidden = YES
    
    //  if (completion != nil) {
    // completion()
    //}
    // }
    
    //} ]
    //}
    //else
    //{
    // super.present(viewControllerToPresent, animated: flag, completion: ((Bool) -> finished))
    //[super presentViewController:viewControllerToPresent animated:flag completion:completion]
    //}
}
    @IBAction func dismissBook()
    {
        //if (_modalTransitionStyle == UIModalTransitionStyleOpenBooks) {
        
        
        cover.layer.isHidden = false
        
        var duringTime = CGFloat()
        duringTime = 1.0
        
        //if (!flag) {
          //  duringTime = 0.0
        //}
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState,  UIViewAnimationOptions.showHideTransitionViews], animations: {
            
            self._bookView.center = self._bookViewOrignCenter
            self._bookView.transform = CGAffineTransform.identity
            self.cover.layer.transform = CATransform3DIdentity
            
        }, completion:{(value: Bool)  in
            //(Bool) in {
            //(value: Bool) in
            //self.blurBg.hidden = true
            //})
            if (value) {
                
                //self.content.removeFromSuperview()
                self.content.layer.isHidden = true
                //[_bookView.content removeFromSuperview];
                
                //if (completion != nil) {
                    
                    //completion()
                //}
            }
            
        })
        
        //[UIView animateWithDuration:duringTime delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        //  _bookView.center = _bookViewOrignCenter;
        // _bookView.transform = CGAffineTransformIdentity;
        // _bookView.cover.layer.transform = CATransform3DIdentity;
        
        //} completion:^(BOOL finished) {
        
        //if (finished) {
        
        //[_bookView.content removeFromSuperview];
        
        //if (completion != nil) {
        
        //completion();
        // }
        //}
        
        //} ];
        // }
        //else
        // {
        //   super.dismiss(animated: flag, completion: completion)
        //  [super dismissViewControllerAnimated:flag completion:completion];
        //}
    }


    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil)
{
    //if (_modalTransitionStyle == UIModalTransitionStyleOpenBooks) {
    
    
        cover.layer.isHidden = false
    
        var duringTime = CGFloat()
        duringTime = 1.0
    
        if (!flag) {
            duringTime = 0.0
        }


        UIView.animate(withDuration: 1.0, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState,  UIViewAnimationOptions.showHideTransitionViews], animations: {
            
            self._bookView.center = self._bookViewOrignCenter
            self._bookView.transform = CGAffineTransform.identity
            self.cover.layer.transform = CATransform3DIdentity
            
        }, completion:{(value: Bool)  in
            //(Bool) in {
            //(value: Bool) in
            //self.blurBg.hidden = true
        //})
            if (value) {
                
                self.content.removeFromSuperview()
                //[_bookView.content removeFromSuperview];
                
                if (completion != nil) {
                    
                    //completion()
                }
            }
            
    })
    
        //[UIView animateWithDuration:duringTime delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionShowHideTransitionViews animations:^{
            
          //  _bookView.center = _bookViewOrignCenter;
           // _bookView.transform = CGAffineTransformIdentity;
           // _bookView.cover.layer.transform = CATransform3DIdentity;
            
            //} completion:^(BOOL finished) {
            
            //if (finished) {
            
            //[_bookView.content removeFromSuperview];
            
            //if (completion != nil) {
            
            //completion();
           // }
            //}
            
            //} ];
   // }
    //else
   // {
     //   super.dismiss(animated: flag, completion: completion)
      //  [super dismissViewControllerAnimated:flag completion:completion];
    //}
}
    


    //var transition: BookOpeningTransition?
    
    //1
    var interactionController: UIPercentDrivenInteractiveTransition?
    //2
    var recognizer: UIGestureRecognizer? {
        didSet {
            if let recognizer = recognizer {
                collectionView?.addGestureRecognizer(recognizer)
            }
        }
    }
    
    var books: Array<Book>? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK: Gesture recognizer action
    func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            //1
            interactionController = UIPercentDrivenInteractiveTransition()
            //2
            if recognizer.scale >= 1 {
                //3
                if recognizer.view == collectionView {
                    //4
                    let book = self.selectedCell()?.book
                    //5
                    self.openBook(book)
                }
                //6
            } else {
                //7
                navigationController?.popViewController(animated: true)
            }
        case .changed:
            //1
            //if transition.isPush {
                //2
            //    let progress = min(max(abs((recognizer.scale - 1)) / 5, 0), 1)
                //3
                //interactionController?.update(progress)
                //4
         //   } else {
                //5
                let progress = min(max(abs((1 - recognizer.scale)), 0), 1)
                //6
                interactionController?.update(progress)
         //   }
        case .ended:
            //1
            interactionController?.finish()
            //2
            interactionController = nil
        default:
            break
        }
    }
    
    // MARK: Helpers
    
    func selectedCell() -> BookCoverCell? {
        if let indexPath = collectionView?.indexPathForItem(at: CGPoint(x: collectionView!.contentOffset.x + collectionView!.bounds.width / 2, y: collectionView!.bounds.height / 2)) {
            if let cell = collectionView?.cellForItem(at: indexPath) as? BookCoverCell {
                return cell
            }
        }
        return nil
    }
    
    func openBook(_ book: Book?) {
        
    }
}

// MARK: UICollectionViewDelegate

extension BookShelfController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books?[(indexPath as NSIndexPath).row]
        openBook(book)
    }
    
}

// MARK: UICollectionViewDataSource

extension BookShelfController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let books = books {
            return books.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "BookCoverCell", for: indexPath) as! BookCoverCell
        
        cell.book = books?[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
}

