//
//  TermCell.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class TermCell: UITableViewCell {
    
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var termTitle: UILabel!
    var clickDelegate: ClickDelegate!
    var isClicked : Bool = false {
        didSet {
            if(isClicked){
                agreeBtn.backgroundColor = UIColor.black } else { agreeBtn.backgroundColor = UIColor.gray}
        }
    }
    
    
    @IBAction func clickAgreeBtn(_ sender: Any) {
        self.isClicked = !isClicked
        self.clickDelegate.cellClick(isClicked : self.isClicked)
    }
    
}
