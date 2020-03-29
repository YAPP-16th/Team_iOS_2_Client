//
//  ImageRenderVC.swift
//  cameraTest
//
//  Created by 성다연 on 16/03/2020.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit

class ImageRenderVC: UIViewController {
    @IBOutlet weak var renderImage: UIImageView!
    @IBOutlet weak var polaroidView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var sticker1: UIView!
    @IBOutlet weak var sticker2: UIView!
    @IBOutlet weak var sticker3: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    var location = CGPoint(x: 0, y: 0)
    var image : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // test 
        if image == nil {
            image = UIImage(named: "husky")
        }
        renderImage.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stickerSetting()
        buttonSetting()
        keyboardSetting()
        delegateSetting()
        polaroidView.addShadowEffect()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
        var touch : UITouch! = touches.first! as UITouch
        location = touch.location(in: view)
        
        if sticker1.frame.contains(location) {
            sticker1.center = location
        } else if sticker2.frame.contains(location){
            sticker2.center = location
        } else if sticker3.frame.contains(location){
            sticker3.center = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch : UITouch! = touches.first! as UITouch
        location = touch.location(in: view)
        
        if sticker1.frame.contains(location) {
            sticker1.center = location
        } else if sticker2.frame.contains(location){
            sticker2.center = location
        } else if sticker3.frame.contains(location){
            sticker3.center = location
        }
    }
}


extension ImageRenderVC {
    private func buttonSetting(){
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
    }
    
    private func stickerSetting(){
        let imageView1 = UIImageView(image: UIImage(named: "starimage")!)
        let imageView2 = UIImageView(image: UIImage(named: "heartimage")!)
        let imageView3 = UIImageView(image: UIImage(named: "smileimage")!)
        imageView1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView2.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView3.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sticker1.addSubview(imageView1)
        sticker2.addSubview(imageView2)
        sticker3.addSubview(imageView3)
    }
    
    private func keyboardSetting(){
        self.hideKeyboardWhenTappedAround()
    }
    
    private func delegateSetting(){
        self.textField.delegate = self
    }
    
    private func renderViewAsImage(){
        if polaroidView.frame.contains(sticker1.frame) {
            sticker1.bounds.origin.y = 88
            polaroidView.addSubview(sticker1)
        } else if polaroidView.frame.contains(sticker2.frame){
            sticker2.bounds.origin.y = 88
            polaroidView.addSubview(sticker2)
        } else if polaroidView.frame.contains(sticker3.frame){
            sticker3.bounds.origin.y = 88
            polaroidView.addSubview(sticker3)
        }
        
        let renderer = UIGraphicsImageRenderer(size: polaroidView.bounds.size)
        let image = renderer.image { ctx in
            polaroidView.drawHierarchy(in: polaroidView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}


extension ImageRenderVC {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image saved")
        }
    }
    
    @objc func touchSaveBtn(){
        self.renderViewAsImage()
    }
}


extension ImageRenderVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        self.dismiss(animated: true)
        return true
    }
}


extension ImageRenderVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToFilterVC" {
            let dest = segue.destination as? FilterListVC
            dest?.image = image
            print("send segue")
        }
    }
}
