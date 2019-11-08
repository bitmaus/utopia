//
//  PickerView.swift
//  HourGlass
//
//  Created by Matthew Stryker on 1/22/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

import UIKit

class PickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func switchTapped(sender: AnyObject) {
        
    }
    let pickerData = ["Simple","Wooden","Stone","Metal","Neon","Clean"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        myPicker.delegate = self
        myPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myLabel.text = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
    }
    /* less conservative memory version
     func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
     let pickerLabel = UILabel()
     let titleData = pickerData[row]
     let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
     pickerLabel.attributedText = myTitle
     //color  and center the label's background
     let hue = CGFloat(row)/CGFloat(pickerData.count)
     pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
     pickerLabel.textAlignment = .Center
     return pickerLabel
     }
     */
    
    
    /* better memory management version */
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(pickerData.count)
            //pickerLabel?.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "Wood")?.draw(in: self.view.bounds)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            //UIGraphicsEndImageContext()
            
            //self.view.backgroundColor = UIColor(patternImage: image)
            //let cell = TimerTableViewCell()
            //let timer = timers.timerBox[(indexPath as NSIndexPath).row]
            
            //cell.nameLabel.text = "temp"
            //cell.timeLabel.text = "1:1"
            //cell.nameLabel.text = timer.name
            //cell.timeLabel.text = timer.timeStamp
            //cell.onOffSwitch.isOn = timer.startStopSwitch
            //cell.progressBar.progress = Float(timer.position)
            //cell.progressBar.setProgress(timer.position, animated: true)
            
            //cell.upView = self
            //cell.selectedCell = (indexPath as NSIndexPath).row
            //let tempColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0) /* #ffcc00 */
            
            //  let gradient = CAGradientLayer()
            
            // let firstColor: UIColor = UIColor.lightGray
            //  let secondColor: UIColor = UIColor.blue
            //   let thirdColor: UIColor = UIColor.lightGray
            
            //gradient.frame = cell.bounds
            // gradient.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
            //gradient.locations = [0.0, 0.85, 1.0]
            pickerLabel?.backgroundColor = UIColor(patternImage: image)
            //cell.backgroundView = UIView()
            //cell.backgroundView?.backgroundColor = UIColor(patternImage: image)
        }
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
        
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    // for best use with multitasking , dont use a constant here.
    //this is for demonstration purposes only.
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    
    
}
