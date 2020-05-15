//
//  ProfileResult.swift
//  90's
//
//  Created by 홍정민 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation


struct ProfileResult: Codable{
    let albumTotalCount:Int
    let albumPrintingCount:Int
    let userInfo:UserInfo
}

struct UserInfo: Codable {
    let email:String
    let name:String!
    let phoneNum:String!
}
