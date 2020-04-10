//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCompleteVC: UIViewController {
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var askLabel: UILabel!
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumDateLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    
    @IBAction func cancleBtn(_ sender: UIButton) {
        // 이 버튼 용도 질문 (아예 처음 화면으로 가는건가요?)
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var isAllDataSettle : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Setting()
    }
}


extension AlbumCompleteVC {
    func Setting(){
        askLabel.text = "이 앨범으로 결정하시겠습니까?\n한 번 앨범을 만들면 수정이 불가능 합니다"
        
    }
}
