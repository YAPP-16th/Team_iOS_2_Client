//
//  photoStickerCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumDetailController : UIViewController {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    // Top View 설정
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBAction func backBtn(_ sender: UIButton) { self.navigationController?.popToRootViewController(animated: true) }
    // 사진 추가 버튼을 눌렀을 때
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideWhiteView: UIView!
    @IBOutlet weak var hidewhiteviewBottom: NSLayoutConstraint!
    @IBOutlet weak var hideAddAlbumBtn: UIButton!
    @IBOutlet weak var hideAddPhotoBtn: UIButton!
    @IBAction func cancleHideView(_ sender: UIButton) { switchHideView(value: true) }
    
    // 사진 확대 시
    @IBOutlet weak var hideImageZoom: UIImageView!
    
    @IBAction func touchhideShareCompleteBtn(_ sender: UIButton) { inviteSetting() }
    
    // old filter
    private let context = CIContext(options: nil)
    
    // 사진 순서 이동
    private var longPressGesture : UILongPressGestureRecognizer!
    var isArrangeEnded : Bool = true
    var isAlbumComplete : Bool = false
    
    var currentCell : UICollectionViewCell? = nil // 스티커, 필터 전환
    var isSharingAlbum : Bool = false // 공유앨범
    var galleryPicker : UIImagePickerController = {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    var ImageName : String = ""
    var selectedLayout : AlbumLayout?
    var albumMaxCount : Int = 0
    var albumOldCount : Int = 0
    // - received data from before vc
    var albumUid : Int = 0
    var sharingword : String?
    // - network array
    var photoUidArray = [PhotoGetPhotoData]()
    var networkDetailAlbum : album?
    var networkPhotoUidArray : [Int] = []
    var networkPhotoUrlImageArray : [UIImage] = []
    var networkHeaderName : String = "Title"
    var networkHedaerCount : Int = 0

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hideView.isHidden == false {
            let touch = touches.first
            if touch?.view != self.hideWhiteView {
                switchHideView(value: true)
            }
            if hideImageZoom.isHidden == false {
                if touch?.view != self.hideImageZoom {
                    switchZoomView(value: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        NetworkSetting()
        photoCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
        defaultSetting()
        buttonSetting()
    }
}


extension AlbumDetailController {
    func delegateSetting(){
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.dragInteractionEnabled = true
        galleryPicker.delegate = self
    }
    
    func defaultSetting(){
        hideView.isHidden = true
        hideWhiteView.layer.cornerRadius = 15
        // 순서 바꾸기
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        photoCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func buttonSetting(){
        inviteBtn.addTarget(self, action: #selector(touchInivteBtn), for: .touchUpInside)
        addPhotoBtn.addTarget(self, action: #selector(touchAddPhotoBtn), for: .touchUpInside)
        hideAddAlbumBtn.addTarget(self, action: #selector(touchAlbumBtn), for: .touchUpInside)
        hideAddPhotoBtn.addTarget(self, action: #selector(touchCameraBtn), for: .touchUpInside)
    }
}


extension AlbumDetailController {
    func switchHideView(value : Bool){
        switch value {
        case true:
            self.hidewhiteviewBottom.constant = -self.hideWhiteView.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finish in
                self.hideView.isHidden = true
            } )
        case false:
            self.hidewhiteviewBottom.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            self.hideView.isHidden = false
        }
    }
    
    // 사진 하나 선택 시
    func switchZoomView(value : Bool){
        switch value {
        case true :
            self.hideView.isHidden = true
            self.hideImageZoom.isHidden = true
            self.hideImageZoom.transform = CGAffineTransform(scaleX: 100/115, y: 100/115)
        case false :
            self.hideView.isHidden = false
            self.hideImageZoom.isHidden = false
            UIView.animate(withDuration: 1.0){
                self.hideImageZoom.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }
        }
    }

    // 완료된 앨범일 경우
    func switchAlbumComplete(value : Bool){
        switch value {
        case false :
            addPhotoBtn.isEnabled = true
            addPhotoBtn.isHidden = false
            inviteBtn.isEnabled = true
            inviteBtn.isHidden = false
        case true:
            addPhotoBtn.isEnabled = false
            addPhotoBtn.isHidden = true
            inviteBtn.isEnabled = false
            inviteBtn.isHidden = true
            networkAddCount()
        }
    }
}

extension AlbumDetailController {
    func setZoomImageView(layout : AlbumLayout) -> CGSize {
        switch layout {
        case .Polaroid : return AlbumLayout.Polaroid.deviceHighSize
        case .Mini : return AlbumLayout.Mini.deviceHighSize
        case .Memory : return AlbumLayout.Memory.deviceHighSize
        case .Portrab : return AlbumLayout.Portrab.deviceHighSize
        case .Portraw : return AlbumLayout.Portraw.deviceHighSize
        case .Tape : return AlbumLayout.Tape.deviceHighSize
        case .Filmroll : return AlbumLayout.Filmroll.deviceHighSize
        }
    }
    
    func inviteSetting(){
        let templeteId = "24532"
           
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templeteId, templateArgs: nil, success: {(warningMsg, argumentMsg) in
               print("warning message : \(String(describing: warningMsg))")
               print("argument message : \(String(describing: argumentMsg))")
           }, failure: {(error) in
               print("error \(error)")
           })
       }
    
    func setOldFilter(image : UIImage) -> UIImage{
        let inputImage : CIImage = CIImage.init(image: image)!
        let context = CIContext()
        
        // apply sepia tone filter to original image
        guard let sepiaFilter = CIFilter(name:"CISepiaTone", parameters:
            [
                  kCIInputImageKey: inputImage,
                  kCIInputIntensityKey: 0.3
            ]) else { return image }
        guard let sepiaCIImage = sepiaFilter.outputImage else { return image }
        
        // simulate grain by creating randomly varing speckle
        guard
            let coloredNoise = CIFilter(name:"CIRandomGenerator"),
            let noiseImage = coloredNoise.outputImage
            else { return image }
        
        // apply whitening effect noise output to CICOlorMatrix filter
        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        let fineGrain = CIVector(x:0, y:0.005, z:0, w:0)
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        
        guard let whiteningFilter = CIFilter(name:"CIColorMatrix", parameters:
            [
                kCIInputImageKey: noiseImage,
                "inputRVector": whitenVector,
                "inputGVector": whitenVector,
                "inputBVector": whitenVector,
                "inputAVector": fineGrain,
                "inputBiasVector": zeroVector
            ]),
            let whiteSpecks = whiteningFilter.outputImage
            else { return image }
        
        // create white specks
        guard let speckCompositor = CIFilter(name:"CISourceOverCompositing", parameters:
        [
            kCIInputImageKey: whiteSpecks,
            kCIInputBackgroundImageKey: sepiaCIImage
        ]),
        let speckledImage = speckCompositor.outputImage
        else { return image }
        
        // simulate scratch by scaling randomly varying noise
        let verticalScale = CGAffineTransform(scaleX: 1.5, y: 25)
        let transformedNoise = noiseImage.transformed(by: verticalScale)
        
        let darkenVector = CIVector(x: 4, y: 0, z: 0, w: 0)
        let darkenBias = CIVector(x: 0, y: 1, z: 1, w: 1)
                
        guard let darkeningFilter = CIFilter(name:"CIColorMatrix", parameters:
            [
                kCIInputImageKey: transformedNoise,
                "inputRVector": darkenVector,
                "inputGVector": zeroVector,
                "inputBVector": zeroVector,
                "inputAVector": zeroVector,
                "inputBiasVector": darkenBias
            ]),
            let randomScratches = darkeningFilter.outputImage
            else { return image }
        
        
        guard let grayscaleFilter = CIFilter(name:"CIMinimumComponent", parameters:
            [
                kCIInputImageKey: randomScratches
            ]),
            let darkScratches = grayscaleFilter.outputImage
            else { return image }
        
        // composite specks and scratches to the sepia image
        guard let oldFilmCompositor = CIFilter(name:"CIMultiplyCompositing", parameters:
            [
                kCIInputImageKey: darkScratches,
                kCIInputBackgroundImageKey: speckledImage
            ]),
            let oldFilmImage = oldFilmCompositor.outputImage
            else { return image }
        
        let finalImage = oldFilmImage.cropped(to: inputImage.extent)
        
        // imageView - image filter
        return UIImage(cgImage: context.createCGImage(finalImage, from: finalImage.extent)!)
    }
}

/* 네트워크 함수 */
extension AlbumDetailController {
    func NetworkSetting(){
        self.networkPhotoUrlImageArray = []
        
        // 1. 앨범 정보 가져오기
        AlbumService.shared.albumGetAlbum(uid: albumUid, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode(album.self, from: data) else {return}
                    self.networkDetailAlbum = value
                    self.networkHeaderName = value.name
                    self.albumMaxCount = value.photoLimit
                    self.isAlbumComplete = value.complete
                    self.selectedLayout = self.getLayoutByUid(value: value.layoutUid)
                    self.hideImageZoom.frame.size = CGSize(width: self.setZoomImageView(layout: self.selectedLayout!).width - 60, height: self.setZoomImageView(layout: self.selectedLayout!).height - 60)
                    self.albumOldCount = value.count
                    self.hideImageZoom.center = self.view.center
                    self.NetworkGetPhotoUid()
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumDetailVC - getAlbum")
                default:
                    return
                }
            }
        })
    }
    
    func NetworkGetPhotoUid(){
        // 2. 앨범에서 사진 uid 가져오기
        AlbumService.shared.photoGetPhoto(albumUid: albumUid, completion: { response in
            if let status = response.response?.statusCode {
            switch status {
            case 200:
                guard let data = response.data else {return}
                guard let value = try? JSONDecoder().decode([PhotoGetPhotoData].self, from: data) else {return}
                self.photoUidArray = value
                self.networkHedaerCount = self.photoUidArray.count
                self.networkPhotoUidArray = self.photoUidArray.map{ $0.photoUid }
                self.NetworkGetPhoto(photoUid: self.networkPhotoUidArray)
                self.photoCollectionView.reloadData()
            case 401:
                print("\(status) : bad request, no warning in Server")
            case 404:
                print("\(status) : Not found, no address")
            case 500 :
                print("\(status) : Server error in AlbumDetailVC - getPhoto")
            default:
                return
                }
            }
        })
    }
    
    // 3. 서버에 앨범 uid와 사진uid 요청
    func NetworkGetPhoto(photoUid : [Int]){
        if photoUid.count - 1 >= 0 {
            for i in 0...photoUid.count-1 {
                AlbumService.shared.photoDownload(albumUid: albumUid, photoUid: photoUid[i], completion: { response in
                    if case .success(let image) = response.result {
                        var originImage = image
                        if self.isAlbumComplete == true {
                            if self.albumOldCount > 10 {
                                self.albumOldCount = 10
                            }
                            for _ in 0...self.albumOldCount { 
                                originImage = self.setOldFilter(image: originImage)
                            }
                        }
                        self.networkPhotoUrlImageArray.append(originImage)
                        self.photoCollectionView.reloadData()
                    }
                })
            }
        }

        isAlbumComplete = photoUidArray.count+1 <= albumMaxCount ? false : true
        switchAlbumComplete(value: isAlbumComplete)
    }
    
    // 앨범 완성 후 - 앨범 낡기 적용
    func networkAddCount(){
        AlbumService.shared.albumPlusCount(uid: albumUid, completion: {response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    print("album add order plus count successfully added")
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumDetailVC - addPlusCount")
                default:
                    return
                }
            }
        })
    }
}


