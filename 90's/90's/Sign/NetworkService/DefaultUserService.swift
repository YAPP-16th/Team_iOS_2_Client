//
//  DefaultUserService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct DefaultUserService : APIManager {
    static let shared = DefaultUserService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let getDefaultURL = url("/user/getDefaultUser")
    typealias completeGetDefault = (AFDataResponse<Any>) -> ()
    
    func getDefaultUser(completion: @escaping(completeGetDefault)){
        AF.request(getDefaultURL, method: .get, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("Get Default User err : \(err)")
                break
            }
        })
        
    }
}
