//
//  AlbumDetailPopupVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/08.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit

class AlbumDetailPopupVC: UIViewController {
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    @IBOutlet weak var touchView: UIView!
    @IBAction func touchAlbumBtn(_ sender: UIButton) {
        galleryPicker.sourceType = .photoLibrary
        galleryPicker.delegate = self
        present(galleryPicker, animated: true)
    }
    
    
    private let galleryPicker = UIImagePickerController()
    var albumIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.touchView
        { self.dismiss(animated: true)}
    }
}


extension AlbumDetailPopupVC {
    /** addTarget이 왜 objc 함수를 못찾는지 이유를 모르겠음 */
//    @objc func openAlbumPicker(){
//        print("openAlbumPicker work")
//        galleryPicker.sourceType = .photoLibrary
//        galleryPicker.delegate = self
//        present(galleryPicker, animated: true)
//    }
//
//    func ButtonSetting(){
//        albumBtn.addTarget(self, action: #selector(openAlbumPicker), for: .touchUpInside)
//    }
}


extension AlbumDetailPopupVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(url, forKey: "assetURL")
            AlbumDatabase.albumList[albumIndex!].photos.append(image)
        }

        dismiss(animated: true)
    }
}

