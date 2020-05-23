//
//  LeaveService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/23.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct LeaveService : APIManager {
    static let shared = LeaveService()
    let leaveURL = url("/user/signout")
    typealias completeLeave = (Int) -> ()
    
    func leave(token:String, completion: @escaping(completeLeave)){
        let header: HTTPHeaders =  ["Content-Type" : "application/json",
                                    "X-AUTH-TOKEN": token ]
        
        AF.request(leaveURL, method: .get, headers: header).response(completionHandler: {
            response in
            switch response.result {
            case .success:
                print("signOut success")
                completion((response.response?.statusCode)!)
            case .failure(let err):
                print("signOut err : \(err)")
                break
            }
        })
        
    }
}
