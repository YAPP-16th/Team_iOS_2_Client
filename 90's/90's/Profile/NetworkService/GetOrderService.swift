//
//  GetOrderService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/30.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct GetOrderService : APIManager {
    static let shared = GetOrderService()
    let getOrderURL = url("/album/order/getAlbumOrders")
    typealias completeGetProfile = (AFDataResponse<Any>) -> ()
    
    func getOrder(completion: @escaping(completeGetProfile)){
        let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                    "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
        
        AF.request(getOrderURL, method: .get, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("get orderList err : \(err)")
                break
            }
        })
        
    }
}
