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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileAlbumCount: UILabel!
    @IBOutlet weak var profilePrintCount: UILabel!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    let menuArr : [String] = ["주문 내역", "내 정보 관리", "FAQ", "설정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        profileView.isHidden = true
    }
    
    @IBAction func goLogin(_ sender: Any) {
        let signSB = UIStoryboard.init(name: "SignIn", bundle: nil)
        let enterVC = signSB.instantiateViewController(identifier: "EnterViewController") as! EnterViewController
        navigationController?.pushViewController(enterVC, animated: true)
    }
    
    func setUI(){
        settingTableView.delegate = self
        settingTableView.dataSource = self
        guestLoginBtn.layer.cornerRadius = 8.0
    }
    
    func pushView(_ vc: String){
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: vc) else { return }
        self.navigationController?.pushViewController(detailVC, animated: true)
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



