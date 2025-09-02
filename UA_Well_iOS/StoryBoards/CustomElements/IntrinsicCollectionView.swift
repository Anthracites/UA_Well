import UIKit

class IntrinsicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
