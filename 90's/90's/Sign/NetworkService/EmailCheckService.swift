//
//  EmailCheckService.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct EmailCheckService: APIManager {
    static let shared = EmailCheckService()
    let emailCheckURL = url("/user/checkEmail")
    let header:HTTPHeaders = ["Content-Type" : "application/json"]
    typealias completeEmailCheck = (AFDataResponse<Any>) -> ()
    
    
    func emailCheck(email: String, completion: @escaping(completeEmailCheck)){
        
        let body = ["email":email]
        
        AF.request(emailCheckURL, method: .post, parameters: body,encoding:JSONEncoding.default, headers: header)
            .responseJSON(completionHandler : {
                response in
                switch response.result {
                case .success:
                    completion(response)
                case .failure(let err):
                    print("duplication err : \(err)")
                    break
                }
            })
    }
    
}



