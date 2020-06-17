//
//  AlbumInfoVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol albumInfoDeleteProtocol {
    func switchQuitHideView(value : Bool)
}

class AlbumInfoVC: UIViewController {
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideLabel: UILabel!
    @IBOutlet weak var hideCancleBtn: UIButton!
    @IBOutlet weak var hideCompleteBtn: UIButton!
    @IBOutlet weak var hideWhiteViewBottom: NSLayoutConstraint!
    @IBOutlet weak var hideWhiteView: UIView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumDateLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var albumLayoutLabel: UILabel!
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var memberTableConst: NSLayoutConstraint!
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteBtn(_ sender: UIButton) {
        inviteSetting()
    }
    @IBAction func quitMemberBtn(_ sender: UIButton) {
        let owner = userArray.first!
        networkRemoveUser(userName: owner.name, userRole: owner.role, userUid: owner.userUid)
        mainProtocol?.AlbumMainreloadView()
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var albumPasswordCopyBtn: UIButton!
    @IBOutlet weak var albumPasswordUploadBtn: UIButton!
    
    var albumUid: Int = 0
    var infoAlbum : album?
    var mainProtocol : AlbumMainVCProtocol?
    
    var userArray : [AlbumUserData] = []
    var roleArray : [String] = []
    var userUidArray : [Int] = []
    var userNameArray : [String] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if hideView.isHidden == false {
            if touch.view != self.hideWhiteView {
                switchQuitHideView(value: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
        hideViewSetting()
    }
}


extension AlbumInfoVC : albumInfoDeleteProtocol {
    private func defaultSetting(){
        guard let data = infoAlbum else {return}
        albumCoverImageView.image = getCoverByUid(value: data.cover.uid)
        albumNameLabel.text = data.name
        albumDateLabel.text = "\(data.created_at.split(separator: "T").first!)  ~ \(data.endDate)"
        albumCountLabel.text = "\(data.photoLimit)"
        albumLayoutLabel.text = getLayoutByUid(value: data.layoutUid).layoutName
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        
        albumPasswordCopyBtn.layer.borderWidth = 1.0
        albumPasswordCopyBtn.layer.borderColor = UIColor.lightGray.cgColor
        albumPasswordUploadBtn.layer.borderWidth = 1.0
        albumPasswordUploadBtn.layer.borderColor = UIColor.lightGray.cgColor
        albumPasswordCopyBtn.addTarget(self, action: #selector(touchPasswordCopyBtn), for: .touchUpInside)
        albumPasswordUploadBtn.addTarget(self, action: #selector(touchPasswordUploadBtn), for: .touchUpInside)
    }
    
    private func hideViewSetting(){
        hideLabel.text = "앨범에서 해당 멤버를\n삭제하시겠습니까?"
        hideCancleBtn.addTarget(self, action: #selector(touchHideCancleBtn), for: .touchUpInside)
        hideCompleteBtn.addTarget(self, action: #selector(touchHideCompleteBtn), for: .touchUpInside)
    }
    
    func switchQuitHideView(value : Bool){
        switch value {
        case true :
            hideWhiteViewBottom.constant = -hideWhiteView.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            hideView.isHidden = true
        case false :
            hideWhiteViewBottom.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            hideView.isHidden = false
        }
    }
  
    
    private func removedAlert(){
        let alert = UIAlertController(title: "멤버 삭제", message: "멤버 삭제 완료!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true){
            self.memberTableView.reloadData()
        }
    }
}


extension AlbumInfoVC {
    // 멤버 목록 가져오기
    private func networkSetting(){
        AlbumService.shared.albumGetOwners(uid:albumUid, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode([AlbumUserData].self, from: data) else {return}
                    self.userArray = value.map { $0 }
                    self.roleArray = self.userArray.map { $0.role }
                    self.userUidArray = self.userArray.map { $0.userUid }
                    self.userNameArray = self.userArray.map { $0.name }
                    self.memberTableView.reloadData()
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumInfo - getOwners")
                default:
                    return
                }
            }
        })
    }
    
    // 멤버 추가
    private func networkAddUser(username: String, userrole : String, useruid: Int){
        AlbumService.shared.albumAddUser(albumUid: albumUid, name: username, role: userrole, userUid: useruid, completion: { response in
            
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    self.memberTableView.reloadData()
                    print("albumInfo - add User complete")
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumInfo - addUser")
                default:
                    return
                }
            }
        })
    }
    
    // 멤버 삭제
    private func networkRemoveUser(userName : String, userRole : String, userUid: Int){
        AlbumService.shared.albumRemoveUser(albumUid: albumUid, role: userRole, name: userName, userUid: userUid, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    self.removedAlert()
                    self.memberTableView.reloadData()
                    print("removed user")
                case 401 :
                    print("\(status) : bad request, no warning in Server")
                case 404 :
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumInfo - removeUser")
                default:
                    return
                }
            }
        })
    }
    
    private func networkGetPassword(){
        AlbumService.shared.albumGetPassword(uid: albumUid, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                    case 200 :
                        print("get password success")
                    case 401 :
                        print("\(status) : bad request, no warning in Server")
                    case 404 :
                        print("\(status) : Not found, no address")
                    case 500 :
                        print("\(status) : Server error in AlbumInfo - getPassword")
                    default:
                        return
                }
            }
        })
    }
    
    private func networkUpdatePassword(){
        AlbumService.shared.albumUploadPassword(uid: albumUid, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                    case 200 :
                        print("upload password success")
                    case 401 :
                        print("\(status) : bad request, no warning in Server")
                    case 404 :
                        print("\(status) : Not found, no address")
                    case 500 :
                        print("\(status) : Server error in AlbumInfo - uploadPassword")
                    default:
                        return
                }
            }
        })
    }
}


