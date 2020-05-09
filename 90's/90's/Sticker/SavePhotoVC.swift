//
//  savePhotoVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class SavePhotoVC: UIViewController {
    @IBOutlet weak var cancleView: UIView!
    @IBOutlet weak var cancleViewLabel: UILabel!
    @IBOutlet weak var cancleViewSubViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cancleViewSubView: UIView!
    @IBAction func cancleViewCancleBtn(_ sender: UIButton) {
        switchHideView(value: true)
    }
    @IBAction func cnacleViewCompleteBtn(_ sender: UIButton) {
        let beforeVC = self.navigationController?.viewControllers[1] as! AlbumDetailController
        self.navigationController?.popToViewController(beforeVC, animated: true)
    }
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var photoView: UIView!
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var cancleBtn: UIButton!
    
    var location = CGPoint(x: 0.0, y: 0.0)
    var size = CGSize(width: 0,height: 0)
    var originImage : UIImage!
    var dateLabel : UILabel!
    var selectedLayout : AlbumLayout!
    // server data
    var albumUid : Int?
    var imageName : String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defaultSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("save view = \(photoView)")
        buttonSetting()
    }
}


extension SavePhotoVC {
    func buttonSetting(){
        saveBtn.layer.cornerRadius = 10
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
        switchBtn.addTarget(self, action: #selector(touchSwitchBtn), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(touchCancleBtn), for: .touchUpInside)
        cancleViewLabel.text = "편집한 내용을 저장하지 않고\n나가시겠습니까?"
    }
    
    func defaultSetting(){
        let size = isDeviseVersionLow ? returnLayoutSize(selectedLayout: selectedLayout) : returnLayoutBigSize(selectedLayout: selectedLayout)
        setSaveViewLayout(view: photoView, selectLayout: selectedLayout, size: size)
        
        let imageView = UIImageView(image: originImage)
        photoView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size = photoView.frame.size
        imageView.center = photoView.center
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
    }
    
    func switchHideView(value : Bool) {
        switch value {
        case true:
            self.cancleViewSubViewBottom.constant = -self.cancleViewSubView.frame.height
            self.saveBtn.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finish in
                self.cancleView.isHidden = true
            } )
        case false:
            self.cancleViewSubViewBottom.constant = 0
            self.saveBtn.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            self.cancleView.isHidden = false
        }
    }
}


extension SavePhotoVC {
    @objc func touchSaveBtn(){ // 이미지 저장
//        photoView.addSubview(dateLabel)
        let renderer = UIGraphicsImageRenderer(size: photoView.bounds.size)
        let image = renderer.image { ctx in
            photoView.drawHierarchy(in: photoView.bounds, afterScreenUpdates: true)
        }
        
        AlbumService.shared.photoUpload(albumUid: albumUid!, image: [image], imageName: imageName!, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else {return}
                    print("received data = \(data)")
                case 401...404 :
                    print("forbidden access in \(status)")
                default:
                    return
                }
            }
        })
        
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
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
//        if dateLabel.isHidden == true {
//            dateLabel.isHidden = false
//        } else {
//            dateLabel.isHidden = true
//        }
    }
    
    @objc func touchCancleBtn(){
        switchHideView(value: false)
    }
}
