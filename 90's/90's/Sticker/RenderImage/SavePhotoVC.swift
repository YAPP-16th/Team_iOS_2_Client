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
        goToRootVC(value: 4)
    }
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var photoView: UIView!
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var cancleBtn: UIButton!
    
    var location = CGPoint(x: 0.0, y: 0.0)
    var deviceSize = CGSize(width: 0,height: 0)
    var imageView : UIImageView = UIImageView()
    
    var originImage : UIImage!
    var selectedLayout : AlbumLayout!
    var albumUid : Int = 0
    var imageName : String = ""
    var dateLabel : UILabel = UILabel()
    var renderImage : UIImage?
    
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
        cancleBtn.addTarget(self, action: #selector(touchCancleBtn), for: .touchUpInside)
        cancleViewLabel.text = "편집한 내용을 저장하지 않고\n나가시겠습니까?"
    }
    
    
    func defaultSetting(){
        view.addSubview(imageView)
        imageView = applyBackImageViewLayout(selectedLayout: selectedLayout, smallBig: deviceSize, imageView: imageView)
        imageView.image = originImage
        
        setRenderSaveViewFrameSetting(view : imageView, selectLayout: selectedLayout, size: deviceSize)
        dateLabelSetting(imageView: imageView)
    }
    
    
    func dateLabelSetting(imageView : UIImageView){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy MM dd"
        
        let datePosition = selectedLayout.dateLabelFrame
        let dateLabelSize = CGSize(width: 110, height: 30)
        
        imageView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -datePosition.height - 5).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -datePosition.width - 8).isActive = true
        
        let stroke = [
            NSAttributedString.Key.strokeColor : UIColor.colorRGBHex(hex: 0xf93201),
            NSAttributedString.Key.foregroundColor : UIColor.colorRGBHex(hex: 0xfea006),
            NSAttributedString.Key.strokeWidth : -2.0
            ] as [NSAttributedString.Key : Any]
        
        dateLabel.frame.size = dateLabelSize
        dateLabel.attributedText = NSAttributedString(string: dateFormatter.string(from: Date()), attributes: stroke)
        dateLabel.font = UIFont(name: "Digital-7 Italic", size: 17)!
        dateLabel.textAlignment = .right
        
        dateLabel.layer.shadowColor = UIColor.colorRGBHex(hex: 0xf93201).cgColor
        dateLabel.layer.shouldRasterize = true
        dateLabel.layer.shadowRadius = 3.0
        dateLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        dateLabel.layer.shadowOpacity = 0.5
        dateLabel.layer.masksToBounds = false
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
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        renderImage = renderer.image { ctx in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        guard let image = renderImage else {return}
        
        AlbumService.shared.photoUpload(albumUid: albumUid, image: [image], imageName: imageName, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    print("\(status) : success")
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in SavePhotoVc - photoUpLoad")
                default:
                    return
                }
            }
        })
        
        iPhone8Model() ? goToRootVC(value: 4) : goToRootVC(value: 5)
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
    
    @objc func touchCancleBtn(){
        switchHideView(value: false)
    }
}

