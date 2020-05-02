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
    let createAlbumUrl = url("/album/create")
    let addAlbumUserUrl = url("/album/addUser")
    let getAlbumUrl = url("/album")
    let getAlbumListUrl = url("/album/get")
    let photoDownloadUrl = url("/photo/download")
    let photoUploadUrl = url("/photo/upload")
    
    // Album, get
    func getAlbum(completion : @escaping(completeAlbumSerivce)){
        AF.request(getAlbumUrl, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in GetAlbumService : \(err)")
            }
        })
    }
    
    // getAlbum, get
    func getAlbumList(accountNonExpired : Bool, accountNonLocked : Bool, authority : String, credentialsNonExpired : Bool, enabled : Bool, password: String, username : String, completion : @escaping(completeAlbumSerivce)){
        
        AF.request(getAlbumListUrl, method: .get, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in GetAlbumListService : \(err)")
            }
        })
    }
    
    // CreateAlbum, Post
    func createAlbum(endDate : String, layoutUid : Int, name : String, photoLimit : Int, completion : @escaping(completeAlbumSerivce)){
        let body : [String : Any] = [
            "endDate" : endDate,
            "layoutUid" : layoutUid,
            "name" : name,
            "photoLimit" : 0
            ]
        
        AF.request(createAlbumUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in CreateAlbumService : \(err)")
            }
        })
    }
    
    // post
    func addAlbumUser(albumUid : Int, role : String, userUid : Int, completion: @escaping(completeAlbumSerivce)){
        let body : [String: Any] = [
            "albumUid" : albumUid,
            "role" : role,
            "userUid" : userUid
        ]
        
        AF.request(addAlbumUserUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in AddAlbumService : \(err)")
            }
        })
    }
    
    // post
    func photoDownload(albumUid : Int, photoUid : Int, completion : @escaping(completeAlbumSerivce)){
        let body : [String : Any] = [
            "albumUid" : albumUid,
            "photoUid" : photoUid
        ]
        
        AF.request(photoDownloadUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: tokenHeader).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in PhotoDownloadService : \(err)")
            }
        })
    }
    
    // post
    func photoUpload(albumUid : String, image: UIImage, imageName: String, completion: @escaping(completeAlbumSerivce)){
        let body : [String : Any] = [
            "albumUid" : albumUid
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in body {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                multipartFormData.append(image.jpegData(compressionQuality: 0.7)!, withName: "image" , fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
        }, to: photoUploadUrl, method: .post , headers: photoHeader)
            .response { response in
                switch response.result {
                case .success:
                    print(response)
                case .failure(let err):
                    print("==> Error in PhotoUploadService : \(err)")
            }
        }
    }
}
