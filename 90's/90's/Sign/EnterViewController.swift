//
//  EnterViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func autoLogin(){
          //기존에 로그인한 데이터가 있을 경우
          if let email = UserDefaults.standard.string(forKey: "email"){
              //소셜 로그인의 경우
              if(UserDefaults.standard.bool(forKey: "social")){
                  goLogin(email, nil, true)
              }else {
                  guard let password = UserDefaults.standard.string(forKey: "password") else {return}
                  goLogin(email, password, false)
              }
          }
      }
    
    
    //둘러보기 버튼 클릭 시
    @IBAction func takeALook(_ sender: Any) {
        //default 유저 값 받아옴,메인화면으로 이동
        guard let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
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
    
    //카카오톡 회원가입
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
                        self.showErrAlert()
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
                    }
                })
                
                KOSessionTask.userMeTask(completion: { (userInfoErr, user) in
                    guard let user = user,
                        let email = user.account?.email,
                        let nickName = user.account?.profile?.nickname
                        else { return }
                    print("\(email) & \(nickName)")
                    
                    //전화번호 인증화면 이동
                    let signUpSB = UIStoryboard(name: "SignUp", bundle: nil)
                    let authenVC = signUpSB.instantiateViewController(identifier: "TelephoneAuthenViewController") as! TelephoneAuthenViewController
                    
                    authenVC.isSocial = true
                    authenVC.email = email
                    authenVC.nickName = nickName
                    self.navigationController?.pushViewController(authenVC, animated: true)
                })
                
            }else {
                print("로그인 에러: \(error)")
            }
        }
        
    }
    
    func setUI(){
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        loginBtn.layer.cornerRadius = 8.0
        signUpBtn.layer.cornerRadius = 8.0
        kakaoLoginBtn.layer.cornerRadius = 8.0
    }
    
    
 //자동로그인 -> 로그인 서버통신
    func goLogin(_ email: String, _ password: String?, _ social: Bool){
        LoginService.shared.login(email: email, password: password, sosial: social, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let loginResult = try? decoder.decode(SignUpResult.self, from: data)
                    guard let jwt = loginResult?.jwt else { return }
                    
                    //자동로그인 될때마다 jwt 갱신해서 저장
                    UserDefaults.standard.set(jwt, forKey: "jwt")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.switchTab()
                    break
                case 400...404:
                    self.showErrAlert()
                    print("SignIn : client Err \(status)")
                    break
                case 500:
                    self.showErrAlert()
                    print("SignIn : server Err \(status)")
                    break
                default:
                    return
                }
            }
        })
    }
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "로그인 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
   
}
