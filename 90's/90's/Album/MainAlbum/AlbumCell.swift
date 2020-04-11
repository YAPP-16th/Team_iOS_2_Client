import UIKit


class AlbumCell : UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subImageViewSetting(imageView: imageView)
    }
}

