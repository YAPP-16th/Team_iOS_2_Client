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
//        sticker.imageView.image = UIImage(named: "smileimage")!
        createView(image: UIImage(named: "starimage")!)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch!.view == sticker {
            print("rotate moved detected")
            let position = touch!.location(in: self.view)
            let target = sticker?.center
            let angle = atan2(target!.y - position.y, target!.x - position.x)
            sticker?.transform = CGAffineTransform(rotationAngle: angle)
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
        createImageRotate(view: imageView)
        self.view.addSubview(imageView)
    }
    
    private func createStickerView(image : UIImage){
        let imageView : StickerLayout = StickerLayout(frame: CGRect(x: self.view.frame.width / 3 - 50, y: self.view.frame.height / 6 - 50, width: 120, height: 120))
        imageView.awakeFromNib()
        //imageView.stickerImageView.image = image
//        let imageView = Bundle.main.loadNibNamed("StickerLayout", owner: self, options: nil)?.first as! StickerLayout
//        imageView.frame = CGRect(x: self.view.frame.width / 3 - 50, y: self.view.frame.height / 6 - 50, width: 120, height: 120)
//        imageView.imageView.image = image
//        imageView.isUserInteractionEnabled = true
        
        sticker = imageView
        createPan(view: imageView)
        createRotate(view: imageView)
        self.view.addSubview(imageView)
    }
    
    private func createPan(view : StickerLayout){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createRotate(view : StickerLayout){
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(rotateGesture:)))
        view.addGestureRecognizer(rotateGesture)
    }
    
    private func createImageRotate(view : UIImageView){
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(rotateGesture:)))
        view.addGestureRecognizer(rotateGesture)
    }
    
    
    @objc func handleRotateGesture(rotateGesture: UIRotationGestureRecognizer){
        let radians = rotateGesture.rotation
        let velocity = rotateGesture.velocity
        let result = "Rotation - Randians = \(radians), velocity = \(velocity)"
        print("result = \(result)")
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        
        let imageView = panGesture.view as! StickerLayout
        imageView.center = CGPoint(x: imageView.center.x + transition.x, y: imageView.center.y + transition.y)
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = false
        self.view.addSubview(imageView)
    }
}
