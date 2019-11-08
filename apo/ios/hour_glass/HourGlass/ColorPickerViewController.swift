//
//  ColorPickerViewController.swift
//  HourGlass
//
//  Created by Matthew Stryker on 6/29/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreGraphics

class ColorPickerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var labelX: UILabel?
    @IBOutlet weak var labelY: UILabel?
    @IBOutlet weak var labelColor: UILabel?
    
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var backView: UITextView?
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    var zooming: CGFloat?
    var xfactor: CGFloat?
    var yfactor: CGFloat?
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //zooming = scrollView.zoomScale
        xfactor = scrollView.contentOffset.x
        yfactor = scrollView.contentOffset.y
        
        labelX?.text = xfactor?.description
        labelY?.text = yfactor?.description
        return self.imageView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an obstacle view and add it to the scroll view for testing purposes
        let obstacleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        //obstacleView.backgroundColor = UIColor.red
        
        scrollView?.addSubview(obstacleView)
        
        // Add the obstacle view to the array
        //obstacleViews += obstacleView
    }
    //Make sure only 1x image is set
    //let image : UIImage = UIImage(named:"imageName")
    //Make sure point is within the image
    //let color : UIColor = image.getPixelColor(CGPointMake(xValue, yValue))
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            let xCoordinate : Float = Float(position.x) * (400.0/200.0)
            let yCoordinate : Float = Float(position.y) * (400.0/200.0)
            let newCoordinate : CGPoint = CGPoint(x: CGFloat(xCoordinate), y: CGFloat(yCoordinate))
            let image : UIImage = imageView!.image!// largeImage
            let color : UIColor = image.getPixelColor(pos: CGPoint(x: CGFloat(xCoordinate) + xfactor!, y: CGFloat(yCoordinate) + yfactor!))
            labelX?.text = position.x.description
            labelY?.text = position.y.description
            //labelColor?.text = color.description
            
            textView?.backgroundColor = color
        }
    }

}

//On the top of your swift
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
