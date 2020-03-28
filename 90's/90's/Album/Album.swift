import Foundation
import UIKit
//메인 앨범에 들어갈 클래스

class Album {
    var index : Int!
    var isShare : Bool!
    var albumName : String!
    var period : String?
    var numOfPhotos : Int?
    var selectTheme : Theme!
    var photos : [UIImage]

    
    init(index : Int, isShare: Bool, albumName: String, photo: [UIImage]?) {
        self.index = index
        self.isShare = isShare
        self.albumName = albumName
        
        self.photos = []
        
        //더미값을 위한 처리(나중에 삭제 필요)
        if let initialPhoto = photo {
            self.photos += initialPhoto
        }
        
        self.period = "2Month"
        self.numOfPhotos = 5
        selectTheme = ThemeModel.themeList[0]
    }
    
}

class AlbumModel{
    static var albumList = [Album(index: 0, isShare: false, albumName: "강아지 콩이",
                                  photo: [UIImage(named:"dog1")!,
                                          UIImage(named:"dog2")!,
                                          UIImage(named:"dog3")!,
                                          UIImage(named:"dog4")!,
                                          UIImage(named:"dog5")!]),
                            Album(index: 1, isShare: false, albumName: "제주도 여행", photo: nil)]

    
}


