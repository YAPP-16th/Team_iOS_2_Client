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
    
    var layoutImageView : UIImageView = UIImageView()
    var layoutRatio : CGFloat = CGFloat()
    var layoutView : UIView = UIView()
    
    var image : UIImage!
    var imageRadio : CGFloat = CGFloat()
    var selectedLayout : AlbumLayout! = .Polaroid
    var albumUid : Int = 0
    var imageName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageResizing()
        layoutSetting()
    }
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//
//        if touch?.view == layoutImageView {
//            let position = touch!.location(in: self.view)
//            let target = layoutImageView.center
//            let size = max((position.x / target.x), (position.y / target.y))
//            let scale = CGAffineTransform(scaleX: size, y: size)
//            layoutCustomSize = size
//            layoutImageView.transform = scale
//        }
//    }
    
}
 

extension ImageCropVC {
    private func imageResizing(){
        imageRadio = min(image.size.width / image.size.height,
                                image.size.height / image.size.width)
        let imageSize = image.size.width > image.size.height ?
            CGSize(width: cropView.frame.width, height: ceil(cropView.frame.width * imageRadio)) :
            CGSize(width: ceil(cropView.frame.height * imageRadio), height: cropView.frame.height)
        photoImageView.image = image.imageResize(sizeChange: imageSize)
        
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutView.isUserInteractionEnabled = true
        self.cropView.addSubview(layoutView)
        
        layoutView.frame.size = iPhone8Model() ? selectedLayout.innerFrameLowSize : selectedLayout.innerFrameHighSize
        layoutView.centerXAnchor.constraint(equalTo: cropView.centerXAnchor).isActive = true
        layoutView.centerYAnchor.constraint(equalTo: cropView.centerYAnchor).isActive = true
        
        layoutImageView = UIImageView(image: selectedLayout.cropImage)
        layoutImageView.isUserInteractionEnabled = true
        self.layoutView.addSubview(layoutImageView)
    }
    
    private func layoutSetting(){
        
//        layoutImageView.frame.size = iPhone8Model() ? selectedLayout.innerFrameLowSize : selectedLayout.innerFrameHighSize
        layoutImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutImageView.leftAnchor.constraint(equalTo: layoutView.leftAnchor).isActive = true
        layoutImageView.rightAnchor.constraint(equalTo: layoutView.rightAnchor).isActive = true
        layoutImageView.topAnchor.constraint(equalTo: layoutView.topAnchor).isActive = true
        layoutImageView.bottomAnchor.constraint(equalTo: layoutView.bottomAnchor).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        layoutImageView.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        layoutImageView.addGestureRecognizer(pinchGesture)
    }
    
    private func nextVC(){
        let croppedImage : UIImage = photoImageView.image!.cropToRect(rect: layoutImageView.frame)!
        print("cropped image = \(croppedImage), \(layoutImageView.frame), \(photoImageView.image)")
        //let croppedCGImage = photoImageView.image?.cgImage?.cropping(to: layoutImageView.frame)
        //let croppedImage = UIImage(cgImage: croppedCGImage!)
        image = croppedImage
        
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
        self.view.layoutIfNeeded()
    }
    @objc private func handlePinchGesture(pinchGesture : UIPinchGestureRecognizer){
        pinchGesture.view?.transform = (pinchGesture.view?.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale))!
        layoutRatio = pinchGesture.scale
        pinchGesture.scale = 1.0
    }
}


class CropAreaView: UIImageView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
