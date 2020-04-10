//
//  Album.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//


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
        self.photos = [UIImage(named: "layoutimg1")!, UIImage(named: "layoutimg2")!, UIImage(named: "layoutimg3")!, UIImage(named: "layoutimg4")!, UIImage(named: "layoutimg5")!, UIImage(named: "layoutimg6")!]
    }
}

class AlbumModel {
    var arrayList : [Album] = []
    
    func defaultData() -> Array<Album> {
        let stock = Album(albumIndex: 0, albumName: "default data", albumStartDate : "2020.04.10", albumEndDate : "2020.06.28", albumCover : UIImage(named: "cover1"), albumLayout: 1, albumMaxCount: 30, photo: [])
        let stock2 = Album(albumIndex: 1, albumName: "default data2", albumStartDate : "2020.04.10", albumEndDate : "2020.05.28", albumCover : UIImage(named: "cover2"), albumLayout: 1, albumMaxCount: 10, photo: [])
        let stock3 = Album(albumIndex: 2, albumName: "default data3", albumStartDate : "2020.04.10", albumEndDate : "2020.09.08", albumCover : UIImage(named: "cover3"), albumLayout: 1, albumMaxCount: 6, photo: [])
        return [stock, stock2, stock3]
    }
    
    init() {
        arrayList = defaultData()
    }
}
