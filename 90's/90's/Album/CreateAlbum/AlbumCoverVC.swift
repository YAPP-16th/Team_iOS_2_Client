//
//  AlbumCoverVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCoverVC: UIViewController {
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverCollectionView: UICollectionView!
    
    @IBAction func touchBackBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
