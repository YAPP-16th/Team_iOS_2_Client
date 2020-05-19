//
//  ChangePassService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/06.
//  Copyright © 2020 홍정민. All rights reserved.
//



//서비스 이용 하는 부분
//1) 프로필 - 정보 변경 - 비밀번호 변경
//2) 로그인 메인 - 비밀번호 찾기(비밀번호 찾기는 비밀번호 변경과 동일한 로직으로 수행됨)

import Alamofire

struct ChangePassService : APIManager {
    static let shared = ChangePassService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let changePassURL = url("/user/updatePassword")
    typealias completeChangePass = (AFDataResponse<Any>) -> ()
    
    func changePass(password: String, phoneNum: String, completion: @escaping(completeChangePass)){
        
        let body: [String:Any] = [
            "password": password,
            "phoneNum": phoneNum
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