extension AlbumDetailController {
    @objc func touchCameraBtn(){
        print(AlbumDetailController.deviceModelName())
//        "iPhone6s" "iPhone6" "iPhone5s" "iPhone5c" "iPhone5" "iPhone4s" "iPhone4"
        if AlbumDetailController.deviceModelName() == "iPhone6s Plus" || AlbumDetailController.deviceModelName() == "iPhone6s" || AlbumDetailController.deviceModelName() == "iPhone6" || AlbumDetailController.deviceModelName() == "iPhone5s" || AlbumDetailController.deviceModelName() == "iPhone5c" || AlbumDetailController.deviceModelName() == "iPhone5" || AlbumDetailController.deviceModelName() == "iPhone4s" || AlbumDetailController.deviceModelName() == "iPhone4" {
            let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
            let goNextVC = storyBoard.instantiateViewController(withIdentifier: "NonFilterViewController") as! NonFilterViewController
            goNextVC.modalPresentationStyle = .fullScreen
            self.present(goNextVC, animated: true)
        }
        else {
        let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
        let goNextVC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        goNextVC.modalPresentationStyle = .fullScreen
        self.present(goNextVC, animated: true)
        }
        
    }
    
    @objc func touchAlbumBtn(){
        present(galleryPicker, animated: true){
            self.switchHideView(value: true)
        }
    }
    
