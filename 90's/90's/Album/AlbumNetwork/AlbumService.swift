//
//  AlbumService.swift
//  90's
//
//  Created by 성다연 on 2020/04/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

struct album : Codable {
    var uid : Int
    var name : String
    var photoLimit : Int
    var layoutUid : Int
    var count : Int // 앨범 낡기
//    var orderStatus : n
    var endDate : String
    var created_at : String
    var updated_at : String
    var complete : Bool
}

// post, albumGetAlbum 결과
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
struct AlbumGetOwnersResult : Codable {
    var albumUid : Int
    var name : String
    var userUid : Int
    var role : String
}

// post
struct PhotoDownloadData : Codable {
    var albumUid : Int
    var photoUid : Int
}

struct PhotoDownloadResult : Codable {
    var photoUrlString : String
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
