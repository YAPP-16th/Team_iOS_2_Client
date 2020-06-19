//
//  MemberTableViewCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberSubLabel: UILabel!
    @IBOutlet weak var memberDeleteBtn: UIButton!
    @IBAction func memberDeleteBtn(_ sender: UIButton) {
        infoProtocol?.switchQuitHideView(value: false)
    }
    
    var infoProtocol : albumInfoDeleteProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
