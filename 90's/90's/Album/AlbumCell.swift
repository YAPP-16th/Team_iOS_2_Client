import UIKit


class AlbumCell : UICollectionViewCell {
    weak var delegate : PrintDelegate!
    
    var isFull: Bool = false{
        didSet{
            if(!isFull){
                printBtn.isHidden = true
            }else {
                printBtn.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var albumImageView : UIImageView!
    @IBOutlet weak var albumNameLabel : UILabel!
    @IBOutlet weak var printBtn: UIButton!

    
    @IBAction func selectPrintBtn(_ sender: Any) {
        self.delegate.goPrintVC()
    }
    
    
    override func prepareForReuse() {
        self.printBtn.isHidden = true
    }
    
    
    
}
