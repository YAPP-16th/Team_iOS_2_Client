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
    var initialAngle = CGFloat()
    var angle = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStickerView(image: UIImage(named: "smileimage")!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.initialAngle = pToA(touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch!.view == sticker.rotateImageView {
            let ang = pToA(touch!) - self.initialAngle
            let absoluteAngle = self.angle + ang
            sticker.transform = sticker.transform.rotated(by: ang)
            self.angle = absoluteAngle
        }
        else if touch!.view == sticker.resizeImageView {
            let position = touch!.location(in: self.view)
            let target = sticker?.center
            
            let size = max((position.x / target!.x), (position.y / target!.y))
            let scale = CGAffineTransform(scaleX: size, y: size)
            let rotate = CGAffineTransform(rotationAngle: angle)
            sticker?.transform = scale.concatenating(rotate)
        }
    }
}


extension panVC {
    private func createStickerView(image : UIImage){
        let imageView = StickerLayout.loadFromZib(image: image)
        imageView.frame = CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2 - 60, width: 120, height: 120)
        sticker = imageView
        createPan(view: sticker.backImageView)
    
        self.view.addSubview(sticker)
    }
    
    private func createPan(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    
    func pToA (_ t:UITouch) -> CGFloat {
        let loc = t.location(in: sticker)
        let c = sticker.convert(sticker.center, from:sticker.superview!)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        sticker.center = CGPoint(x: sticker.center.x + transition.x, y: sticker.center.y + transition.y)
    }

}
