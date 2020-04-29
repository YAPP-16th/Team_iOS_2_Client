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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    var location = CGPoint(x: 0.0, y: 0.0)
    var size = CGSize(width: 0,height: 0)
    var originView : UIView!
    var originImage : UIImage!
    var dateLabel : UILabel!
    var selectedLayout : AlbumLayout! = .Polaroid
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
        dateLabelSetting()
    }
}


extension SavePhotoVC {
    func buttonSetting(){
        saveBtn.layer.cornerRadius = 10
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
        switchBtn.addTarget(self, action: #selector(touchSwitchBtn), for: .touchUpInside)
    }
    
    func defaultSetting(){
        setSaveViewLayout(view: photoView, selectLayout: selectedLayout)
        photoView.addSubview(originView)
//        setSaveViewLayout(view: photoImageView, selectLayout: selectedLayout)
//        photoImageView.image = originImage
    }
    
    func dateLabelSetting(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        dateLabel = UILabel()
        dateLabel.text = dateFormatter.string(from: Date()) /// 변경사항
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "", size: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        photoView.addSubview(dateLabel)
               
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 111).isActive = true
        print("++ dateLabel = \(dateLabel)")
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
