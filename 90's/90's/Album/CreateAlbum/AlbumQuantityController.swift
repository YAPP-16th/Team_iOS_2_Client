import Foundation
import UIKit

class AlbumQuantityController : UIViewController {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let quantityPicker = UIPickerView()
    
    var albumName:String!
    var albumStartDate:String!
    var albumEndDate:String!
    var albumMaxCount:Int!
    
    private var maxCountArray = Array(4...30)
    var initialFlag = true
    
    override func viewDidLoad() {
        keyboardSetting()
        setQuantityPicker()
        defaultSetting()
    }
    
    @IBAction func clickNextBtn(_ sender: Any) {
        if initialFlag == false {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "AlbumCoverVC") as! AlbumCoverVC
            
            nextVC.albumName = albumName
            nextVC.albumStartDate = albumStartDate
            nextVC.albumEndDate = albumEndDate
            nextVC.albumMaxCount = albumMaxCount
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    func defaultSetting(){
        self.selectorLabel.backgroundColor = UIColor.black
        self.nextBtn.backgroundColor = UIColor.black
        self.nextBtn.backgroundColor = UIColor.colorRGBHex(hex: 0xe33e28)
        self.nextBtn.isEnabled = true
        initialFlag = true
        tfQuantity.text = "4"
    }
    
    func setQuantityPicker(){
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        quantityPicker.backgroundColor = .white
        tfQuantity.inputView = quantityPicker
        nextBtn.layer.cornerRadius = 10
        tfQuantity.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfQuantity.endEditing(true)
    }
}



extension AlbumQuantityController : UIPickerViewDelegate {
    //pickerView에 표시될 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(maxCountArray[row])"
    }
    
    //pickerView 클릭 시 액션
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.albumMaxCount = maxCountArray[row]
        tfQuantity.text = "\(maxCountArray[row])"
    }
}


extension AlbumQuantityController : UIPickerViewDataSource {
    //몇 개씩 보여줄지 결정(pickerView 열의 개수)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxCountArray.count
    }
}


extension AlbumQuantityController {
    func keyboardSetting(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        buttonConstraint.constant = quantityPicker.frame.height + 10
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
       }

    @objc func keyboardWillHide(_ notification: Notification) {
        buttonConstraint.constant = 16
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
}
