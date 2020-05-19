//
//  FindEmailResult.swift
//  90's
//
//  Created by 홍정민 on 2020/05/19.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

struct FindEmailResult : Codable {
    let email:String
    let name:String
}

struct FindEmailErrResult: Codable{
    let status: Int
    let error: String
    let message :String
}
