//
//  ProfileVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/13.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class ProfileVC: UIViewController {
    @IBOutlet weak var guestView: UIView!
    @IBOutlet weak var profileView: UIView!
    // guestView
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var guestLoginBtn: UIButton!
    // profileView
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileAlbumCount: UILabel!
    @IBOutlet weak var profilePrintCount: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    //로그아웃 버튼, 회원탈퇴 버튼
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var leaveBtn: UIButton!
    @IBOutlet weak var lineImageView: UIImageView!
    //탈퇴 팝업 뷰
    @IBOutlet weak var leaveView: UIView!
    @IBOutlet weak var rethinkBtn: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    let menuArr : [String] = ["주문 내역", "내 정보 관리", "FAQ", "설정"]
    var isDefault = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // iPhone X..
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
            self.topConstraint.constant = 34
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.topConstraint.constant = 34 / 2
        }
    }
    
    @IBAction func goLogin(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchEnterView()
    }
    
    @IBAction func goLogout(_ sender: Any) {
        //저장되어있는 모든 정보를 삭제함
        removeSavedUserInfo()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchEnterView()
    }
    
    //프로필 메인 - 회원탈퇴 버튼 클릭 시
    @IBAction func goLeave(_ sender: Any) {
        let tabCoverImg = UIImageView(image: UIImage(named: "rectangleBlackopacity"))
        self.tabBarController?.tabBar.addSubview(tabCoverImg)
        rethinkBtn.layer.cornerRadius = 8.0
        leaveView.isHidden = false
    }
    
    //탈퇴 뷰 - X 버튼 클릭 시 액션
    @IBAction func closeBtn(_ sender: Any) {
        self.tabBarController?.tabBar.subviews.last!.removeFromSuperview()
        leaveView.isHidden = true
        
    }
    
    //탈퇴 뷰 - 생각해볼게요 버튼 클릭 시 액션
    @IBAction func clickThinkBtn(_ sender: Any) {
        self.tabBarController?.tabBar.subviews.last!.removeFromSuperview()
        leaveView.isHidden = true
    }
    
    //탈퇴뷰 - 회원탈퇴 버튼 클릭 시 액션
    @IBAction func clickLeaveBtn(_ sender: Any) {
        //애플아이디일 경우 탈퇴 불가 -> 아이폰 설정에서 앱과 연결 끊을 시 자동탈퇴되도록 자체 탈퇴 막음
        if UserDefaults.standard.bool(forKey: "isAppleId") {
            showCannotLeaveAlert()
        }else {
            let leaveReasonVC = storyboard?.instantiateViewController(withIdentifier: "LeaveReasonViewController") as! LeaveReasonViewController
            leaveReasonVC.modalPresentationStyle = .fullScreen
            self.present(leaveReasonVC, animated: true, completion: nil)
        }
        
    }
    
    func setUI(){
        settingTableView.delegate = self
        settingTableView.dataSource = self
        guestLoginBtn.layer.cornerRadius = 8.0
        getProfile()
    }
    
    func getProfile(){
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        
        GetProfileService.shared.getProfile(token: jwt, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    guard let profileResult = try? decoder.decode(ProfileResult.self, from: data) else { return }
                    self.setProfileUI(profileResult)
                    break
                case 401...500:
                    self.showErrAlert()
                    break
                default:
                    return
                }
            }
            
        })
    }
    
    
    func setProfileUI(_ profileResult: ProfileResult){
        //디폴트 유저는 전화번호가 nil
        print("setProfileUI. \(profileResult)")
        if profileResult.userInfo.phoneNum != nil {
            profileEmail.text = profileResult.userInfo.email
            profilePrintCount.text = "\(profileResult.albumPrintingCount)"
            profileAlbumCount.text = "\(profileResult.albumTotalCount)"
            profileName.text = profileResult.userInfo.name
            isDefault = false
            guestView.isHidden = true
        }else {
            logoutBtn.isHidden = true
            leaveBtn.isHidden = true
            profileView.isHidden = true
            lineImageView.isHidden = true
        }
    }
    
    //로그아웃시 사용되는 메소드 - 모든 정보 지움
    func removeSavedUserInfo(){
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "social")
        UserDefaults.standard.removeObject(forKey: "jwt")
    }
    
    
    //프로필 조회 불가 시 경고창
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "프로필 조회 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    //애플아이디일 경우 탈퇴 불가 경고창
    func showCannotLeaveAlert(){
        let alert = UIAlertController(title: "탈퇴불가", message: "아이폰 설정에서 앱과의 APPLE ID 사용을 중단해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
}



extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.settingLabel.text = menuArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuName = menuArr[indexPath.row]
        
        switch indexPath.row {
        case 0:
            if isDefault {
                let defaultUserVC = storyboard?.instantiateViewController(withIdentifier: "DefaultUserViewController") as! DefaultUserViewController
                defaultUserVC.titleStr = menuName
                self.navigationController?.pushViewController(defaultUserVC, animated: true)
            }else {
                let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListViewController") as! OrderListViewController
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
            break
        case 1:
            let manageInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageInfoViewController") as! ManageInfoViewController
            manageInfoVC.isDefault = self.isDefault
            self.navigationController?.pushViewController(manageInfoVC, animated: true)
            break
        case 2:
            let faqVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            self.navigationController?.pushViewController(faqVC, animated: true)
            break
        case 3:
            if isDefault {
                let defaultUserVC = storyboard?.instantiateViewController(withIdentifier: "DefaultUserViewController") as! DefaultUserViewController
                defaultUserVC.titleStr = menuName
                self.navigationController?.pushViewController(defaultUserVC, animated: true)
            }else {
                let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            break
        default:
            return
        }
    }
}



