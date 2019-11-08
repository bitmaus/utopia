
import UIKit
import MediaPlayer

class TimerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var deadline: UIDatePicker!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var colorPad: UIView!
    
    @IBAction func changeTimerType(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0)
        {
            deadline.datePickerMode = UIDatePickerMode.dateAndTime
        }
        else
        {
            deadline.datePickerMode = UIDatePickerMode.countDownTimer
        }
    }

    @IBAction func saveTimer()
    {
        
    }
    
    var timer: TimerPart?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let timer = timer {
            navigationItem.title = timer.timerName
            nameTextField.text   = timer.timerName
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
    }

    //func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
      //  saveButton.isEnabled = false
    //}
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        //let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        //photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if saveButton === sender {
         //   let name = nameTextField.text ?? ""
           // let photo = photoImageView.image
            //let rating = ratingControl.rating
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            //meal = Meal(name: name, photo: photo, rating: rating)
        //}
        let name = nameTextField.text
        let timeStamp = deadline.date.timeIntervalSinceNow / 1000
        let timeColor = UIColor.red
        
        timer = TimerPart(timeType: TimerCore.Status.start, timeStamp: 0, timeSpan: 10)
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: UISlider) {
        //let temper = Int(redSlider.value)
        //let tempColor = UIColor(red: Real(temper)/255, green: Double(greenSlider.value)/Double(255), blue: Double(blueSlider.value)/Double(255), alpha: 1.0) /* #ffcc00 */
        let anotherColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
        colorPad.backgroundColor = anotherColor
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
            let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()!
            
            context.setFillColor(color.cgColor)
            context.fill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image!
        }
    
    @IBAction func moveColor() {
        
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.runMediaLibraryQuery()
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    
    func runMediaLibraryQuery() {
        let query = MPMediaQuery.songs()
        if let items = query.items, let item = items.first {
            NSLog("Title: \(item.title)")
        }
    }
    
    
    @IBAction func getMedia(_ sender: AnyObject) {
        setupPicker()
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        self.dismissMoviePlayerViewControllerAnimated()
        //self.updatePlayerQueueWithMediaCollection()
        //[self dismissModalViewControllerAnimated: YES];
        //[self updatePlayerQueueWithMediaCollection: collection];    }

    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismissMoviePlayerViewControllerAnimated()
        
        //[self dismissModalViewControllerAnimated: YES];
    }

    var picker: MPMediaPickerController!
    
    //MPMediaPickerController *picker =
    //[[MPMediaPickerController alloc]
    //initWithMediaTypes: MPMediaTypeAnyAudio];    // 1
    
    func setupPicker() {
        //picker.delegate = self
        picker.allowsPickingMultipleItems = false
        picker.prompt = "Choose song to play"
        //picker.presentMoviePlayerViewControllerAnimated(self)
        
        let query = MPMediaQuery.songs()
        if let items = query.items, let item = items.first {
            NSLog("Title: \(item.title)")
        }
        
        myPlayer.setQueue(with: query)
        myPlayer.play()
        
    }
    //[picker setDelegate: self];                                         // 2
    //[picker setAllowsPickingMultipleItems: YES];                        // 3
    //picker.prompt =
    //NSLocalizedString (@"Add songs to play",
    //"Prompt in media item picker");
    
    //[myController presentModalViewController: picker animated: YES];    // 4
    //[picker release];
    
    // instantiate a music player
    var myPlayer: MPMusicPlayerController!
    
    //MPMusicPlayerController *myPlayer =
    //[MPMusicPlayerController applicationMusicPlayer];
    
    // assign a playback queue containing all media items on the device
    //[myPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
    
    // start playing from the beginning of the queue
    //[myPlayer play];
    
    func displayMediaLibraryError() {
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var Volume: UISlider!
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    let masterVolumeSlider: MPVolumeView = MPVolumeView()
    
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
