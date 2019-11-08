
// for iTunes support

import Foundation
import UIKit
import MediaPlayer

//Let other classes know ViewController is a MPMediaPickerControllerDelegate
class MediaViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    
    @IBOutlet weak var pickedSong: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //testDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        }
    
    // keeping track of the delegate to use later
    
    
    //var tempView = UIView()
    
    var mediaItems: [MPMediaItem]?
    
    //var mediaChoice: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    
    @IBAction func pickMedia() {
            let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
            mediaPicker.delegate = self
            mediaPicker.allowsPickingMultipleItems = false
            self.present(mediaPicker, animated: true, completion: nil)

        //mediaChoice = MPMediaPickerController(mediaTypes: .music)
        //mediaChoice?.delegate = delegate
        
        //if let picker = mediaPicker{
        //delegate?.didFinishTask(self)
        //mediaChoice?.delegate = delegate
        
        //self.delegate = mediaChoice?.delegate
        print("Successfully instantiated a media picker")
        //picker.delegate = self
        //mediaChoice?.allowsPickingMultipleItems = false
        
        //self.view.addSubview((mediaChoice?.view)!)
        
        //self.bringSubview(toFront: self.tempView)
        
        //} else {
        //   print("Could not instantiate a media picker")
        // }
        
        //present(mediaChoice!, animated: true, completion: nil)
        //present(mediaPicker!, animated: true, completion: {})
        //mediaChoice?.delegate = self

        
    }
    
    //func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        
    //}
    // MPMediaPickerController Delegate methods
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("where?")
        self.dismiss(animated: true, completion: nil)
        print("you picked: \(mediaItemCollection)")//This is the picked media item.
        for mpMediaItem in mediaItemCollection.items {
            print("Add \(mpMediaItem.title) to a playlist, prep the player, etc.")
            pickedSong.text = mpMediaItem.title
            
        }
        mediaItems = mediaItemCollection.items
        //  If you allow picking multiple media, then mediaItemCollection.items will return array of picked media items(MPMediaItem)
    }
    

    
    
    @IBAction func play()
    {
        let mediaCollection = MPMediaItemCollection(items: mediaItems!)
        
        let player = MPMusicPlayerController.systemMusicPlayer()
        player.setQueue(with: mediaCollection)
        
        player.play()
    }
}
