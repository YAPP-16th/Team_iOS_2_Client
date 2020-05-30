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
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteBtn(_ sender: UIButton) {
        inviteSetting()
    }
    @IBAction func quitMemberBtn(_ sender: UIButton) {
        switchQuitHideView(value: false)
    }
    @IBOutlet weak var albumPasswordCopyBtn: UIButton!
    @IBOutlet weak var albumPasswordUploadBtn: UIButton!
    
    
    var albumUid: Int = 0
    var infoAlbum : album?
    
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
    func defaultSetting(){
        guard let data = infoAlbum else {return}
        albumCoverImageView.image = getCoverByUid(value: data.cover.uid)
        albumNameLabel.text = data.name
        albumDateLabel.text = "\(data.created_at.split(separator: "T").first!)  ~ \(data.endDate)"
        albumCountLabel.text = "\(data.photoLimit)"
        albumLayoutLabel.text = getLayoutByUid(value: data.layoutUid).layoutName
        
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        
        albumPasswordCopyBtn.addTarget(self, action: #selector(touchPasswordCopyBtn), for: .touchUpInside)
        albumPasswordUploadBtn.addTarget(self, action: #selector(touchPasswordUploadBtn), for: .touchUpInside)
    }
    
    func hideViewSetting(){
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
  
    
    func removedAlert(){
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
    func networkSetting(){
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
    func networkAddUser(username: String, userrole : String, useruid: Int){
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
    func networkRemoveUser(userName : String, userRole : String, userUid: Int){
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
    
    func networkGetPassword(){
        AlbumService.shared.albumGetPassword(uid: albumUid, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                    case 200 :
                        guard let data = response.data else {return}
                        guard let value = try? JSONDecoder().decode(albumPassword.self, from: data) else {return}
                        UIPasteboard.general.string = value.password
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
    
    func networkUpdatePassword(){
        AlbumService.shared.albumUploadPasswrod(uid: albumUid, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                    case 200 :
                        guard let data = response.data else {return}
                        guard let value = try? JSONDecoder().decode(albumPassword.self, from: data) else {return}
                        UIPasteboard.general.string = value.password
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
    @objc func touchHideCancleBtn(){
        switchQuitHideView(value: true)
    }
    
    @objc func touchHideCompleteBtn(){
        switchQuitHideView(value: true)
        memberTableView.reloadData()
    }
    
    @objc func touchMemberDeleteBtn(_ sender : UIButton){
        let item = userArray[sender.tag]
        networkRemoveUser(userName: item.name, userRole: item.role, userUid: item.userUid)
        userArray.remove(at: sender.tag)
    }
    
    @objc func touchPasswordCopyBtn(){
        networkGetPassword()
    }
    
    @objc func touchPasswordUploadBtn(){
        networkUpdatePassword()
    }
}


extension AlbumInfoVC {
    func inviteSetting() {
        let templeteId = "24532"
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templeteId, templateArgs: nil, success: {(warningMsg, argumentMsg) in
            print("warning message : \(String(describing: warningMsg))")
            print("argument message : \(String(describing: argumentMsg))")
        }, failure: {(error) in
            print("error \(error)")
        })
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
            cell.memberDeleteBtn.isEnabled = false
            cell.memberDeleteBtn.isHidden = true
        } else {
            cell.memberImageView.image = UIImage(named: "iconMembers")
            cell.memberNameLabel.text = userNameArray[indexPath.row]
            cell.memberDeleteBtn.isEnabled = true
        }
        cell.memberDeleteBtn.tag = indexPath.row
        cell.memberDeleteBtn.addTarget(self, action: #selector(touchMemberDeleteBtn(_:)), for: .touchUpInside)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


