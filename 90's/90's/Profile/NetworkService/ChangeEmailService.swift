//
//  ChangeEmailService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct ChangeEmailService : APIManager {
    static let shared = ChangeEmailService()
    
    let changeEmailURL = url("/user/updateEmail")
    typealias completeChangeEmail = (AFDataResponse<Any>) -> ()
    
    func changeEmail(email: String, completion: @escaping(completeChangeEmail)){
        
        let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                    "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
        let body: [String:Any] = [
            "email": email
        ]
        
        AF.request(changeEmailURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("Update Email err : \(err)")
                break
            }
        })
        
    }
}
