//
//  Album.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//


let AlbumDatabase : AlbumModel = AlbumModel()
let LayoutDatabase : LayoutModel = LayoutModel()

class Album {
    var user : [String]
    var albumIndex : Int!
    var albumName : String!
    var albumStartDate : String?
    var albumEndDate : String?
    var albumLayout : AlbumLayout!
    var albumMaxCount : Int!
    var photos : [UIImage]
    
    init(user: [String],albumIndex: Int, albumName: String, albumStartDate : String?, albumEndDate : String?, albumLayout: AlbumLayout, albumMaxCount: Int, photo: [UIImage]) {
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
    
    func defaultData() -> Array<Album> {
        let stock = Album(user: ["test@gmail.com"], albumIndex: 0, albumName: "행복한 앨범", albumStartDate: "2020-04-26", albumEndDate: "2020-05-21", albumLayout: .Portrab, albumMaxCount: 5, photo: [])
        let stock2 = Album(user: ["test1@gmail.com"], albumIndex: 1, albumName: "여행 기록", albumStartDate: "2020-04-25", albumEndDate: "2020-06-11", albumLayout: .Filmroll, albumMaxCount: 10, photo: [])
        return [stock, stock2]
    }
    
    init() {
        arrayList = defaultData()
        arrayList[0].photos.append(UIImage(named: "fellinlove")!)
        arrayList[0].photos.append(UIImage(named: "husky")!)
        arrayList[1].photos.append(UIImage(named: "dreamy2121")!)
        arrayList[1].photos.append(UIImage(named: "husky")!)
    }
}



enum AlbumLayout {
    case Polaroid
    case Mini
    case Memory
    case Portrab
    case Tape
    case Portraw
    case Filmroll
    
    var image : UIImage {
        switch self {
        case .Polaroid : return UIImage(named: "framePolaroid")!
        case .Mini : return UIImage(named: "frameMini")!
        case .Memory : return UIImage(named: "frameMemory")!
        case .Portrab : return UIImage(named: "framePortrab")!
        case .Tape : return UIImage(named: "frameTape")!
        case .Portraw : return UIImage(named: "framePortraw")!
        case .Filmroll : return UIImage(named: "frameFilmroll")!
        }
    }
    
    var size : CGSize {
        switch self {
        case .Polaroid : return CGSize(width: 184, height: 213)
        case .Mini : return CGSize(width: 183, height: 249)
        case .Memory : return CGSize(width: 261, height: 236)
        case .Portrab : return CGSize(width: 270, height: 325)
        case .Tape : return CGSize(width: 326, height: 336)
        case .Portraw : return CGSize(width: 356, height: 218)
        case .Filmroll : return CGSize(width: 286, height: 382)
        }
    }
}

class LayoutModel {
    var arrayList : [AlbumLayout] = [.Polaroid, .Mini, .Memory, .Portrab, .Tape, .Portraw, .Filmroll]
}
