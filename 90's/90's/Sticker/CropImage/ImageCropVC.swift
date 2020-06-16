//
//  ImageCropVC.swift
//  90's
//
//  Created by 성다연 on 2020/06/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ImageCropVC: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cropView: UIView!
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtn(_ sender: UIButton) { nextVC() }
    
    var layoutView : UIView = UIView()
    var layoutImageView : UIImageView = UIImageView()
    
    var layoutAbsoluteSize : CGSize = CGSize(width: 100, height: 100)
    var layoutRatio : CGFloat = CGFloat()
    var imageRatio : CGFloat = CGFloat()
    var imageSize : CGSize = CGSize(width: 0, height: 0)
    var imageFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var image : UIImage!
    var selectedLayout : AlbumLayout! = .Polaroid
    var albumUid : Int = 0
    var imageName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
        layoutViewSetting()
        layoutImageViewSetting()
    }
}
 

extension ImageCropVC {
    private func defaultSetting(){
        // 이미지 비율 구하기
        imageRatio = min(image.size.width / image.size.height, image.size.height / image.size.width)
        // 이미지 크기 지정
        imageSize = image.size.width > image.size.height ?
            CGSize(width: cropView.frame.width, height: ceil(cropView.frame.width * imageRatio)) :
            CGSize(width: ceil(cropView.frame.height * imageRatio), height: cropView.frame.height)
        // 이미지 크기 조절
        photoImageView.image = image.imageResize(sizeChange: imageSize)
        
        let tempSize = iPhone8Model() ?
                selectedLayout.innerFrameLowSize : selectedLayout.innerFrameHighSize
        var tempRatio : CGFloat = CGFloat()
            
        if tempSize.width >= imageSize.width  {
            tempRatio = round((imageSize.width / tempSize.width) * 1000) / 1000
        } else if tempSize.height >= imageSize.height {
            tempRatio = round((imageSize.height / tempSize.height) * 1000) / 1000
        }
        
        // 레이아웃 최대 크기
        layoutAbsoluteSize = CGSize(width: ceil(tempSize.width * tempRatio),
                                    height: ceil(tempSize.height * tempRatio))
        print("image size = \(imageSize), layoutview size = \(layoutAbsoluteSize)")
    }
    
    // 이미지 크기 만큼의 뷰
    private func layoutViewSetting(){
        layoutView.isUserInteractionEnabled = true
        self.cropView.addSubview(layoutView)
    
        if imageSize.width == cropView.frame.width {
            setSubViewFrameSetting(view: cropView, subView: layoutView,
                                   top: (cropView.frame.height - imageSize.height) / 2,
                                   left: 0,
                                   right: 0,
                                   bottom: (cropView.frame.height - imageSize.height) / 2)
        } else if imageSize.height == cropView.frame.height {
            setSubViewFrameSetting(view: cropView, subView: layoutView,
                                   top: 0,
                                   left: (cropView.frame.width - imageSize.width) / 2,
                                   right: (cropView.frame.width - imageSize.width) / 2,
                                   bottom: 0)
        }
    }
    
    private func layoutImageViewSetting(){
        layoutImageView = UIImageView(image: selectedLayout.cropImage)
        layoutImageView.isUserInteractionEnabled = true
        layoutImageView.frame.size = layoutAbsoluteSize
        self.layoutView.addSubview(layoutImageView)
        
        if imageSize.width == layoutView.frame.width {
            setSubViewFrameSetting(view: layoutView, subView: layoutImageView,
                                   top: 0,
                                   left: (imageSize.width - layoutView.frame.width) / 2,
                                   right: (imageSize.width - layoutView.frame.width) / 2,
                                   bottom: 0)
        } else if imageSize.height == layoutView.frame.height {
            setSubViewFrameSetting(view: layoutView, subView: layoutImageView,
                                   top: (imageSize.height - layoutView.frame.height) / 2,
                                   left: 0,
                                   right: 0,
                                   bottom: (imageSize.height - layoutView.frame.height) / 2)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        layoutImageView.addGestureRecognizer(panGesture)
        layoutImageView.addGestureRecognizer(pinchGesture)
    }
    
    private func nextVC(){
        let croppedImage : UIImage = photoImageView.image!.cropToRect(rect: layoutImageView.frame)!
        image = croppedImage
        print("crop image = \(layoutImageView.frame)")
        
        if image != nil {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "imageRenderVC") as! ImageRenderVC
            
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.image = image
            nextVC.selectLayout = self.selectedLayout
            nextVC.albumUid = self.albumUid
            nextVC.imageName = self.imageName
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


extension ImageCropVC {
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transtition = panGesture.translation(in: self.view)
        panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + transtition.x, y: panGesture.view!.center.y + transtition.y)
        panGesture.setTranslation(.zero, in: self.view)
        print("layoutview frame = \(layoutView.frame)")
        self.view.layoutIfNeeded()
    }
    @objc private func handlePinchGesture(pinchGesture : UIPinchGestureRecognizer){
        pinchGesture.view?.transform = (pinchGesture.view?.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale))!
        layoutRatio = pinchGesture.scale * layoutRatio
        pinchGesture.scale = 1.0
    }
}
