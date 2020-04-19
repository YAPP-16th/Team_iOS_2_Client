//
//  EnterViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    //둘러보기 버튼 클릭 시
    @IBAction func takeALook(_ sender: Any) {
        //default 유저 값 받아옴,메인화면으로 이동
        tabBarController?.selectedIndex = 0
    }
    
    //로그인 버튼 클릭 시
    @IBAction func goSignIn(_ sender: Any) {
        let loginMainVC = storyboard?.instantiateViewController(withIdentifier: "LoginMainViewController") as! LoginMainViewController
        navigationController?.pushViewController(loginMainVC, animated: true)
    }
    
    //회원가입 버튼 클릭 시
    @IBAction func goSignUp(_ sender: Any) {
        let termVC = storyboard?.instantiateViewController(withIdentifier: "TermViewController") as! TermViewController
        navigationController?.pushViewController(termVC, animated: true)
    }
    
    //카카오톡 로그인
    @IBAction func goKaKaoLogin(_ sender: Any) {
        
        //싱글톤 객체 생성
        guard let session = KOSession.shared() else {
           return
         }
         
        //세션이 열려있다면 닫기
         if session.isOpen() {
           session.close()
            print("hihiihii")
         }
         
         session.open { (error) in
            if((error) != nil) {print("\(error)")}
            else {print("success")}
            //user정보 가져오기
           KOSessionTask.userMeTask(completion: { (error, user) in
             guard let user = user,
                let email = user.account?.email else { return }
            print("\(error), \(user)")
            let vc = self.storyboard?.instantiateViewController(identifier: "LoginMainViewController") as! LoginMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
           })
            
  
        }
    }
    
}
