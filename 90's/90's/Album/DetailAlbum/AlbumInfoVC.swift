//
//  AlbumInfoVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumInfoVC: UIViewController {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumDateLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var memberTableView: UITableView!
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func inviteBtn(_ sender: UIButton) {
        let templeteId = "23118";
        
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templeteId, templateArgs: nil, success: {(warningMsg, argumentMsg) in
            print("warning message : \(String(describing: warningMsg))")
            print("argument message : \(String(describing: argumentMsg))")
        }, failure: {(error) in
            print("error \(error)")
        })
    }
    @IBAction func quitMemberBtn(_ sender: UIButton) {
    }
    
    
    private var memberArray : [String] = ["dayeun"]
    var albumIndex : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumInfoVC {
    func defaultSetting(){
        let album = AlbumDatabase.arrayList[albumIndex]
        albumCoverImageView.image = album.albumCover
        albumNameLabel.text = album.albumName
        albumDateLabel.text = "\(album.albumStartDate!)  ~  \(album.albumEndDate!)"
        albumCountLabel.text = String(album.albumMaxCount)
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
}


// 오너의 경우 헤더뷰로 하나 넣기
extension AlbumInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membertablecell", for: indexPath) as! MemberTableViewCell
        cell.memberImageView.image = UIImage(named: "inviteimage")
        cell.memberNameLabel.text = memberArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
