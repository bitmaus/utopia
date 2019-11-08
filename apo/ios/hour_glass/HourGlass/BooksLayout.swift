import UIKit

private let PageWidth: CGFloat = 362
private let PageHeight: CGFloat = 568

class BooksLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        scrollDirection = UICollectionViewScrollDirection.horizontal
        itemSize = CGSize(width: PageWidth, height: PageHeight)
        minimumInteritemSpacing = 10
    }
    
    override func prepare() {
        super.prepare()
        
        //The rate at which we scroll the collection view.
        //1
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        
        //2
        collectionView?.contentInset = UIEdgeInsets(
            top: 0,
            left: collectionView!.bounds.width / 2 - PageWidth / 2,
            bottom: 0,
            right: collectionView!.bounds.width / 2 - PageWidth / 2
        )
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [AnyObject]? {
        //1
        let array = super.layoutAttributesForElements(in: rect)! as [UICollectionViewLayoutAttributes]
        
        //2
        for attributes in array {
            //3
            let frame = attributes.frame
            //4
            let distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
            //5
            let scale = 0.7 * min(max(1 - distance / (collectionView!.bounds.width), 0.75), 1)
            //6
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // Snap cells to centre
        //1
        var newOffset = CGPoint()
        //2
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        //3
        let width = layout.itemSize.width + layout.minimumLineSpacing
        //4
        var offset = proposedContentOffset.x + collectionView!.contentInset.left
        
        //5
        if velocity.x > 0 {
            //ceil returns next biggest number
            offset = width * ceil(offset / width)
        }
        //6
        if velocity.x == 0 {
            //rounds the argument
            offset = width * round(offset / width)
        }
        //7
        if velocity.x < 0 {
            //removes decimal part of argument
            offset = width * floor(offset / width)
        }
        //8
        newOffset.x = offset - collectionView!.contentInset.left
        newOffset.y = proposedContentOffset.y //y will always be the same...
        return newOffset
    }
    
    
}
