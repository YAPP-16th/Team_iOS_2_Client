//
//  CancelOrderServie.swift
//  90's
//
//  Created by 홍정민 on 2020/06/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct CancelOrderService : APIManager {
    static let shared = CancelOrderService()
    typealias completeGetProfile = (Int) -> ()
    
    func cancelOrder(albumOrderUid: Int, completion: @escaping(completeGetProfile)){
        let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                    "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
        
        let cancelOrderURL = Self.url("/album/order/deleteAlbumOrder/\(albumOrderUid)")
        
        print("\(cancelOrderURL)")
        
        AF.request(cancelOrderURL, method: .delete, headers: header).response(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response.response!.statusCode)
            case .failure(let err):
                print("get orderList err : \(err)")
                break
            }
        })
        
    }
}

