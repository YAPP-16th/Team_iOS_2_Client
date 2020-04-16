//
//  panVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class panVC: UIViewController {
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var testView: UIView!
    @IBAction func pan(_ sender: Any) {
        let transition = panGesture.translation(in: testView)
        let changedX = testView.center.x + transition.x
        let changedY = testView.center.y + transition.y
        testView.center = CGPoint(x: changedX, y: changedY)
        panGesture.setTranslation(CGPoint.zero, in: testView) // 지정된 view의 좌표계에서 translation 값을 설정
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
