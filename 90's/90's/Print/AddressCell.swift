//
//  AddressCell.swift
//  90's
//
//  Created by 홍정민 on 2020/05/15.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

public struct Address  {
    var address : String
    var roadAddress : String
    var buildingName : String
    var zipCode : String
}

class AddressCell: UITableViewCell {
    @IBOutlet weak var postNumLabel: UILabel!
    @IBOutlet weak var roadAddressLabel: UILabel!
    @IBOutlet weak var numberAddressLabel: UILabel!
}
