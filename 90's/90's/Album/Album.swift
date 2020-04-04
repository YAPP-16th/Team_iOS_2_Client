import Foundation
import UIKit
//메인 앨범에 들어갈 클래스

class Album {
    var index : Int!
    var isShare : Bool!
    var albumName : String!
    var startDate : String?
    var expireDate : String?
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
        
      
    }
    
}

class AlbumModel{
    static var albumList :[Album] = []

    
}


