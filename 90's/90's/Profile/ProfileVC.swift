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
    
    let settingArray : [String] = ["주문 내역", "내 정보 관리", "FAQ", "설정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension ProfileVC {
    func defaultSetting(){
        settingTableView.delegate = self
        settingTableView.dataSource = self

        guestViewSetting()
    }
    
    func guestViewSetting(){
        guestLabel.text = "로그인을 하고\n나만의 앨범을 만들어보세요"
        guestLoginBtn.addTarget(self, action: #selector(touchLoginBtn), for: .touchUpInside)
    }
    
    func profileViewSetting(){
        profileName.text = UserDatabase.MemberList[0].name
        profileEmail.text = UserDatabase.MemberList[0].email
        profileImage.image = UserDatabase.MemberList[0].picture
        profileImage.layer.cornerRadius = 15
        
        profileAlbumCount.text = "내 앨범 \(AlbumDatabase.arrayList.count)개"
        profilePrintCount.text = "인화 0건"
    }
}


extension ProfileVC {
    @objc func touchLoginBtn(){
        let signupStroyboard = UIStoryboard(name: "SginUp", bundle: nil)
        let signupVC = signupStroyboard.instantiateViewController(withIdentifier: "TermVC") as! TermViewController // identifier 붙어야 함
        self.present(signupVC, animated: true, completion: nil)
    }
}


extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profiletablecell", for: indexPath) as! ProfileTableViewCell
        cell.settingLabel.text = settingArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
