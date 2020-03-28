import Foundation
import UIKit

class AlbumDetailController : UIViewController {
    var albumIndex:Int?
    var themeIndex:Int?
    let picker = UIImagePickerController()
    
    //navigation 뒤로가기 버튼 클릭 시 홈 화면으로 이동
    
    @IBAction func goToRoot(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    //navigation + 버튼 클릭 시 사진 추가 액션시트 출력
    @IBAction func addPhoto(_ sender: Any) {
        let albumData = AlbumModel.albumList[albumIndex!]
        let currentPhotoCount = albumData.photos.count
        let restrictCount = albumData.numOfPhotos!
        
        if(restrictCount == currentPhotoCount){
            let alert = UIAlertController(title: "사진 추가 불가", message: "제한개수를 모두 채웠습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert,animated: true)
        }else {
            let actionSheet = UIAlertController(title: "사진 추가", message: "사진을 추가해주세요", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "카메라", style: .default){
                _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "testViewController") as! testViewController
                //        self.navigationController?.present(vc, animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            let albumAction = UIAlertAction(title: "앨범", style: .default){
                _ in self.openLibary()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(albumAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        albumNameLabel.text = AlbumModel.albumList[albumIndex!].albumName
        themeImageView.image = UIImage(named: AlbumModel.albumList[albumIndex!].selectTheme.themePhoto)
        settingCollectionView()
        picker.delegate = self
    }
    
    func settingCollectionView(){
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    
    
    
    
    func openCamera(){
        self.picker.sourceType = .camera
        present(picker, animated: true){
            
            
        }
        
    }
    
    func openLibary(){
        self.picker.sourceType = .photoLibrary
        present(picker, animated: true){
            
        }
        
    }
    
}

extension AlbumDetailController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 15
        let height = collectionView.frame.height / 3
        return CGSize(width: width, height: height)
    }
    
    
    
}

extension AlbumDetailController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumModel.albumList[albumIndex!].photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.photoImageView.image = AlbumModel.albumList[albumIndex!].photos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /** 다연 : 이미지 순서바꾸기 만들 시 버튼으로 변경해줘야 함 */
        let vc = storyboard?.instantiateViewController(identifier: "imageRenderVC") as! ImageRenderVC
        vc.albumIndexNumber = albumIndex!
        vc.photoIndexNumber = indexPath.row
        vc.image = AlbumModel.albumList[albumIndex!].photos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension AlbumDetailController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            AlbumModel.albumList[albumIndex!].photos.append(image)
        }
        dismiss(animated: true){
            self.photoCollectionView.reloadData()
        }
        
    }
    
    
    
}



