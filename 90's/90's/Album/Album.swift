//
//  Album.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

let AlbumDatabase : AlbumModel = AlbumModel()
let LayoutDatabase : LayoutModel = LayoutModel()
let CoverDatabase : CoverModel = CoverModel()

class LayoutModel {
    let arrayList : [AlbumLayout] = [.Polaroid, .Mini, .Memory, .Portrab, .Tape, .Portraw, .Filmroll]
}

class CoverModel {
    let arrayList : [AlbumCover] = [.Copy, .Paradiso, .HappilyEverAfter, .FavoriteThings, .AwesomeMix, .LessButBetter, .SretroClub, .OneAndOnlyCopy]
}

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
    
    // sticker
    var deviceLowSize : CGSize {
        switch self {
        case .Polaroid : return CGSize(width: 290, height: 332)
        case .Mini : return CGSize(width: 259, height: 354)
        case .Memory : return CGSize(width: 311, height: 281)
        case .Portrab : return CGSize(width: 291, height: 348)
        case .Tape : return CGSize(width: 294, height: 304)
        case .Portraw : return CGSize(width: 330, height: 202)
        case .Filmroll : return CGSize(width: 267, height: 357)
        }
    }
    
    var innerFrameLowSize : CGSize {
        switch self {
        case .Polaroid: return CGSize(width: 263, height: 257)
        case .Mini : return CGSize(width: 228, height: 286)
        case .Memory: return CGSize(width: 265, height: 227)
        case .Portrab: return CGSize(width: 275, height: 332)
        case .Tape: return CGSize(width: 294, height: 304)
        case .Portraw: return CGSize(width: 324, height: 184)
        case .Filmroll: return CGSize(width: 208, height: 354)
        }
    }
    
    // sticker 
    var deviceHighSize : CGSize{
        switch self {
        case .Polaroid : return CGSize(width: 344, height: 394)
        case .Mini : return CGSize(width: 338, height: 463)
        case .Memory : return CGSize(width: 354, height: 320)
        case .Portrab : return CGSize(width: 346, height: 414)
        case .Tape : return CGSize(width: 354, height: 366)
        case .Portraw : return CGSize(width: 361, height: 221)
        case .Filmroll : return CGSize(width: 332, height: 444)
        }
    }
    
    var innerFrameHighSize : CGSize {
        switch self {
        case .Polaroid: return CGSize(width: 314, height: 306)
        case .Mini : return CGSize(width: 302, height: 380)
        case .Memory: return CGSize(width: 302, height: 260)
        case .Portrab: return CGSize(width: 326, height: 392)
        case .Tape: return CGSize(width: 316, height: 258)
        case .Portraw: return CGSize(width: 352, height: 200)
        case .Filmroll: return CGSize(width: 258, height: 440)
        }
    }
    
    var layoutUid : Int {
        switch self {
        case .Polaroid : return 0
        case .Mini : return 1
        case .Memory : return 2
        case .Portrab : return 3
        case .Tape : return 4
        case .Portraw : return 5
        case .Filmroll : return 6
        }
    }
    
    var layoutName : String {
        switch self {
        case .Polaroid: return "Polaroid"
        case .Mini : return "Mini"
        case .Memory : return "Memory"
        case .Portrab : return "Portrab"
        case .Tape : return "Tape"
        case .Portraw : return "Portraw"
        case .Filmroll : return "Filrmroll"
        }
    }
    
    var dateLabelFrame : CGSize {
        switch self {
        case .Polaroid: return CGSize(width: 40, height: 90)
        case .Mini : return CGSize(width: 34, height: 85)
        case .Memory: return CGSize(width: 44, height: 44)
        case .Portrab: return CGSize(width: 32, height: 25)
        case .Tape: return CGSize(width: 33, height: 81)
        case .Portraw: return CGSize(width: 16, height: 22)
        case .Filmroll: return CGSize(width: 50, height: 16)
        }
    }
    
    var cropImage : UIImage {
        switch self {
        case .Polaroid: return UIImage(named: "cropPolaroid")!
        case .Mini: return UIImage(named: "cropMini")!
        case .Memory: return UIImage(named: "cropMemory")!
        case .Portrab: return UIImage(named: "cropPortrab")!
        case .Tape: return UIImage(named: "cropTape")!
        case .Portraw: return UIImage(named: "cropPortraw")!
        case .Filmroll: return UIImage(named: "cropFilmroll")!
        }
    }
}


enum AlbumCover {
    case Copy
    case Paradiso
    case HappilyEverAfter
    case FavoriteThings
    case AwesomeMix
    case LessButBetter
    case SretroClub
    case OneAndOnlyCopy
    
    var image : UIImage {
        switch self {
        case .Copy : return UIImage(named: "albumcover1990Copy")!
        case .Paradiso : return UIImage(named: "albumcoverParadiso")!
        case .HappilyEverAfter : return UIImage(named: "albumcoverHappilyeverafter")!
        case .FavoriteThings : return UIImage(named: "albumcoverFavoritethings")!
        case .AwesomeMix : return UIImage(named: "albumcoverAwsomemix")!
        case .LessButBetter : return UIImage(named: "albumcoverLessbutbetter")!
        case .SretroClub : return UIImage(named: "albumcover90Sretroclub")!
        case .OneAndOnlyCopy : return UIImage(named: "albumcoverOneandonlyCopy")!
        }
    }
    
    var imageName : String {
        switch self {
        case .Copy : return "1990 Copy"
        case .Paradiso : return "Paradiso"
        case .HappilyEverAfter : return "Happily Ever After"
        case .FavoriteThings : return "Favorite Things"
        case .AwesomeMix : return "Awesome Mix"
        case .LessButBetter : return "Less But Better"
        case .SretroClub : return "Sretro Club"
        case .OneAndOnlyCopy : return "One & Only Copy"
        }
    }
}

