//
//  Album.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

//메인 앨범에 들어갈 클래스
let AlbumDatabase : AlbumModel = AlbumModel()


class Album {
    var albumIndex : Int!
    var albumName : String!
    var albumStartDate : String?
    var albumEndDate : String?
    var albumCover : UIImage?
    var albumLayout : Int!
    var albumMaxCount : Int!
    var photos : [UIImage]
    
    init(albumIndex: Int, albumName: String, albumStartDate : String?, albumEndDate : String?, albumCover : UIImage?, albumLayout: Int, albumMaxCount: Int, photo: [UIImage]) {
        self.albumIndex = albumIndex
        self.albumName = albumName
        self.albumStartDate = albumStartDate
        self.albumEndDate = albumEndDate
        self.albumCover = albumCover
        self.albumLayout = albumLayout
        self.albumMaxCount = albumMaxCount
        self.photos = []
    }
}

class AlbumModel {
    var arrayList : [Album] = []
}

//class Album {
//    var index : Int!
//    var isShare : Bool!
//
//    var albumName : String!
//    var startDate : String?
//    var expireDate : String?
//    var quantity : Int?
//    var selectTheme : Theme!
//    var photos : [UIImage]
//
//    init(index : Int, isShare: Bool, albumName: String, photo: [UIImage]?) {
//        self.index = index
//        self.isShare = isShare
//        self.albumName = albumName
//
//        self.photos = []
//
//        //더미값을 위한 처리(나중에 삭제 필요)
//        if let initialPhoto = photo {
//            self.photos += initialPhoto
//        }
//    }
//}
//
//class AlbumModel{
//    var albumList :[Album] = []
//
//    func defaultData() -> Array<Album> {
//        let stock = Album(index : 0, isShare :false, albumName : "test", photo: [UIImage(named: "husky")!]
//        )
//        return [stock]
//    }
//
//    init() {
//        //albumList = defaultData()
//    }
//}