extension AlbumInfoVC {
    @objc private func touchHideCancleBtn(){
        switchQuitHideView(value: true)
    }
    
    @objc private func touchHideCompleteBtn(){
        switchQuitHideView(value: true)
        memberTableView.reloadData()
    }
    
    @objc private func touchMemberDeleteBtn(_ sender : UIButton){
        let item = userArray[sender.tag]
        networkRemoveUser(userName: item.name, userRole: item.role, userUid: item.userUid)
        userArray.remove(at: sender.tag)
    }
    
    @objc private func touchPasswordCopyBtn(){
        networkGetPassword()
        copyPasswordAlert()
    }
    
    @objc private func touchPasswordUploadBtn(){
        networkUpdatePassword()
        requestNewPasswordAlert()
    }
}


extension AlbumInfoVC {
    private func inviteSetting() {
        let templeteId = "24532"
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templeteId, templateArgs: nil, success: {(warningMsg, argumentMsg) in
            print("warning message : \(String(describing: warningMsg))")
            print("argument message : \(String(describing: argumentMsg))")
        }, failure: {(error) in
            print("error \(error)")
        })
    }
    
    private func copyPasswordAlert(){
        let alert = UIAlertController(title: "비밀번호 복사", message: "비밀번호가 클립보드에 복사 되었습니다!", preferredStyle: UIAlertController.Style.alert)
        let accept = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(accept)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func requestNewPasswordAlert(){
        let alert = UIAlertController(title: "비밀번호 재발급", message: "재발급된 비밀번호가 클립보드에 복사 되었습니다!", preferredStyle: UIAlertController.Style.alert)
        let accept = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(accept)
        self.present(alert, animated: true, completion: nil)
    }
}

// 오너의 경우 헤더뷰로 하나 넣기
extension AlbumInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userUidArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membertablecell", for: indexPath) as! MemberTableViewCell
        
        if roleArray[indexPath.row] == "ROLE_CREATOR" {
            cell.memberImageView.image = UIImage(named: "iconOwner")
            cell.memberNameLabel.text = userNameArray[indexPath.row]
            cell.memberSubLabel.text = "Owner"
            cell.memberDeleteBtn.isEnabled = false
            cell.memberDeleteBtn.isHidden = true
        } else {
            cell.memberImageView.image = UIImage(named: "iconMembers")
            cell.memberNameLabel.text = userNameArray[indexPath.row]
            cell.memberSubLabel.text = "Member"
            cell.memberDeleteBtn.isEnabled = true
            cell.memberDeleteBtn.isHidden = false
        }
        
        cell.memberDeleteBtn.tag = indexPath.row
        cell.memberDeleteBtn.addTarget(self, action: #selector(touchMemberDeleteBtn(_:)), for: .touchUpInside)
        
        self.memberTableConst.constant = self.memberTableView.contentSize.height + 35 
        self.memberTableView.layoutIfNeeded()
        
        return cell
    }
}


