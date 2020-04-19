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
        let number = AlbumDatabase.arrayList.count
        let user = "temp user"
        let newAlbum = Album(user : [user], albumIndex: number, albumName: self.albumName, albumStartDate: self.albumStartDate, albumEndDate: self.albumEndDate, albumLayout: self.albumLayout, albumMaxCount: self.albumMaxCount + 1, photo: [])
        newAlbum.photos.append(photo)
        AlbumDatabase.arrayList.append(newAlbum)
        mainProtocol?.reloadView()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    var isAllDataSettle : Bool = false
    
    var albumName : String!
    var albumStartDate : String!
    var albumEndDate : String!
    var albumMaxCount : Int!
    var photo : UIImage!
    var albumLayout : AlbumLayout!
    
    var mainProtocol : AlbumMainVCProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Setting()
    }
}


extension AlbumCompleteVC {
    func Setting(){
        albumCompleteBtn.layer.cornerRadius = 10
        albumLayoutLabel.text = layoutSetting()
        albumImageView.image = photo
        albumTitleLabel.text = albumName
        albumDateLabel.text = "\(albumStartDate!)  ~  \(albumEndDate!)"
        albumCountLabel.text = String(albumMaxCount)
        askLabel.text = "이 앨범으로 결정하시겠습니까?\n한 번 앨범을 만들면 수정이 불가능 합니다"
    }
    
    func layoutSetting() -> String {
        switch albumLayout {
        case .Polaroid : return "Polaroid"
        case .Mini : return "Mini"
        case .Memory : return "Memory"
        case .Portrab : return "Portrab"
        case .Portraw : return "Portraw"
        case .Filmroll : return "Filmroll"
        case .Tape : return "Tape"
        default: return "None"
        }
    }
}
