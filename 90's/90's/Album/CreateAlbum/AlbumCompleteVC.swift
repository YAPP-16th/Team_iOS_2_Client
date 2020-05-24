//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCompleteVC: UIViewController {
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var albumCompleteBtn: UIButton!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumDateLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var albumLayoutLabel: UILabel!
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func completeBtn(_ sender: UIButton) {
        self.createAlbumService()
        mainProtocol?.AlbumMainreloadView()
        self.navigationController?.popToRootViewController(animated: true)
    }
    var albumLayout : AlbumLayout!
    var mainProtocol : AlbumMainVCProtocol?
    var isAllDataSettle : Bool = false
    
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
    func defaultSetting(){
        albumCompleteBtn.layer.cornerRadius = 10
        albumLayoutLabel.text = albumLayout.layoutName
        albumImageView.image = photo
        albumTitleLabel.text = albumName
        albumDateLabel.text = "\(albumStartDate!)  ~  \(albumEndDate!)"
        albumCountLabel.text = "\(albumMaxCount!)"
        askLabel.text = "이 앨범으로 결정하시겠습니까?\n한 번 앨범을 만들면 수정이 불가능 합니다"
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
                    //self.sendCoverImageService(uid: uid.uid)
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
    
//    func sendCoverImageService(uid : Int){
//        AlbumService.shared.photoUpload(albumUid: uid, image: [photo!], imageName: albumLayout.layoutName, completion: {
//            response in
//            if let status = response.response?.statusCode {
//                switch status {
//                case 200 :
//                    print("album create : upload cover image complete")
//                case 401:
//                    print("\(status) : bad request, no warning in Server")
//                case 404:
//                    print("\(status) : Not found, no address")
//                case 500 :
//                    print("\(status) : Server error in AlbumComplete - photoUpload")
//                default :
//                    return
//                }
//            }
//        })
//    }
}