    @objc func touchInivteBtn(){
        inviteSetting()
    }
    
    @objc func touchAddPhotoBtn() {
        switchHideView(value: isAlbumComplete)
    }
    
    @objc func handleLongGesture(gesture : UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = photoCollectionView.indexPathForItem(at: gesture.location(in: photoCollectionView)) else { break }
            isArrangeEnded = false
            currentCell = photoCollectionView.cellForItem(at: selectedIndexPath)
            photoCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            photoCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            isArrangeEnded = true
            photoCollectionView.performBatchUpdates({
                self.photoCollectionView.endInteractiveMovement()
            }, completion: { (result) in
                self.currentCell = nil
            })
        default:
            isArrangeEnded = true
            photoCollectionView.cancelInteractiveMovement()
        }
    }
}


extension AlbumDetailController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkPhotoUrlImageArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "albumdetailheadercell", for: indexPath) as! DetailAbumCell
        header.albumTitle.text = networkHeaderName
        header.albumCount.text = "\(networkHedaerCount) 개의 추억이 쌓였습니다"
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentCell != nil && isArrangeEnded {
            return currentCell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
            let size = returnLayoutPreviewSize(selectedLayout: selectedLayout!)
            
            cell.backImageView = applyBackImageViewLayout(selectedLayout: selectedLayout!, smallBig: size, imageView: cell.backImageView)
            cell.backImageView.image = networkPhotoUrlImageArray[indexPath.row]
    
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return returnLayoutPreviewSize(selectedLayout: selectedLayout!)
        //return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedItem = AlbumDatabase.arrayList[albumIndex!].photos[sourceIndexPath.row]
//        AlbumDatabase.arrayList[albumIndex!].photos.remove(at: sourceIndexPath.row)
//        AlbumDatabase.arrayList[albumIndex!].photos.insert(movedItem, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        hideImageZoom.image = cell.backImageView.image
        switchZoomView(value: false)
    }
}

