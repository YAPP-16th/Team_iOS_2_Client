//
//  savePhotoVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class SavePhotoVC: UIViewController {
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var location = CGPoint(x: 0.0, y: 0.0)
    var originalView : UIView?
    var selectedLayout : AlbumLayout! = .Polaroid
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
    }
}


extension SavePhotoVC {
    func buttonSetting(){
        saveBtn.layer.cornerRadius = 10
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
        switchBtn.addTarget(self, action: #selector(touchSwitchBtn), for: .touchUpInside)
    }
    
    func defaultSetting(){
        photoView = originalView
        setSaveViewLayout(view: photoView, selectLayout: selectedLayout)
    }
    
    
}


extension SavePhotoVC {
    @objc func touchSaveBtn(){
        photoView.addSubview(dateLabel)
        let renderer = UIGraphicsImageRenderer(size: photoView.bounds.size)
        let image = renderer.image { ctx in
            photoView.drawHierarchy(in: photoView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image saved")
        }
    }
    
    @objc func touchSwitchBtn(){
        if dateLabel.isHidden == true {
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
    }
}
