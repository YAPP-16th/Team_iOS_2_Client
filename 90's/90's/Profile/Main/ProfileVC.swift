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
    
    let menuArr : [String] = ["주문 내역", "내 정보 관리", "FAQ", "설정"]
    
    override func viewWillAppear(_ animated: Bool) {
        //디폴트 유저일 때 guestView를 표시하는 로직이 필요함
        getProfile()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func goLogin(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchEnterView()
    }
    
    func setUI(){
        settingTableView.delegate = self
        settingTableView.dataSource = self
        guestLoginBtn.layer.cornerRadius = 8.0
    }
    
    func pushView(_ vc: String){
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: vc) else { return }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func getProfile(){
        GetProfileService.shared.getProfile(completion: {
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
        
        if profileResult.userInfo.phoneNum != nil {
            profileEmail.text = profileResult.userInfo.email
            profilePrintCount.text = "\(profileResult.albumPrintingCount)"
            profileAlbumCount.text = "\(profileResult.albumTotalCount)"
            profileName.text = profileResult.userInfo.name
        }else {
            profileView.isHidden = true
        }
    }
    
    
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "프로필 조회 불가", preferredStyle: .alert)
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
        switch indexPath.row {
        case 0:
            pushView("OrderListViewController")
            break
        case 1:
            pushView("ManageInfoViewController")
            break
        case 2:
            pushView("FAQViewController")
            break
        case 3:
            pushView("SettingViewController")
            break
        default:
            return
        }
    }
}



