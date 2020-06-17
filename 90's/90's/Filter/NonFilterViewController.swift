//
//  NonFilterViewController.swift
//  90's
//
//  Created by 조경진 on 2020/06/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Photos

class NonFilterViewController: UIViewController {
    
    let picker = UIImagePickerController()
    var tempImage : UIImage? = nil
    var openFlag : Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        picker.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if openFlag == false {
            openCamera()
        }
    }
    
    func openCamera()
    {
        openFlag = !openFlag
        print(openFlag)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
    
}
extension NonFilterViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 이미지 저장.
        if let image = info[.originalImage] as? UIImage {
            self.tempImage = image
            
            let storyboard = UIStoryboard(name: "Sticker", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "imageCropVC") as! ImageCropVC
            vc.modalPresentationStyle = .fullScreen
            vc.image = image
            self.present(vc, animated: true)
        }
        
        if let url = info[.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(savedVideo), nil)
        }
        
        
        self.picker.dismiss(animated: false) {
            self.dismiss(animated: false, completion: {
                print("Here")
                

            })
        }
        
    }
    
    @objc
    func savedImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print(error)
            return
        }
        
        
        print("success")
    }
    
    @objc
    func savedVideo(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print(error)
            return
        }
        print("success")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true) {
            if self.openFlag {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
