//
//  AlbumService.swift
//  90's
//
//  Created by 성다연 on 2020/04/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation


struct Token : Codable {
    var token : String?
}

// post
struct CreateAlbumData : Codable {
    var endDate : String
    var layoutUid : Int
    var name : String
    var photoLimit : Int
}

// post
struct AddAlbumUserData : Codable {
    var albumUid : Int
    var role : String
    var userUid : Int
}
