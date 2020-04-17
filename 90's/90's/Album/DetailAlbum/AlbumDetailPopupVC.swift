//
//  AlbumDetailPopupVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/08.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit

class AlbumDetailPopupVC: UIViewController {
    @IBOutlet weak var touchView: UIView!
    @IBAction func cancleBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func touchAlbumBtn(_ sender: UIButton) {
        galleryPicker.sourceType = .photoLibrary
        galleryPicker.delegate = self
        present(galleryPicker, animated: true)
    }
    @IBAction func touchCameraBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
        let goNextVC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.present(goNextVC, animated: true)
    }
    
    let galleryPicker = UIImagePickerController()
    var albumIndex : Int!
    var detailProtocol : AlbumDetailVCProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.touchView
        { self.dismiss(animated: true)}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let beforeVC = presentingViewController as? AlbumDetailController {
            DispatchQueue.main.async {
                beforeVC.photoCollectionView.reloadData()
            }
        }
    }
}


extension AlbumDetailPopupVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(url, forKey: "assetURL")
            AlbumDatabase.arrayList[albumIndex!].photos.append(image)
            
//            let storyboard = UIStoryboard(name: "Sticker", bundle: nil)
//            let nextVC = storyboard.instantiateViewController(withIdentifier: "imageRenderVC") as! ImageRenderVC
//            self.navigationController?.show(nextVC, sender: nil)
            //self.present(nextVC, animated: true, completion: nil)
        }
        
        dismiss(animated: true, completion: {
            self.detailProtocol?.reloadView()
        })
    }
}

