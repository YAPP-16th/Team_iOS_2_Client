import Foundation
import UIKit

class AlbumQuantityController : UIViewController {
    
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var selectorImageVIew: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    let quantityPicker = UIPickerView()
    
    var albumName:String!
    var startDate:String!
    var expireDate:String!
    var quantity:Int!
    
    private var quantityArr = Array(1...30)
    var initialFlag = true
    
    override func viewDidLoad() {
        setQuantityPicker()
    }
    
    @IBAction func clickNextBtn(_ sender: Any) {
        let albumDetailVC = storyboard?.instantiateViewController(identifier: "albumDetailVC") as! AlbumDetailController
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
    
    
    
    
    func setQuantityPicker(){
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        tfQuantity.inputView = quantityPicker
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfQuantity.endEditing(true)
    }
}



extension AlbumQuantityController : UIPickerViewDelegate {
    //pickerView에 표시될 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(quantityArr[row])"
    }
    
    //pickerView 클릭 시 액션
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.quantity = quantityArr[row]
        tfQuantity.text = "\(quantityArr[row])"
        
        if(initialFlag){
                   self.selectorImageVIew.backgroundColor = UIColor.black
                   self.nextBtn.backgroundColor = UIColor.black
                   self.nextBtn.isEnabled = true
                   initialFlag = false
               }
    }
}


extension AlbumQuantityController : UIPickerViewDataSource {
    //몇 개씩 보여줄지 결정(pickerView 열의 개수)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return quantityArr.count
    }
    

    
}
