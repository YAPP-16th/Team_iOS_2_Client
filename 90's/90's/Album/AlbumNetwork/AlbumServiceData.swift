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
    let header : HTTPHeaders =  ["Content-Type" : "application/json"]
    let createAlbumUrl = url("/album/create")
    let addAlbumUserUrl = url("/album/addUser")
    
    typealias completeAlbumSerivce = (AFDataResponse<Any>) -> ()
    
    
    // CreateAlbum, Post
    func createAlbum(endDate : String, layoutUid : Int, name : String, photoLimit : Int, completion : @escaping(completeAlbumSerivce)){
        let body : [String : Any] = [
            "endDate" : endDate,
            "layoutUid" : layoutUid,
            "name" : name,
            "photoLimit" : 0
            ]
        
        AF.request(createAlbumUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in CreateAlbumService : \(err)")
                break
            }
        })
    }
    
    // AddAlbum User, Post
    func addAlbumUSer(albumUid : Int, role : String, userUid : Int, completion: @escaping(completeAlbumSerivce)){
        let body : [String: Any] = [
            "albumUid" : albumUid,
            "role" : role,
            "userUid" : userUid
        ]
        
        AF.request(addAlbumUserUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("==> Error in AddAlbumService : \(err)")
                break
            }
        })
    }
}
