//
//  panVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class panVC: UIViewController {
    @IBOutlet weak var testView: UIView!
    
    var sticker : StickerLayout!
    var testimage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStickerView(image: UIImage(named: "smileimage")!)
        createView(image: UIImage(named: "starimage")!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch!.view == sticker.rotateImageView {
            let position = touch!.location(in: self.view)
            let target = sticker?.center
            let angle = atan2(target!.y - position.y, target!.x - position.x)
//            sticker?.transform = sticker.transform.rotated(by: angle)
//            target = position
//            sticker?.transform = CGAffineTransform(scaleX: target!.x / position.x, y: target!.y / position.y)
            
//            sticker?.transform = CGAffineTransform(rotationAngle: angle)
        }
        else if touch!.view == sticker.resizeImageView {
            let position = touch!.location(in: self.view)
            let target = sticker?.center
            let angle = atan2(target!.y - position.y, target!.x - position.x)
            let size = max((position.x / target!.x), (position.y / target!.y))
            sticker?.transform = CGAffineTransform(scaleX: size, y: size)
        }
        else if touch!.view == testView {
            let position = touch!.location(in: self.view)
            let target = testView?.center
            let angle = atan2(target!.y - position.y, target!.x - position.x)
            testView?.transform = CGAffineTransform(rotationAngle: angle)
        }
        else if touch!.view == testimage {
            let position = touch!.location(in: self.view)
            let target = testimage?.center
            let angle = atan2(target!.y - position.y, target!.x - position.x)
            testimage?.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}


extension panVC {
    private func createView(image: UIImage){
        let imageView = UIImageView()
        imageView.frame = CGRect(x: self.view.frame.width / 3 + 50, y: self.view.frame.height / 6 + 50, width: 100, height: 100)
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        testimage = imageView
        //createImageRotate(view: imageView)
        self.view.addSubview(testimage)
    }
    
    private func createStickerView(image : UIImage){
        let imageView = StickerLayout.loadFromZib(image: image)
        imageView.frame = CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2 - 60, width: 120, height: 120)
        sticker = imageView
//        createPan(view: sticker)
        createRotate(view: sticker.rotateImageView)
    
        self.view.addSubview(sticker)
    }
    
    private func createPan(view : UIView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createRotate(view : UIImageView){
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotateGesture(rotateGesture:)))
        view.addGestureRecognizer(rotateGesture)
    }
    
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        sticker.center = CGPoint(x: sticker.center.x + transition.x, y: sticker.center.y + transition.y)
    }
    
    @objc func handleRotateGesture(rotateGesture : UIRotationGestureRecognizer){
        sticker!.layer.anchorPoint = CGPoint(x: sticker!.center.x, y: sticker!.center.y)
        sticker!.transform = sticker!.transform.rotated(by: rotateGesture.rotation)
        
        rotateGesture.rotation = 0
        print("rotate gesture working")
    }
}
