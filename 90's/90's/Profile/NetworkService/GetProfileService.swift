//
//  GetProfileService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct GetProfileService : APIManager {
    static let shared = GetProfileService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                "X-AUTH-TOKEN" :  UserDefaults.standard.string(forKey: "jwt") ?? ""]
    let getProfileURL = url("/user/getUserProfile")
    typealias completeGetProfile = (AFDataResponse<Any>) -> ()
    
    func getProfile(completion: @escaping(completeGetProfile)){
        AF.request(getProfileURL, method: .get, headers: header).responseJSON(completionHandler: {
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

