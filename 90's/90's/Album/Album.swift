//
//  Album.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//


let AlbumDatabase : AlbumModel = AlbumModel()

class Album {
    var user : [String]
    var albumIndex : Int!
    var albumName : String!
    var albumStartDate : String?
    var albumEndDate : String?
    var albumLayout : Int!
    var albumMaxCount : Int!
    var photos : [UIImage]
    
    init(user: [String],albumIndex: Int, albumName: String, albumStartDate : String?, albumEndDate : String?, albumLayout: Int, albumMaxCount: Int, photo: [UIImage]) {
        self.user = user
        self.albumIndex = albumIndex
        self.albumName = albumName
        self.albumStartDate = albumStartDate
        self.albumEndDate = albumEndDate
        self.albumLayout = albumLayout
        self.albumMaxCount = albumMaxCount
        self.photos = []
    }
}

class AlbumModel {
    var arrayList : [Album] = []
    
//    func defaultData() -> Array<Album> {
//        let stock = Album(user : ["dayuen"], albumIndex: 0, albumName: "default data", albumStartDate : "2020.04.10", albumEndDate : "2020.06.28", albumLayout: 1, albumMaxCount: 30, photo: [])
//        let stock2 = Album(user: ["jm"], albumIndex: 1, albumName: "default data2", albumStartDate : "2020.04.10", albumEndDate : "2020.05.28", albumLayout: 1, albumMaxCount: 10, photo: [])
//        let stock3 = Album(user : ["kj"],albumIndex: 2, albumName: "default data3", albumStartDate : "2020.04.10", albumEndDate : "2020.09.08", albumLayout: 1, albumMaxCount: 6, photo: [])
//        return [stock, stock2, stock3]
//    }
//    
//    init() {
//        arrayList = defaultData()
//        arrayList[0].photos.insert(UIImage(named: "cover1")!, at: 0)
//        arrayList[0].photos.append(UIImage(named: "layoutimg2")!)
//        arrayList[0].photos.append(UIImage(named: "layoutimg3")!)
//        arrayList[0].photos.append(UIImage(named: "layoutimg4")!)
//        arrayList[0].photos.append(UIImage(named: "layoutimg5")!)
//        arrayList[1].photos.insert(UIImage(named: "cover2")!, at: 0)
//        arrayList[2].photos.insert(UIImage(named: "cover3")!, at: 0)
//    }
}
