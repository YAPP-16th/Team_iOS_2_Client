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
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    var location = CGPoint(x: 0.0, y: 0.0)
    var image : UIImage?
    var originalView : UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
        var touch : UITouch! = touches.first! as UITouch
        location = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch : UITouch! = touches.first! as UITouch
        location = touch.location(in: view)
    }
}


extension SavePhotoVC {
    func buttonSetting(){
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
        switchBtn.addTarget(self, action: #selector(touchSwitchBtn), for: .touchUpInside)
    }
    
    func defaultSetting(){
        dateLabel.isHidden = false
        
        photoView.addSubview(originalView!)
        originalView?.translatesAutoresizingMaskIntoConstraints = false
        originalView?.topAnchor.constraint(equalTo: photoView.topAnchor, constant: 0).isActive = true
        originalView?.leftAnchor.constraint(equalTo: photoView.leftAnchor, constant: 0).isActive = true
        originalView?.rightAnchor.constraint(equalTo: photoView.rightAnchor, constant: 0).isActive = true
        originalView?.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 0).isActive = true
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
