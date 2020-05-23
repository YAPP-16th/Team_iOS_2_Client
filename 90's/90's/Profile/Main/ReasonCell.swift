//
//  ReasonCell.swift
//  90's
//
//  Created by 홍정민 on 2020/05/23.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ReasonCell: UITableViewCell {
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var reasonLabel: UILabel!
    
    var indexPath:IndexPath!
    var clickReasonDelegate: clickReasonDelegate!
    
    var isClicked : Bool = false {
        didSet {
            if(isClicked){
                agreeBtn.setBackgroundImage(UIImage(named: "checkboxInact"), for: .normal) } else { agreeBtn.setBackgroundImage(UIImage(named: "checkboxgray"), for: .normal)}
        }
    }
    
    @IBAction func clickAgreeBtn(_ sender: Any) {
        self.isClicked = !isClicked
        self.clickReasonDelegate.clickReason(self.indexPath)
    }
    
    
}
