//
//  savePhotoVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class SavePhotoVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var image : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.isHidden = false
        imageView.image = image!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
        switchBtn.addTarget(self, action: #selector(touchSwitchBtn), for: .touchUpInside)
    }
}


extension SavePhotoVC {
    @objc func touchSaveBtn(){
        imageView.addSubview(dateView)
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { ctx in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        dismiss(animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image saved")
        }
    }
    
    @objc func touchSwitchBtn(){
        // date와 저장하려면 addSubview, View로 만들어야 함
        if dateLabel.isHidden == true {
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
    }
}
