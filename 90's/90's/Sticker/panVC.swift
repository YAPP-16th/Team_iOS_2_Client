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
    
    var sticker : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStickerView(image: UIImage(named: "smileimage")!)
    }
}


extension panVC {
    private func createStickerView(image : UIImage){
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: self.view.frame.width / 3 - 50, y: self.view.frame.height / 6 - 50, width: 100, height: 100)
        imageView.isUserInteractionEnabled = true
        sticker = imageView
        createPan(view: imageView)
        self.view.addSubview(imageView)
    }
    
    private func createPan(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        
        let imageView = panGesture.view as! UIImageView
        imageView.center = CGPoint(x: imageView.center.x + transition.x, y: imageView.center.y + transition.y)
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = false
        self.view.addSubview(imageView)
    }
}
