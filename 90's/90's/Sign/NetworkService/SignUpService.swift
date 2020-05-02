//
//  SignUpService.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct SignUpService : APIManager {
    static let shared = SignUpService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let signURL = url("/user/join")
    typealias completeSign = (AFDataResponse<Any>) -> ()
    
    
    func signUp(email:String, name:String, password: String?, phone:String, sosial:Bool, completion: @escaping(completeSign)){
        
        let body: [String:Any] = [
            "email": email,
            "name": name,
            "password": password,
            "phone": phone,
            "sosial": sosial
        ]
        
        AF.request(signURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
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
