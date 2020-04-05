

import UIKit

protocol PrintDelegate : NSObjectProtocol {
    func goPrintVC()
}



class AlbumMainController: UIViewController {
    
    //앨범 만들기 버튼
    @IBOutlet weak var albumMakeBtn:UIButton!
    
    //앨범 없을 시 멘트 라벨
    @IBOutlet weak var albumIntroLabel: UILabel!
    
    //앨범 목록을 보여줄 CollectionView
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         
         //앨범이 있냐 없냐에 따라
         if(AlbumModel.albumList.count == 0){
             albumCollectionView.isHidden = true
         }else {
             albumMakeBtn.isHidden = true
             albumIntroLabel.isHidden = true
         }
         
         
         settingCollectionView()
        // settingActionSheet()
     }
     
    
     override func viewWillAppear(_ animated: Bool) {
         albumCollectionView.reloadData()
     }
     
    
    
    //앨범 만들기 버튼 클릭 시 앨범이름설정VC로 이동
    @IBAction func clickMakeBtn(_ sender: Any){
        let albumNameVC = storyboard?.instantiateViewController(withIdentifier : "AlbumNameController") as! AlbumNameController
        
        self.navigationController?.pushViewController(albumNameVC, animated: true)
    }
        
    
    func settingCollectionView(){
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.reloadData()
    }
    
//    func settingActionSheet(){
//        //옵션 메뉴 설정
//        let newAlbum = UIAlertAction(title: "새로운 앨범", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            let albumSettingVC = self.storyboard?.instantiateViewController(identifier: "albumSettingVC") as! AlbumSettingController
//            albumSettingVC.shareIndex = false
//            self.navigationController?.pushViewController(albumSettingVC, animated: true)
//        })
//
//        let newShareAlbum = UIAlertAction(title: "새로운 공유 앨범", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            let albumSettingVC = self.storyboard?.instantiateViewController(identifier: "albumSettingVC") as! AlbumSettingController
//            albumSettingVC.shareIndex = true
//            self.navigationController?.pushViewController(albumSettingVC, animated: true)
//        })
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//
//
//        //action sheet에 옵션 추가
////        optionMenu.addAction(newAlbum)
////        optionMenu.addAction(newShareAlbum)
////        optionMenu.addAction(cancel)
//    }
    
}


extension AlbumMainController : UICollectionViewDelegateFlowLayout {
    
    //item의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2) - 15
        let height = self.view.frame.height / 4.5
        return CGSize(width: width, height: height)
    }
    
    //cell 클릭시 엑션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let data = AlbumModel.albumList[indexPath.row]
        
        //cell 클릭 시 넘어갈 화면 분기
        //앨범 설정값이 nil -> AlbumSettingVC
        //앨범 설정값이 있고 테마값이 nil -> AlbumThemeVC
        //다 있으면 -> AlbumDetailVC
        
//        if(data.period == nil){
//            let albumSettingVC = storyboard?.instantiateViewController(identifier: "albumSettingVC") as! AlbumSettingController
//            albumSettingVC.albumIndex = index
//            navigationController?.pushViewController(albumSettingVC, animated: true)
//        }else if(data.selectTheme == nil){
//            let albumThemeVC = storyboard?.instantiateViewController(identifier: "albumThemeVC") as! AlbumThemeController
//            albumThemeVC.albumIndex = index
//            navigationController?.pushViewController(albumThemeVC, animated: true)
//        }else {
//            let albumDetailVC = storyboard?.instantiateViewController(identifier: "albumDetailVC") as! AlbumDetailController
//            albumDetailVC.albumIndex = index
//            navigationController?.pushViewController(albumDetailVC, animated: true)
//        }
        
        
    }
    
    
}

extension AlbumMainController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumModel.albumList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let data = AlbumModel.albumList[indexPath.row]
        if let photoNum = data.quantity {
            if(photoNum == data.photos.count){
                cell.isFull = true
            }
        }else {
            cell.isFull = false
        }
        
        cell.albumImageView.image =  data.photos.first ?? UIImage()
        cell.albumNameLabel.text = data.albumName
        cell.delegate = self
    
        return cell
    }
    
    
}

extension AlbumMainController : PrintDelegate {
    func goPrintVC(){
        //
    }
    
}
