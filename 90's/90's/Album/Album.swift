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
        case .Polaroid : return UIImage(named: "layoutPolaroid")!
        case .Mini : return UIImage(named: "layoutMini")!
        case .Memory : return UIImage(named: "layoutMemory")!
        case .Portrab : return UIImage(named: "layoutPortrab")!
        case .Tape : return UIImage(named: "layoutTape")!
        case .Portraw : return UIImage(named: "layoutPortraw")!
        case .Filmroll : return UIImage(named: "layoutFilmroll")!
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
        case .Filmroll : return CGSize(width: 286, height: 388)
        }
    }
}

class LayoutModel {
    var arrayList : [AlbumLayout] = [.Polaroid, .Mini, .Memory, .Portrab, .Tape, .Portraw, .Filmroll]
}
