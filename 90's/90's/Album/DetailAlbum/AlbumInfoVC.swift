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
        print("Touch")
        inviteSetting()
    }
    @IBAction func quitMemberBtn(_ sender: UIButton) {
        switchHideView(value: false)
    }
    
    private var ownerArray : [String] = ["dayeun"]
    private var personArray : [String] = ["dayeun","KyungJin","Jeongmin"]
    var albumIndex : Int = 0
    var initialize : Bool = false
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if hideView.isHidden == false {
            if touch.view != self.hideWhiteView {
                switchHideView(value: true)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSetting()
        
        
    }
}


extension AlbumInfoVC : albumInfoDeleteProtocol {
    func defaultSetting(){
        let album =  AlbumDatabase.arrayList[albumIndex]
        albumCoverImageView.image = album.photos[0]
        albumNameLabel.text = album.albumName
        albumDateLabel.text = "\(album.albumStartDate!)  ~  \(album.albumEndDate!)"
        albumCountLabel.text = String(album.albumMaxCount)
        albumLayoutLabel.text = album.albumLayout.layoutName
        
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


// 오너의 경우 헤더뷰로 하나 넣기
extension AlbumInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membertablecell", for: indexPath) as! MemberTableViewCell
        if initialize == false {
            cell.memberImageView.image = UIImage(named: "iconOwner")
            cell.memberNameLabel.text = personArray[indexPath.row]
            cell.memberDeleteBtn.isEnabled = false
            cell.memberDeleteBtn.isHidden = true
            initialize = true
        } else {
            cell.memberImageView.image = UIImage(named: "iconMembers")
            cell.memberNameLabel.text = personArray[indexPath.row]
            cell.memberDeleteBtn.isEnabled = true
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


