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

struct album : Codable {
    var complete : Bool
    var count : Int
    var created_at : String
    var endDate : String
    var layoutUid : Int
    var name : String
    var photoLimit : Int
    var uid : Int
    var updated_at : String
}


// post
struct AlbumGetResult : Codable {
    var complete : Bool
    var count : Int
    var created_at : String
    var endDate : String
    var layoutUid : Int
    var name : String
    var photoLimit : Int
    var uid : Int
    var updated_at : String
}

// post
struct AlbumCreateData : Codable {
    var endDate : String
    var layoutUid : Int
    var name : String
    var photoLimit : Int
}

// post
struct AlbumCreateResult : Codable {
    var complete : Bool
    var count : Int
    var created_at : String
    var endDate : String
    var layoutUid : Int
    var name : String
    var photoLimit : Int
    var uid : Int
    var updated_at : String
}

// post
struct AlbumAddUserData : Codable {
    var albumUid : Int
    var role : String
    var userUid : Int
}

// post
struct AlbumAddUserResult : Codable {
    var result : Bool
}

// get
struct AlbumGetAlbumsResult : Codable {
    var result : Array<album>
}

// post
struct PhotoDownloadData : Codable {
    var albumUid : Int
    var photoUid : Int
}

// post
struct PhotoGetPhotoData : Codable {
    var albumUid : Int
    var photoUid : Int
}

// post
struct PhotoUploadData : Codable {
    var albumUid : Int
    var image : String // file
    var photoOrder : Int // 사진 순서
}
