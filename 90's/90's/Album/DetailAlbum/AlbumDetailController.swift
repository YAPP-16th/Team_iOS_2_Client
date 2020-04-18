//
//  photoStickerCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol AlbumDetailVCProtocol : class {
    func reloadView()
}

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
    
    private var longPressGesture : UILongPressGestureRecognizer!
    var albumIndex:Int?
    var openAlbumCount : Int! // 앨범 낡기 적용
    var isEnded: Bool = true
    var currentCell : UICollectionViewCell? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//        photoCollectionView.dragDelegate = self
        photoCollectionView.dragInteractionEnabled = true
    }
    
    func defaultSetting(){
        albumNameLabel.text = AlbumDatabase.arrayList[albumIndex!].albumName
        albumCountLabel.text = "\(AlbumDatabase.arrayList[albumIndex!].photos.count - 1) 개의 추억이 쌓였습니다"
        // 순서 바꾸기
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        photoCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func buttonSetting(){
        addPhotoBtn.addTarget(self, action: #selector(touchAddPhotoBtn), for: .touchUpInside)
    }
}


extension AlbumDetailController {
    @objc func touchAddPhotoBtn() {
        if (AlbumDatabase.arrayList[albumIndex!].photos.count >= AlbumDatabase.arrayList[albumIndex!].albumMaxCount) {
            addPhotoBtn.isEnabled = false
            
            let alert = UIAlertController(title: "사진  추가 불가", message: "제한개수를 모두 채웠습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert,animated: true)
        } else {
            addPhotoBtn.isEnabled = true
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
            cell.photoImageView.image = AlbumDatabase.arrayList[albumIndex!].photos[indexPath.row+1]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = AlbumDatabase.arrayList[albumIndex!].photos[sourceIndexPath.row]
        AlbumDatabase.arrayList[albumIndex!].photos.remove(at: sourceIndexPath.row)
        AlbumDatabase.arrayList[albumIndex!].photos.insert(movedItem, at: destinationIndexPath.item)
    }
}


//extension AlbumDetailController :  UICollectionViewDragDelegate {
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = AlbumDatabase.arrayList[albumIndex!].photos[indexPath.row]
//        let itemProvider = NSItemProvider(object: item)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
//        let item = AlbumDatabase.arrayList[albumIndex!].photos[indexPath.row]
//        let itemProvider = NSItemProvider(object: item)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        let previewParameters = UIDragPreviewParameters()
//        previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 25, y: 25, width: 120, height: 120))
//        return previewParameters
//
//    }
//}


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


extension AlbumDetailController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToAlbumPopupVC" {
            let dest = segue.destination as! AlbumDetailPopupVC
            dest.albumIndex = albumIndex!
        } else if segue.identifier == "GoToInfoVC" {
            let dest = segue.destination as! AlbumInfoVC
            dest.albumIndex = albumIndex!
        }
    }
}


extension AlbumDetailController : AlbumDetailVCProtocol {
    func reloadView() {
        self.photoCollectionView.reloadData()
        print("call reload view")
//        self.viewWillAppear(true)
    }
}
