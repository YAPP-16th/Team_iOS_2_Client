//
//  PrintListTableViewCell.swift
//  90's
//
//  Created by 조경진 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol ClickActionDelegate {
    
    func didClickedLink(index: Int)

}


class PrintListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumDate: UILabel!
    @IBOutlet weak var pictureCount: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    
    var delegate : ClickActionDelegate?
    var currentIndex: Int?
    var state: Int? = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        orderBtn.layer.cornerRadius = 8
        // Initialization code
    }
    
    @IBAction func didClick(_ sender: Any) {
        self.delegate?.didClickedLink(index: currentIndex ?? 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
