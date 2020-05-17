//
//  AddressResult.swift
//  90's
//
//  Created by 홍정민 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation



struct AddressResult : Codable {
    var documents: [Document]?
}

struct Document: Codable {
    var address_name: String
    var road_address: RoadAddress?
}

struct RoadAddress: Codable {
    var address_name: String
    var building_name: String
    var zone_no: String
}

