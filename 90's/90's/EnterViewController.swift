//
//  EnterViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {
    var loginData =  LoginModel()
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        loginBtn.layer.cornerRadius = 8.0
        signUpBtn.layer.cornerRadius = 8.0
        kakaoLoginBtn.layer.cornerRadius = 8.0
    }
    
    //둘러보기 버튼 클릭 시
    @IBAction func takeALook(_ sender: Any) {
        //default 유저 값 받아옴,메인화면으로 이동
        let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            as! UIViewController
        navigationController?.pushViewController(tabBarVC, animated: true)    }
    
    //로그인 버튼 클릭 시
    @IBAction func goSignIn(_ sender: Any) {
        let SignInSB = UIStoryboard(name: "SignIn", bundle: nil)
        let loginMainVC = SignInSB.instantiateViewController(withIdentifier: "LoginMainViewController") as! LoginMainViewController
        navigationController?.pushViewController(loginMainVC, animated: true)
    }
    
    //회원가입 버튼 클릭 시
    @IBAction func goSignUp(_ sender: Any) {
        let signUpSB = UIStoryboard(name: "SignUp", bundle: nil)
        let termVC = signUpSB.instantiateViewController(withIdentifier: "TermViewController") as! TermViewController
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
        }
        
        session.open { (error) in
            if(session.isOpen()){
                KOSessionTask.accessTokenInfoTask(completionHandler: {
                    (accesstokenInfo, tokenErr) in
                    if let error = tokenErr as NSError? {
                        switch error.code{
                        case 5:
                            print("세션이 만료된(access_token, refresh_token이 모두 만료된 경우) 상태")
                            break
                        default:
                            print("예기치 못한 에러, 서버에러 ")
                            break
                        }
                    }else {
                        print("success request - access token info: \(accesstokenInfo!)")
                        self.loginData.token = accesstokenInfo!.id!.stringValue
                    }
                })
                
                KOSessionTask.userMeTask(completion: { (userInfoErr, user) in
                    guard let user = user,
                        let email = user.account?.email else { return }
                    self.loginData.email = email
                    print("\(self.loginData)")
                })
                
            }else {
                print("로그인 에러: \(error)")
            }
        }
        
    }
    
}
