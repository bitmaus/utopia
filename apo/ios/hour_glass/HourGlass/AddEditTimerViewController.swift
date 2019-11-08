
import MediaPlayer
import AVFoundation

class ViewController: UIViewController,MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var Volume: UISlider!
    
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    let masterVolumeSlider: MPVolumeView = MPVolumeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection){
        
        
        myMusicPlayer = MPMusicPlayerController()
        
        if let player = myMusicPlayer{
            player.beginGeneratingPlaybackNotifications()
            
            player.setQueue(with: mediaItemCollection)
            player.play()
            self.updateNowPlayingItem()
            
            mediaPicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func displayMediaPickerAndPlayItem(){
        mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        
        if let picker = mediaPicker{
            
            print("Successfully instantiated a media picker")
            picker.delegate = self
            view.addSubview(picker.view)
            present(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
            notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            print("Persistent ID = \(id)")
        }
        
    }
    
    func volumeIsChanged(notification: NSNotification){
        print("Volume Is Changed")
    }
    
    func updateNowPlayingItem(){
        if let nowPlayingItem=self.myMusicPlayer!.nowPlayingItem{
            let nowPlayingTitle=nowPlayingItem.title
            self.nowPlayingLabel.text=nowPlayingTitle
        }else{
            self.nowPlayingLabel.text="Nothing Played"
        }
    }
    
    @IBAction func openItunesLibraryTapped(sender: AnyObject) {
        displayMediaPickerAndPlayItem()
    }
    
    @IBAction func sliderVolume(sender: AnyObject) {
        if let view = masterVolumeSlider.subviews.first as? UISlider{
            view.value = sender.value
        }
    }
}
