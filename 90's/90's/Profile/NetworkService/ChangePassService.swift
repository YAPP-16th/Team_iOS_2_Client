//
//  ChangePassService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct ChangePassService : APIManager {
    static let shared = ChangePassService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
    let changePassURL = url("/user/updatePassword")
    typealias completeChangePass = (AFDataResponse<Any>) -> ()
    
    func changePass(password: String, completion: @escaping(completeChangePass)){
        
        let body: [String:Any] = [
            "password": password
        ]
        
        AF.request(changePassURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("Update Pass err : \(err)")
                break
            }
        })
        
    }
}
