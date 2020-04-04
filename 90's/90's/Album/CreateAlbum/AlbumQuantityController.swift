import Foundation
import UIKit

class AlbumQuantityController : UIViewController {
    var shareIndex:Bool?
    var albumIndex:Int?
    
    @IBOutlet weak var tfPeriod : UITextField!
    @IBOutlet weak var tfNumOfPhotos: UITextField!
    
    var albumName:String?
    var startDate:String?
    var expireDate:String?
    
    
    @IBAction func goToRoot(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //다음 버튼 클릭 시 앨범 설정값 저장
    @IBAction func saveSetting(_ sender: Any) {
        let period = tfPeriod.text ?? ""
        let photoNum = tfNumOfPhotos.text ?? ""
        
        if(period == "" || photoNum == ""){
            let alert = UIAlertController(title: "앨범 설정 필요", message: "기간과 사진개수를 입력해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        } else {
          //  AlbumModel.albumList[albumIndex!].period = period
            AlbumModel.albumList[albumIndex!].numOfPhotos = Int(photoNum)
            
            let albumThemeVC = storyboard?.instantiateViewController(identifier: "albumThemeVC") as! AlbumThemeController
            albumThemeVC.albumIndex = self.albumIndex!
            navigationController?.pushViewController(albumThemeVC, animated: true)
        }
        
    }
    
    
    private var periodArray = ["1Month","2Month","3Month","4Month","5Month","6Month","7Month","8Month",
                               "9Month","10Month","11Month","12Month"]
    private var numberArray = [5,10,15,20]
    
    var periodPicker = UIPickerView()
    var numberPicker = UIPickerView()
    
    override func viewDidLoad() {
        if(albumIndex == nil){
            showAlert()
        }
        
        createPeriodPicker()
        createNumberPicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfPeriod.endEditing(true)
        tfNumOfPhotos.endEditing(true)
    }
    
    
    //앨범생성 Alert
    func showAlert(){
        let alert = UIAlertController(title: "새로운 앨범", message: "이 앨범의 이름을 입력하십시오.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel){
            _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        let saveAction = UIAlertAction(title: "저장", style: .default){
            _ in
            let albumName = alert.textFields![0].text!
            self.albumIndex = AlbumModel.albumList.count
            let newAlbum = Album(index: self.albumIndex!, isShare: self.shareIndex!, albumName: albumName, photo: nil)
            AlbumModel.albumList.append(newAlbum)
        }
        
        //tf에 입력값 없는 초기 상태에서는 버튼을 막음
        saveAction.isEnabled = false
        
        //tf를 추가하고, 입력값이 들어오면 버튼이 활성화되게 함
        alert.addTextField{
            (tfAlbumName) in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAlbumName, queue: .main){
                _ in
                let textCount = tfAlbumName.text?.trimmingCharacters(in: .whitespaces).count ?? 0
                saveAction.isEnabled = textCount > 0
            }
        }
        
        //action이 왼쪽부터 추가되기 때문에 취소버튼을 먼저 추가
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func createPeriodPicker(){
        periodPicker.delegate = self
        periodPicker.dataSource = self
        tfPeriod.inputView = periodPicker
    }
    
    
    func createNumberPicker(){
        numberPicker.delegate = self
        numberPicker.dataSource = self
        tfNumOfPhotos.inputView = numberPicker
    }
    
}


extension AlbumQuantityController : UIPickerViewDelegate {
    //pickerView에 표시될 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == self.periodPicker){
            return periodArray[row]
        }else {
            return "\(numberArray[row])"
        }
    }
    
    //pickerView 클릭 시 액션
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == self.periodPicker){
            tfPeriod.text = periodArray[row]
        }else{
            tfNumOfPhotos.text = "\(numberArray[row])"
        }
    }
}

extension AlbumQuantityController : UIPickerViewDataSource {
    //몇 개씩 보여줄지 결정(pickerView 열의 개수)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.periodPicker) {
            return periodArray.count
        }else {
            return numberArray.count
        }
        
    }
    
    
}
