//
//  AlbumServiceData.swift
//  90's
//
//  Created by 성다연 on 2020/04/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire
import AlamofireImage

struct AlbumService : APIManager {
    static let shared = AlbumService()
    typealias completeAlbumSerivce = (AFDataResponse<Any>) -> ()
    typealias completePhotoDownloadService = (DataResponse<UIImage, AFError>) -> ()
    let header : HTTPHeaders =  [
        "Content-Type" : "application/json"
    ]
    let tokenHeader : HTTPHeaders = [
        "Content-Type" : "application/json",
        "X-AUTH-TOKEN" : tempAlbumToken
    ]
    let photoHeader : HTTPHeaders = [
        "Content-type": "multipart/form-data",
        "X-AUTH-TOKEN" : tempAlbumToken
    ]

    // Add User, post, 친구 추가
    func albumAddUser(albumUid : Int, role : String, userUid : Int, completion: @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/addUser")
        let body : [String: Any] = [
            "albumUid" : albumUid,
            "role" : role,
            "userUid" : userUid
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in AlbumAddUser Service : \(err)")
            }
        })
    }
    
//    // change Album Order status, post, 인화 쪽
//    func albumChangeOrderStatus(completion : @escaping(completeAlbumSerivce)){
//        let url = Self.url("/album/changeAlbumOrderStatus")
//
//        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
//            response in
//            switch response.result {
//            case .success:
//                completion(response)
//            case .failure(let err):
//                print("==> Error in AlbumChangeOrderStatue Service : \(err)")
//            }
//        })
//    }
    
    // CreateAlbum, Post, 앨범 생성
    func albumCreate(endDate : String, layoutUid : Int, name : String, photoLimit : Int, completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/create")
        let body : [String : Any] = [
            "endDate" : endDate,
            "layoutUid" : layoutUid,
            "name" : name,
            "photoLimit" : photoLimit
            ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in AlbumCreate Service : \(err)")
            }
        })
    }
    
    // createAlbumOrder, post, 앨범 인화 주문
//    func albumCreateOrder(completion : @escaping(completeAlbumSerivce)){
//        let url = Self.url("/album/createAlbumOrder")
//
//        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
//            response in
//            switch response.result {
//            case .success :
//                completion(response)
//            case .failure(let err):
//                print("==> Error in AlbumCreateOrder Service : \(err)")
//            }
//        })
//    }

    // getAlbum, post, 앨범 정보 가져오기
    func albumGetAlbum(uid:Int, completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/getAlbum")
        let body : [String : Any] = [
            "uid" : uid
        ]

        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
                print("success")
            case .failure(let err):
                print("==> Error in AlbumGetAlbum Service : \(err)")
            }
        })
    }
    
    // getAlbumOwners, post, 앨범 오너 정보
    func albumGetOwners(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/getAlbumOwners")
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
                print("success")
            case .failure(let err):
                print("==> Error in AlbumGetOwners Service : \(err)")
            }
        })
    }
    
    // getAlbums, get, 앨범 목록
    func albumGetAlbums(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/getAlbums")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
                print("success")
            case .failure(let err):
                print("==> Error in GetAlbums Service : \(err)")
            }
        })
    }
    
    // plusCount, get 앨범 낡기 카운드. 뒤에 ?uid=00 붙여야 함
    func albumPlusCount(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/plusCount")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
                print("success")
            case .failure(let err):
                print("==> Error in AlbumplusCount Service : \(err)")
            }
        })
    }
}


/** Photo  **/
extension AlbumService {
    // photoDownload, post, 사진 가져오기
    func photoDownload(albumUid : Int, photoUid : Int, completion : @escaping(completePhotoDownloadService)) {
        let url = Self.url("/photo/download")
        let body : [String : Any] = [
            "albumUid" : albumUid,
            "photoUid" : photoUid
        ]
        
        AF.request(url,method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseImage(completionHandler: {response in
            switch response.result {
            case .success(let image):
                completion(response)
            case .failure(let err):
                print("==> Error in PhotoDownload Service : \(err)")
            }
        })
    }
    
    // photoGetPhoto, post, 사진 목록의 사진 uid
    func photoGetPhoto(albumUid : Int, completion: @escaping(completeAlbumSerivce)){
        let url = Self.url("/photo/getPhotos")
        let body : [String : Any] = [
            "uid" : albumUid
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in PhotoGetPhotos Service : \(err)")
            }
        })
    }
    
    
    // photoUpload, post, 사진 업로드
    func photoUpload(albumUid : Int, image: [UIImage], imageName: String!, completion: @escaping(completeAlbumSerivce)){
        let url = Self.url("/photo/upload")
        let body : [String : Any] = [
            "albumUid" : albumUid
        ]
        
        guard let imageData = image[0].jpegData(compressionQuality: 1.0) else {return}
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in body {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                multipartFormData.append(imageData, withName: "image" , fileName: imageName, mimeType: "image/jpeg") //fileName : imagename.jpeg
                
        }, to: url, method: .post , headers: photoHeader)
            .response { response in
                switch response.result {
                case .success:
                    print(response)
                    
                case .failure(let err):
                    print("==> Error in PhotoUpload Service : \(err)")
            }
        }
    }
}

/** Order **/
extension AlbumService {
    func albumOrderChangeStatus() {
        let url = Self.url("/album/order/changeAlbumOrderStatus")
        
    }
    
    func albumOrderCreate() {
        let url = Self.url("/album/order/createAlbumOrder")
    }
}
