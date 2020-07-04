//
//  SplashViewController.swift
//  90's
//
//  Created by 조경진 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var lottieView: UIView!
    
    var mTimer:  Timer? = nil
    var number: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playLottie()
        ticktok()
        // Do any additional setup after loading the view.
    }
    
    func playLottie(){
        let animationView = AnimationView(name:"90s_splash")
        lottieView.addSubview(animationView)
        animationView.play()
    }
    
    func ticktok(){
        if let timer = mTimer {
            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
        }else{
            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            /** 1초마다 timerCallback함수를 호출하는 타이머 */
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCallback(){
        number += 1
        if number == 2 {
            print("Time out")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EnterViewController") as! EnterViewController
            
            //            vc.modalTransitionStyle = .crossDissolve
            //            vc.modalPresentationStyle = .overCurrentContext
            //            vc.modalPresentationStyle = .fullScreen
            
            let enterNav = UINavigationController(rootViewController: vc)
            enterNav.modalPresentationStyle = .fullScreen
            self.present(enterNav, animated: true, completion: nil)
            
        }
    }
    
    
    
}
