//
//  TelephoneAuthService.swift
//  90's
//
//  Created by 홍정민 on 2020/04/28.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct TelephoneAuthService : APIManager {
    static let shared = TelephoneAuthService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let telephoneAuthURL = url("/user/checkPhoneNum")
    typealias completeAuth = (AFDataResponse<Any>) -> ()
    
    
    func telephoneAuth(phone:String, completion: @escaping(completeAuth)){
        
        let body: [String:Any] = [
            "phoneNumber": phone
        ]
        
        AF.request(telephoneAuthURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("SignUp - telephone err : \(err)")
                break
            }
        })
        
    }
}

