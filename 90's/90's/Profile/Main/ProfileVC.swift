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
    var isDefault = true
    
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
            isDefault = false
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
            let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListViewController") as! OrderListViewController
            orderVC.isDefault = self.isDefault
            self.navigationController?.pushViewController(orderVC, animated: true)
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
            let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            settingVC.isDefault = self.isDefault
            self.navigationController?.pushViewController(settingVC, animated: true)
            break
        default:
            return
        }
    }
}



