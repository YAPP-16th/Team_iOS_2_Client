//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Lottie

class AlbumCompleteVC: UIViewController {
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var albumCompleteBtn: UIButton!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumDateLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var albumLayoutLabel: UILabel!
    @IBOutlet weak var lottieView: UIView!
    
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeBtn(_ sender: UIButton) {
        self.createAlbumService()
    }
    
    var albumLayout : AlbumLayout!
    var mainProtocol : AlbumMainVCProtocol?
    
    var albumName : String!
    var albumStartDate : String!
    var albumEndDate : String!
    var albumMaxCount : Int!
    var albumCover : Int!
    var photo : UIImage!
    var imageName : String!
    var albumUid : Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumCompleteVC {
    func playAnimation(){
        lottieView.isHidden = false
        let animationView = AnimationView(name:"complete_album")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.addSubview(animationView)
        
        animationView.topAnchor.constraint(equalTo: lottieView.topAnchor, constant: 150.0).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 434.0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: lottieView.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: lottieView.trailingAnchor).isActive = true
        animationView.layoutIfNeeded()
        
        //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
        animationView.play(completion: {
            _ in
            self.mainProtocol?.AlbumMainreloadView()
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func defaultSetting(){
        lottieView.isHidden = true
        albumCompleteBtn.isHidden = false
        albumCompleteBtn.layer.cornerRadius = 10
        albumLayoutLabel.text = albumLayout.layoutName
        albumImageView.image = photo
        albumTitleLabel.text = albumName
        albumDateLabel.text = "\(albumStartDate!)  ~  \(albumEndDate!)"
        albumCountLabel.text = "\(albumMaxCount!)"
        askLabel.text = "이 앨범으로 결정하시겠습니까?\n한 번 앨범을 만들면 수정이 불가능 합니다"
        completeLabel.textLineSpacing(firstText: "마지막으로", secondText: "앨범을 확인해 주세요")
        imageName = albumLayout.layoutName
    }
    
    func createAlbumService(){
        
        AlbumService.shared.albumCreate(endDate: albumEndDate, layoutUid: albumLayout.layoutUid, name: albumName, photoLimit: albumMaxCount, cover: albumCover, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let uid = try? JSONDecoder().decode(AlbumCreateResult.self, from: data) else {return}
                    self.albumUid = uid.uid
                    self.albumCompleteBtn.isHidden = true
                    self.playAnimation()
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumComplete - albumCreate")
                default :
                    return
                }
            }
        })
    }
}
