//
//  ManageInfoViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ManageInfoViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    var isDefault:Bool!
    var authenType:String!
    var infoList = ["이메일 변경", "비밀번호 변경", "전화번호 변경"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }
    
}

extension ManageInfoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        cell.selectionStyle = .none //셀 선택 시 선택 이펙트 삭제하기
        cell.infoNameLabel.text = infoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        authenType = self.infoList[indexPath.row]
        //디폴트 유저이면 디폴트 화면으로
        //일반 유저이면서 Social = true이면 소셜 화면으로
        //위의 두 케이스가 아니라면 인증화면으로
         
         let social = UserDefaults.standard.bool(forKey: "social")
        
        if(isDefault) {
            let defaultVC = storyboard?.instantiateViewController(withIdentifier: "DefaultUserViewController") as! DefaultUserViewController
            defaultVC.titleStr = self.authenType
            self.navigationController?.pushViewController(defaultVC, animated: true)
        }else if social {
            let snsVC = storyboard?.instantiateViewController(withIdentifier: "SNSViewController") as! SNSViewController
            snsVC.titleStr = self.authenType
            self.navigationController?.pushViewController(snsVC, animated: true)
        }else {
            let profileAuthenVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAuthenViewController") as! ProfileAuthenViewController
               profileAuthenVC.authenType = infoList[indexPath.row]
               self.navigationController?.pushViewController(profileAuthenVC, animated:true)
        }
   
    }
    
}
