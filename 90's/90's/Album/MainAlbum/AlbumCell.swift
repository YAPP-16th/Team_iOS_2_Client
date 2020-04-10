import UIKit


class AlbumCell : UICollectionViewCell {
    @IBOutlet weak var albumImageView : UIImageView!
    @IBOutlet weak var albumNameLabel : UILabel!
    @IBOutlet weak var printBtn: UIButton!
    
    var isFull: Bool = false{
        didSet{
            if(!isFull){
                printBtn.isHidden = true
            }else {
                printBtn.isHidden = false
            }
        }
    }
    
    override func prepareForReuse() {
        self.printBtn.isHidden = true
    }
}
