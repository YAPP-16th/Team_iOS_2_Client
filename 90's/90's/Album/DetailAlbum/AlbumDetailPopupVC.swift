//
//  AlbumDetailPopupVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/08.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit
//import Alamofire

class AlbumDetailPopupVC: UIViewController {
    @IBOutlet weak var touchView: UIView!
    @IBAction func cancleBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func touchAlbumBtn(_ sender: UIButton) {
        present(galleryPicker, animated: true)
    }
    @IBAction func touchCameraBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Filter", bundle: nil)
        let goNextVC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.present(goNextVC, animated: true)
    }
    
    lazy var galleryPicker : UIImagePickerController = {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    var albumIndex : Int!
    var detailProtocol : AlbumDetailVCProtocol?
    
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
        detailProtocol?.reloadView()
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(url, forKey: "assetURL")
            AlbumDatabase.arrayList[albumIndex!].photos.append(image)
        }
        detailProtocol?.reloadView()
        // 이전 뷰에 숨기고 떠오르게 하는걸로 변경 
        dismiss(animated: true)
    }
    
    
}