// 순서 바꾸기
extension AlbumDetailController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        coordinator.session.loadObjects(ofClass: (UIImage.self), completion: { (images) in
            for _ in images {
//                AlbumDatabase.arrayList[self.albumIndex!].photos.insert(photo as! UIImage, at: destinationIndexPath.item)
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: [destinationIndexPath])
                })
            }
        })
    }
}


extension AlbumDetailController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.photoCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var tempImage : UIImage? = nil
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {return}
        ImageName = fileUrl.lastPathComponent
        
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(url, forKey: "assetURL")
            tempImage = image
        }
        
        dismiss(animated: true){
            let storyboard = UIStoryboard(name: "Sticker", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "imageRenderVC") as! ImageRenderVC
            vc.modalPresentationStyle = .fullScreen
            vc.image = tempImage
            vc.selectLayout = self.selectedLayout
            vc.albumUid = self.albumUid
            vc.imageName = self.ImageName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension AlbumDetailController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToInfoVC" {
            let dest = segue.destination as! AlbumInfoVC
            dest.albumUid = albumUid
            dest.infoAlbum = networkDetailAlbum
        }
    }
}

extension AlbumDetailController {
    

    
///Identifier 찾기
    static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    /**
     디바이스 모델 (iPhone, iPad) 이름 전달 (iPhone6, iPhone7 Plus...)
     */
    static func deviceModelName() -> String {
        
        let model = UIDevice.current.model
        
        switch model {
        case "iPhone":
            return self.iPhoneModel()
            
        default:
            return "Unknown Model : \(model)"
        }
        
    }
    
    /**
     iPhone 모델 이름 (iPhone6, iPhone7 Plus...)
     */
    static func iPhoneModel() -> String {
        
        let identifier = self.getDeviceIdentifier()
        
        switch identifier {
        case "iPhone1,1" :
            return "iPhone"
        case "iPhone1,2" :
            return "iPhone3G"
        case "iPhone2,1" :
            return "iPhone3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3" :
            return "iPhone4"
        case "iPhone4,1" :
            return "iPhone4s"
        case "iPhone5,1", "iPhone5,2" :
            return "iPhone5"
        case "iPhone5,3", "iPhone5,4" :
            return "iPhone5c"
        case "iPhone6,1", "iPhone6,2" :
            return "iPhone5s"
        case "iPhone7,2" :
            return "iPhone6"
        case "iPhone7,1" :
            return "iPhone6 Plus"
        case "iPhone8,1" :
            return "iPhone6s"
        case "iPhone8,2" :
            return "iPhone6s Plus"
        case "iPhone8,4" :
            return "iPhone SE"
        case "iPhone9,1", "iPhone9,3" :
            return "iPhone7"
        case "iPhone9,2", "iPhone9,4" :
            return "iPhone7 Plus"
        case "iPhone10,1", "iPhone10,4" :
            return "iPhone8"
        case "iPhone10,2", "iPhone10,5" :
            return "iPhone8 Plus"
        case "iPhone10,3", "iPhone10,6" :
            return "iPhoneX"
        default:
            return "Unknown iPhone : \(identifier)"
        }
    }

}
