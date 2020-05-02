//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCompleteVC: UIViewController {
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
        //createAlbumService()
        getAlbumService()
        mainProtocol?.reloadView()
        self.navigationController?.popToRootViewController(animated: true)
    }
    var albumLayout : AlbumLayout!
    var mainProtocol : AlbumMainVCProtocol?
    var isAllDataSettle : Bool = false
    
    var albumName : String!
    var albumStartDate : String!
    var albumEndDate : String!
    var albumMaxCount : Int!
    var photo : UIImage!
    var imageName : String!

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
        albumLayoutLabel.text = layoutSetting(albumLayout: albumLayout)
        albumImageView.image = photo
        albumTitleLabel.text = albumName
        albumDateLabel.text = "\(albumStartDate!)  ~  \(albumEndDate!)"
        albumCountLabel.text = String(albumMaxCount)
        askLabel.text = "이 앨범으로 결정하시겠습니까?\n한 번 앨범을 만들면 수정이 불가능 합니다"
    }
    
    func getAlbumService(){
        AlbumService.shared.getAlbum(completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode(getAlbumResult.self, from: data) else {return}
                    print("Get Album data : \(value)")
                case 401...444 :
                    print("forbidden access in \(status)")
                default:
                    return
                }
            }
        })
    }
    
    func createAlbumService(){
        AlbumService.shared.createAlbum(endDate: albumEndDate, layoutUid: albumLayout.layoutUid, name: albumName, photoLimit: albumMaxCount, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let uid = try? JSONDecoder().decode(CreateAlbumResult.self, from: data) else {return}
                    let value = uid.albumUid
                    print("Create Album complete : \(value)")
                case 401...404 :
                    print("forbidden access in \(status)")
                default :
                    return
                }
            }
        })
    }
    
    func sendCoverImageService(uid : Int){
        AlbumService.shared.photoUpload(albumUid: String(uid), image: photo, imageName: imageName, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    print("Send Cover Image Complete")
                case 401...404 :
                    print("forbidden access in \(status)")
                default :
                    return
                }
            }
        })
    }
}
