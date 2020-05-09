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
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    // 사진 추가 버튼을 눌렀을 때
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideWhiteView: UIView!
    @IBOutlet weak var hidewhiteviewBottom: NSLayoutConstraint!
    @IBOutlet weak var hideAddAlbumBtn: UIButton!
    @IBOutlet weak var hideAddPhotoBtn: UIButton!
    @IBAction func cancleHideView(_ sender: UIButton) {
        switchHideView(value: true)
    }
    
    // 사진 확대 시
    @IBOutlet weak var hideImageZoom: UIImageView!
    
    private var longPressGesture : UILongPressGestureRecognizer!
    var openAlbumCount : Int! // 앨범 낡기 적용
    var isEnded : Bool = true
    var currentCell : UICollectionViewCell? = nil
    var selectedLayout : AlbumLayout?
    var galleryPicker : UIImagePickerController = {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()
    // server data
    var albumIndex : Int?
    var ImageName : String?
    var newImage : UIImage?
    
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
        NetworkSetting()
        photoCollectionView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
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
        albumNameLabel.text = AlbumDatabase.arrayList[albumIndex!].albumName
        albumCountLabel.text = "\(AlbumDatabase.arrayList[albumIndex!].photos.count - 1) 개의 추억이 쌓였습니다"
        selectedLayout = AlbumDatabase.arrayList[albumIndex!].albumLayout
        
        hideView.isHidden = true
        hideWhiteView.layer.cornerRadius = 15

        hideImageZoom.frame.size = setZoomImageView(layout: selectedLayout!)
        hideImageZoom.center = view.center

        // 순서 바꾸기
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        photoCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func buttonSetting(){
        addPhotoBtn.addTarget(self, action: #selector(touchAddPhotoBtn), for: .touchUpInside)
        hideAddAlbumBtn.addTarget(self, action: #selector(touchAlbumBtn), for: .touchUpInside)
        hideAddPhotoBtn.addTarget(self, action: #selector(touchCameraBtn), for: .touchUpInside)
    }
}


extension AlbumDetailController {
    func NetworkSetting(){
        // 1. 앨범에서 사진 uid 가져오기
        // 2. 서버에 앨범 uid와 사진uid 요청
//        AlbumService.shared.get
    }
    
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
    
    func switchZoomView(value : Bool){
        switch value {
        case true :
            self.hideView.isHidden = true
            self.hideImageZoom.isHidden = true
        case false :
            self.hideView.isHidden = false
            self.hideImageZoom.isHidden = false
        }
    }
    
    func setZoomImageView(layout : AlbumLayout) -> CGSize {
        switch layout {
        case .Polaroid : return AlbumLayout.Polaroid.bigsize
        case .Mini : return AlbumLayout.Mini.bigsize
        case .Memory : return AlbumLayout.Memory.bigsize
        case .Portrab : return AlbumLayout.Portrab.bigsize
        case .Portraw : return AlbumLayout.Portraw.bigsize
        case .Tape : return AlbumLayout.Tape.bigsize
        case .Filmroll : return AlbumLayout.Filmroll.bigsize
        }
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


extension AlbumDetailController {
    @objc func touchCameraBtn(){
        let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
        let goNextVC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        goNextVC.modalPresentationStyle = .fullScreen
        self.present(goNextVC, animated: true)

    }
    
    @objc func touchAlbumBtn(){
        present(galleryPicker, animated: true){
            self.switchHideView(value: true)
        }
    }
    
    @objc func touchAddPhotoBtn() {
        if (AlbumDatabase.arrayList[albumIndex!].photos.count >= AlbumDatabase.arrayList[albumIndex!].albumMaxCount) {
            addPhotoBtn.isEnabled = false
            
            let alert = UIAlertController(title: "사진 추가 불가", message: "제한개수를 모두 채웠습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert,animated: true)
        } else {
            addPhotoBtn.isEnabled = true
            switchHideView(value: false)
        }
    }
    
    @objc func handleLongGesture(gesture : UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = photoCollectionView.indexPathForItem(at: gesture.location(in: photoCollectionView)) else { break }
            isEnded = false
            currentCell = photoCollectionView.cellForItem(at: selectedIndexPath)
            photoCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            photoCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            isEnded = true
            photoCollectionView.performBatchUpdates({
                self.photoCollectionView.endInteractiveMovement()
            }, completion: { (result) in
                self.currentCell = nil
            })
        default:
            isEnded = true
            photoCollectionView.cancelInteractiveMovement()
        }
    }
}


extension AlbumDetailController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumDatabase.arrayList[albumIndex!].photos.count - 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentCell != nil && isEnded {
            return currentCell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
            let size = returnLayoutSize(selectedLayout: selectedLayout!)
            cell.backImageView = applyBackImageViewLayout(selectedLayout: selectedLayout!, smallBig: size, imageView: cell.backImageView)
            cell.photoImageView = applyImageViewLayout(selectedLayout: selectedLayout!, smallBig: size, imageView: cell.photoImageView, image: AlbumDatabase.arrayList[albumIndex!].photos[indexPath.row+1])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return returnLayoutSize(selectedLayout: selectedLayout!)
        //return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = AlbumDatabase.arrayList[albumIndex!].photos[sourceIndexPath.row]
        AlbumDatabase.arrayList[albumIndex!].photos.remove(at: sourceIndexPath.row)
        AlbumDatabase.arrayList[albumIndex!].photos.insert(movedItem, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
//        hideImageZoom.image = setOldFilter(image: cell.photoImageView.image!)
        hideImageZoom.image = cell.photoImageView.image
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
            for photo in images {
                AlbumDatabase.arrayList[self.albumIndex!].photos.insert(photo as! UIImage, at: destinationIndexPath.item)
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
            vc.albumUid = self.albumIndex
            vc.imageName = self.ImageName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension AlbumDetailController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToInfoVC" {
            let dest = segue.destination as! AlbumInfoVC
            dest.albumIndex = albumIndex!
        }
    }
}


