//
//  AlbumServiceData.swift
//  90's
//
//  Created by 성다연 on 2020/04/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct AlbumService : APIManager {
    static let shared = AlbumService()
    typealias completeAlbumSerivce = (AFDataResponse<Any>) -> ()
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
    
    // Album, get
    func album(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in Album Service : \(err)")
            }
        })
    }
    
    // Add User, post
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
    
    // change Album Order status, post
    func albumChangeOrderStatus(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/changeAlbumOrderStatus")
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in AlbumChangeOrderStatue Service : \(err)")
            }
        })
    }
    
    // CreateAlbum, Post
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
    
    // createAlbumOrder, post
    func albumCreateOrder(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/createAlbumOrder")
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success :
                completion(response)
            case .failure(let err):
                print("==> Error in AlbumCreateOrder Service : \(err)")
            }
        })
    }
    
    // getAlbum, get
    func albumGetAlbum(completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/album/get")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
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
    
    // getAlbumOwners, post
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
    
    // getAlbums, get
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
    
    // plusCount, get
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


/** Photo  */
extension AlbumService {
    // photo, get
    func photo(completion : @escaping(completeAlbumSerivce)) {
        let url = Self.url("/photo")
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in Photo Service : \(err)")
            }
        })
    }
    
    // photoDownload, post
    func photoDownload(albumUid : Int, photoUid : Int, completion : @escaping(completeAlbumSerivce)){
        let url = Self.url("/photo/download")
        let body : [String : Any] = [
            "albumUid" : albumUid,
            "photoUid" : photoUid
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in PhotoDownload Service : \(err)")
            }
        })
    }
    
    // photoGetPhoto, post
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
    
    
    // photoUpload, post
    func photoUpload(albumUid : Int, image: [UIImage], imageName: String, completion: @escaping(completeAlbumSerivce)){
        let url = Self.url("/photo/upload")
        let body : [String : Any] = [
            "albumUid" : albumUid
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in body {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                multipartFormData.append(image[0].jpegData(compressionQuality: 0.7)!, withName: "image" , fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
                
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
