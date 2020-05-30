//
//  OrderService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/30.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct OrderService : APIManager {
    static let shared = OrderService()

    let orderURL = url("/album/order/createAlbumOrder")
    typealias completeOrder = (AFDataResponse<Any>) -> ()
    
    
    func order(amount: Int, albumUid:Int, recipient:String,
               postalCode:String, address:String, addressDetail:String,
               phoneNum:String, message:String,
               paperType1:Int,paperType2:Int,
               postType:Int, cost:String, completion: @escaping(completeOrder)){
        
        let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                       "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
        
        let body: [String:Any] = [
            "albumUid": albumUid,
            "amount": amount,
            "recipient": recipient,
            "postalCode": postalCode,
            "address": address,
            "addressDetail": addressDetail,
            "phoneNum": phoneNum,
            "message": message,
            "paperType1": paperType1,
            "paperType2": paperType2,
            "postType": postType,
            "cost": cost
        ]
        
        AF.request(orderURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("order err : \(err)")
                break
            }
        })
        
    }
}
