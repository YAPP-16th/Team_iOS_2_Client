//
//  AddressService.swift
//  90's
//
//  Created by 홍정민 on 2020/05/15.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Alamofire

struct AddressService : APIManager {
    static let shared = AddressService()
    let header: HTTPHeaders = ["Authorization":"KakaoAK 8245d0138a19a23beb15ef69cd3dc0e2"]
    let searchURL = "https://dapi.kakao.com/v2/local/search/address.json"
    typealias completeSearch = (AFDataResponse<Any>) -> ()
    
    func addressSearch(query: String, completion: @escaping(completeSearch)){
        
        let params: [String:Any] = [
            "query" : query
        ]
        
        AF.request(searchURL, method: .get, parameters: params, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("Addresssearch err : \(err)")
                break
            }
        })
        
    }
}
