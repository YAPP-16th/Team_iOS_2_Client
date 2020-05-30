//
//  ChangePhoneService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct ChangePhoneService : APIManager {
    static let shared = ChangePhoneService()
    let changePhoneURL = url("/user/updatePhoneNumber")
    typealias completeChangePhone = (AFDataResponse<Any>) -> ()
    
    func changePhone(phoneNum: String, completion: @escaping(completeChangePhone)){
        
        let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                       "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
        
        let body: [String:Any] = [
            "phoneNum": phoneNum
        ]
        
        AF.request(changePhoneURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("Change Phone err : \(err)")
                break
            }
        })
        
    }
}
