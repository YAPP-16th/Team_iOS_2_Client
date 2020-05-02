//
//  AlbumService.swift
//  90's
//
//  Created by 성다연 on 2020/04/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

let tempAlbumToken : String = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxOSIsInJvbGVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE1ODg0MDg5MjcsImV4cCI6MjIxOTEyODkyN30.mK2RJ0Ywv5c6iakOHA0_Mln46-A0ElJoHTVuzQceeZE"

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

// post
struct PhotoDownloadData : Codable {
    var albumUid : Int
    var photoUid : Int
}

// post
struct PhotoUploadData : Codable {
    var albumUid : Int
    var image : String // file
    var photoOrder : Int // 사진 순서
}
