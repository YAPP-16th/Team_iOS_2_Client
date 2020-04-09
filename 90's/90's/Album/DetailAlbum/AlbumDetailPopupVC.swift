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
    @IBAction func touchAlbumBtn(_ sender: UIButton) {
        galleryPicker.sourceType = .photoLibrary
        galleryPicker.delegate = self
        present(galleryPicker, animated: true)
    }
    @IBAction func touchCameraBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
        let goNextVC = storyBoard.instantiateViewController(withIdentifier: "testViewController") as! testViewController
        self.present(goNextVC, animated: true)
    }
    
    private let galleryPicker = UIImagePickerController()
    var albumIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.touchView
        { self.dismiss(animated: true)}
    }
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

