//
//  LeaveReasonViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/23.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol clickReasonDelegate: NSObjectProtocol {
    func clickReason(_ indexPath : IndexPath)
}

class LeaveReasonViewController: UIViewController {
    @IBOutlet weak var reasonTableView: UITableView!
    @IBOutlet weak var leaveBtn:UIButton!
    var reasonClickFlag = false
    
    let reasonArray = ["사용하기 어려워요", "오류가 많아서 불편해요", "흥미가 없어졌어요","기타"]
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func clickCloseBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //탈퇴 서버 통신
    @IBAction func clickFinalLeaveBtn(_ sender: Any) {
        leave()
    }
    
    func setUI(){
        reasonTableView.delegate = self
        reasonTableView.dataSource = self
        leaveBtn.isEnabled = false
        leaveBtn.layer.cornerRadius = 8.0
    }
    
    func leave(){
        guard let token = UserDefaults.standard.string(forKey: "jwt") else { return }
        LeaveService.shared.leave(token: token, completion: {
            status in
                switch status {
                case 200:
                    //기존의 정보 다 삭제(자체로그인 시 저장하는 정보 : email, password, social, jwt)
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "social")
                    UserDefaults.standard.removeObject(forKey: "jwt")
                    UserDefaults.standard.removeObject(forKey: "isAppleId")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.switchEnterView()
                    break
                case 401...500:
                    self.showErrAlert()
                    break
                default:
                    return
                }
        })
    }
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "회원탈퇴 불가", preferredStyle: .alert)
              let action = UIAlertAction(title: "확인", style: .default)
              alert.addAction(action)
              self.present(alert, animated: true)
    }
    
}



extension LeaveReasonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonCell") as! ReasonCell
        cell.indexPath = indexPath
        
        if let selectedIndex = self.selectedIndexPath {
            if(selectedIndex != indexPath) {
                cell.isClicked = false
            }else {
                cell.isClicked = true
            }
        }
        
        cell.clickReasonDelegate = self
        cell.reasonLabel.text = reasonArray[indexPath.row]
        return cell
    }
    
    
}

extension LeaveReasonViewController: clickReasonDelegate {
    func clickReason(_ indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        if(!reasonClickFlag){
            reasonClickFlag = true
            self.leaveBtn.backgroundColor =  UIColor(red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
            self.leaveBtn.isEnabled = true
        }
        reasonTableView.reloadData()
    }
    
    
}
