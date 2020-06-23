//
//  AlbumInvitedVC.swift
//  90's
//
//  Created by 성다연 on 2020/05/18.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumInvitedVC: UIViewController {
    // 회원
    @IBOutlet weak var albumInvitedView: UIView!
    @IBOutlet weak var albumInvitedTF: UITextField!
    @IBOutlet weak var albumInvitedLabel: UILabel!
    @IBOutlet weak var albumCompleteBtn: UIButton!
    @IBOutlet weak var albumCancleBtn: UIButton!
    @IBAction func cancleBtn(_ sender: UIButton) {
        // 앱 종료
    }
    // 비회원
    @IBOutlet weak var terminateView: UIView!
    @IBOutlet weak var terminateLabel: UILabel!
    @IBOutlet weak var terminateSignupBtn: UIButton!
    @IBOutlet weak var terminateCancleBtn: UIButton!
    
    
    var isUserMember : Bool = false
    var albumIndex : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
        buttonSetting()
    }
}


extension AlbumInvitedVC {
    func defaultSetting(){
        albumInvitedTF.delegate = self
        albumInvitedTF.becomeFirstResponder()
        terminateLabel.text = "90's 회원만 앨범을 \n열람할 수 있습니다"
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: albumInvitedTF, queue: .main, using: { _ in
            let value = self.albumInvitedTF.text!.trimmingCharacters(in: .whitespaces)
            if !value.isEmpty {
                if value.count >= 4 {
                    self.albumCompleteBtn.backgroundColor = UIColor.black
                    self.albumCompleteBtn.isEnabled = true
                    self.albumInvitedLabel.backgroundColor = UIColor.black
                    self.networkGetPassword(passwd: value)
                }
            } else {
                self.albumCompleteBtn.backgroundColor = UIColor.lightGray
                self.albumCompleteBtn.isEnabled = false
                self.albumInvitedLabel.backgroundColor = UIColor.lightGray
            }
        })
    }

    func autoLogin(){
        //기존에 로그인한 데이터가 있을 경우
        if let email = UserDefaults.standard.string(forKey: "email"){
            switchUserType(value: true)
            //소셜 로그인의 경우
            if(UserDefaults.standard.bool(forKey: "social")){
                goLogin(email, nil, true)
            }else {
                guard let password = UserDefaults.standard.string(forKey: "password") else {return}
                goLogin(email, password, false)
            }
        } else {
            switchUserType(value: false)
        }
    }
    
    func switchUserType(value : Bool) {
        switch value {
        case true:
            terminateView.isHidden = true
            terminateSignupBtn.isEnabled = false
            terminateCancleBtn.isEnabled = false
            albumCancleBtn.isEnabled = true
            albumInvitedView.isHidden = false
            albumInvitedTF.isEnabled = true
            albumCompleteBtn.isEnabled = true
        case false:
            terminateView.isHidden = false
            terminateSignupBtn.isEnabled = true
            terminateCancleBtn.isEnabled = true
            albumCancleBtn.isEnabled = false
            albumInvitedView.isHidden = true
            albumInvitedTF.isEnabled = false
            albumCompleteBtn.isEnabled = false
        }
    }
    
    func buttonSetting(){
        albumCompleteBtn.addTarget(self, action: #selector(touchAlbumCompleteBtn), for: .touchUpInside)
        terminateSignupBtn.addTarget(self, action: #selector(touchTerminateSignupBtn), for: .touchUpInside)
    }
}


extension AlbumInvitedVC {
    @objc func touchAlbumCompleteBtn(){
        // 공유앨범 비밀번호 서버통신 후
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "albumDetailVC") as! AlbumDetailVC
        nextVC.albumUid = albumIndex
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func touchTerminateSignupBtn(){
        let signUpSB = UIStoryboard(name: "SignUp", bundle: nil)
        let termVC = signUpSB.instantiateViewController(withIdentifier: "TermViewController") as! TermViewController
        navigationController?.pushViewController(termVC, animated: true)
    }
}


extension AlbumInvitedVC {
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
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumInvitedVC - goLogin")
                default:
                    return
                }
            }
        })
    }
    
    func networkGetPassword(passwd : String){
        // 비밀번호 조회 api
        AlbumService.shared.albumJoinPassword(password: passwd, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else { return }
                    guard let value = try? JSONDecoder().decode(album.self, from: data) else { return }
                    self.presentDetailAlbum(albumUid: value.uid)
                    case 401:
                        print("\(status) : bad request, no warning in Server")
                    case 404:
                        print("\(status) : Not found, no address")
                    case 500 :
                        print("\(status) : Server error in AlbumInvitedVC - goLogin")
                    default:
                        return
                }
            }
        })
    }
    
    func presentDetailAlbum(albumUid : Int){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "albumDetailVC") as! AlbumDetailVC
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.albumUid = albumUid
        self.present(nextVC, animated: true)
    }
}


extension AlbumInvitedVC : UITextFieldDelegate {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         albumInvitedTF.endEditing(true)
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         albumInvitedTF.resignFirstResponder()
         return true
     }
}
