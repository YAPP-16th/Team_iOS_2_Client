//
//  AlbumInfoVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol albumInfoDeleteProtocol {
    func switchHideView(value : Bool)
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
        switchHideView(value: false)
    }
    
    var albumUid: Int = 0
    
    var infoAlbum : album?
    var infoCoverImage : UIImage?

    var roleArray : [String] = []
    var userUidArray : [Int] = []
    var userNameArray : [String] = []
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if hideView.isHidden == false {
            if touch.view != self.hideWhiteView {
                switchHideView(value: true)
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
    }
}


extension AlbumInfoVC : albumInfoDeleteProtocol {
    func defaultSetting(){
        guard let data = infoAlbum else {return}
        albumCoverImageView.image = infoCoverImage
        albumNameLabel.text = data.name
        albumDateLabel.text = "\(data.created_at.split(separator: "T").first!)  ~ \(data.endDate)"
        albumCountLabel.text = "\(data.photoLimit - 1)"
        albumLayoutLabel.text = getLayoutByUid(value: data.layoutUid).layoutName
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    
    func hideViewSetting(){
        hideLabel.text = "앨범에서 해당 멤버를\n삭제하시겠습니까?"
        hideCancleBtn.addTarget(self, action: #selector(touchHideCancleBtn), for: .touchUpInside)
        hideCompleteBtn.addTarget(self, action: #selector(touchHideCompleteBtn), for: .touchUpInside)
    }
    
    func switchHideView(value : Bool){
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
        self.present(alert, animated: true)
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
                    guard let value = try? JSONDecoder().decode([AlbumGetOwnersResult].self, from: data) else {return}
                    
                    self.roleArray = value.map { $0.role }
                    self.userUidArray = value.map { $0.userUid }
                    self.userNameArray = value.map { $0.name }
                    self.memberTableView.reloadData()
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in albumInfo - getowners")
                default:
                    return
                }
            }
        })
    }
    
    // 멤버 삭제
    func networkRemoveUser(uid : Int, userRole : String){
        AlbumService.shared.albumRemoveUser(albumUid: albumUid, role: userRole, userUid: uid, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    self.removedAlert()
                    print("removed user success")
                case 401 :
                    print("\(status) : bad request, no warning in Server")
                case 404 :
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in albumInfo - getowners")
                default:
                    return
                }
            }
        })
    }
}


extension AlbumInfoVC {
    @objc func touchHideCancleBtn(){
        switchHideView(value: true)
    }
    
    @objc func touchHideCompleteBtn(){
        // 서버통신 - 멤버 삭제
        switchHideView(value: true)
        memberTableView.reloadData()
    }
}


extension AlbumInfoVC : inviteProtocol {
    func inviteSetting() {
            let templeteId = "24532";
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
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


