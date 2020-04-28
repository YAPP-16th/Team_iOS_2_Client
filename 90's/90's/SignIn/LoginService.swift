//
//  SignInService.swift
//  90's
//
//  Created by 홍정민 on 2020/04/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct LoginService : APIManager {
    static let shared = LoginService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let loginURL = url("/user/login")
    typealias completeLogin = (AFDataResponse<Any>) -> ()
    
    
    func login(email:String, password: String?, sosial:Bool, completion: @escaping(completeLogin)){
        
        let body: [String:Any] = [
            "email": email,
            "password": password,
            "sosial": sosial
        ]
        
        AF.request(loginURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("signUp err : \(err)")
                break
            }
        })
        
    }
}
