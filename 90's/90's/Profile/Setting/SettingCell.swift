//
//  SettingCell.swift
//  90's
//
//  Created by 홍정민 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol SwitchActionDelegate {
    
    func didClickedLink(index: Int)

}
class SettingCell: UITableViewCell {
    
    var delegate : SwitchActionDelegate?
    var currentIndex: Int?
    var state: Int? = 0
    
    @IBOutlet weak var settingNameLabel: UILabel!
    
    @IBAction func clickSwitch(_ sender: Any) {
        self.delegate?.didClickedLink(index: currentIndex ?? 0)
    }
    
}
