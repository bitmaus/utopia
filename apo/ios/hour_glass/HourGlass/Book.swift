import UIKit

class Book {
    
    convenience init (dict: NSDictionary) {
        self.init()
        self.dict = dict
    }
    
    var dict: NSDictionary?
    
    func coverImage () -> UIImage? {
        return UIImage(named: "gear")
    }
    
    func pageImage (_ index: Int) -> UIImage? {
        if let pages = dict?["pages"] as? NSArray {
            if let page = pages[index] as? String {
                return UIImage(named: page)
            }
        }
        return nil
    }
    
    func numberOfPages () -> Int {
        if let pages = dict?["pages"] as? NSArray {
            return pages.count
        }
        return 0
    }
    
}

class BookCoverCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var book: Book? {
        didSet {
            image = book?.coverImage()
        }
    }
    
    var image: UIImage? {
        didSet {
            let corners: UIRectCorner = .topRight// | .bottomRight
           // imageView.image = image!.imageByScalingAndCroppingForSize(bounds.size).imageWithRoundedCornersSize(20, corners: corners)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class BookStore {
    
    // private static var __once: () = {
    //     Static.instance = BookStore()
    //}()
    
    class var sharedInstance : BookStore {
        //struct Static {
        //     static var onceToken : Int = 0
        //     static var instance : BookStore? = nil
        //}
        _ = 0
        let instance = BookStore()
        //_ = BookStore.__once
        
        //return Static.instance!
        return instance
    }
    
    func loadBooks(_ plist: String) -> [Book] {
        var books: [Book] = []
        
        if let path = Bundle.main.path(forResource: plist, ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) {
                for dict in array as! [NSDictionary] {
                    let book = Book(dict: dict)
                    books += [book]
                }
            }
        }
        
        return books
    }
}

