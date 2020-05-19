//
//  FindEmailService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/19.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct FindEmailService : APIManager {
    static let shared = FindEmailService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let findEmailURL = url("/user/findEmail")
    typealias completeFindEmail = (AFDataResponse<Any>) -> ()
    
    func findEmail(phoneNum:String, completion: @escaping(completeFindEmail)){
        let body = ["phoneNum":phoneNum]
        
        AF.request(findEmailURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("Find Email err : \(err)")
                break
            }
        })
        
    }
}
