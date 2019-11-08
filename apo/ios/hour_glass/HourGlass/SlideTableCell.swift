
import UIKit
import QuartzCore
import AVFoundation

protocol TableViewCellDelegate {
    func cellDidBeginEditing(_ editingCell: TableViewCell)
    func cellDidEndEditing(_ editingCell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    var stackTest = UIStackView()
    var blueView = UIView()
    var redView = UIView()
    var greenView = UIView()
    
    let gradientLayer = CAGradientLayer()
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, completeOnDragRelease = false
    
    var tickLabel: UILabel, crossLabel: UILabel
    let label: UILabel
    var itemCompleteLayer = CALayer()

    var delegate: TableViewCellDelegate?
    
    let player = AVQueuePlayer()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle,
                  reuseIdentifier: String?) {
        // create a label that renders the to-do item text
        //label = StrikeThroughText(frame: CGRect.null)
        label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        
        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .right
        crossLabel = createCueLabel()
        crossLabel.text = "DELETE"
        crossLabel.textAlignment = .right
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //label.contentVerticalAlignment = .center
        
        addSubview(label)
        //addSubview(tickLabel)
        addSubview(crossLabel)
        // remove the default blue highlight for selected cells
        selectionStyle = .none
        
        blueView.backgroundColor = UIColor.blue
        greenView.backgroundColor = UIColor.green
        redView.backgroundColor = UIColor.red
        
        blueView.addSubview(crossLabel)
        
        stackTest.alignment = UIStackViewAlignment.fill
        stackTest.distribution = UIStackViewDistribution.fillEqually
        stackTest.axis = UILayoutConstraintAxis.horizontal
        stackTest.backgroundColor = UIColor.yellow
        
        stackTest.addArrangedSubview(blueView)
        stackTest.addArrangedSubview(greenView)
        stackTest.addArrangedSubview(redView)
        
        addSubview(stackTest)
        
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).cgColor
        itemCompleteLayer.isHidden = true
        layer.insertSublayer(itemCompleteLayer, at: 0)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0,
                             width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                 width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
                                  width: kUICuesWidth, height: bounds.size.height)
        stackTest.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                 width: kUICuesWidth, height: bounds.size.height)
    }
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {

        if recognizer.state == .began {
            originalCenter = center
            

            
                if let url = Bundle.main.url(forResource: "stone", withExtension: "m4a") {
                    player.removeAllItems()
                    player.insert(AVPlayerItem(url: url), after: nil)
                    player.play()
                }
        }

        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            stackTest.alpha = cueAlpha
            stackTest.arrangedSubviews[0].frame = CGRect(x: -kUICuesWidth - kUICuesMargin - (0.8 * (translation.x - 10)), y: 0,
            width: (translation.x - 10), height: bounds.size.height)
            stackTest.arrangedSubviews[1].frame = CGRect(x: -kUICuesWidth - kUICuesMargin - (translation.x - 10), y: 0,
            width: (translation.x - 10), height: bounds.size.height)
            stackTest.arrangedSubviews[2].frame = CGRect(x: -kUICuesWidth - kUICuesMargin - (1.2 * (translation.x - 10)), y: 0,
            width: (translation.x - 10), height: bounds.size.height)
            
            tickLabel.textColor = completeOnDragRelease ? UIColor.green : UIColor.white
            crossLabel.textColor = deleteOnDragRelease ? UIColor.red : UIColor.white
        }

        if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                //delete timer...
            } else if completeOnDragRelease {
                //pause timer...
                itemCompleteLayer.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
