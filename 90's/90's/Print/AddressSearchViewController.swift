//
//  AddressSearchViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/15.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AddressSearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tfQuery: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var addressTableView: UITableView!
    private var addressList = [Address]()
//    weak var searchDelegate : SearchAddressDelegate?
    
    override func viewDidLoad() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func clickCloseBtn(_ sender: Any){
        dismiss(animated: true)
    }
    
    
    @IBAction func searchAdress(_ sender: Any) {
        guard let searchWord = tfQuery.text else { return }
        addressList.removeAll()
        doSearchAdress(searchWord)
    }
    
    //    GET /v2/local/search/address.{format} HTTP/1.1
    //    Host: dapi.kakao.com
    //    Authorization: KakaoAK {app_key}
    
    
    func doSearchAdress(_ searchWord : String){
        let parameters: [String: Any] = [
            "query": searchWord
        ]
//
//        let headers: HTTPHeaders = ["Authorization":"KakaoAK 1b64850b9e7c0145c5f45b791517a774"]
//
//        AF.request("https://dapi.kakao.com/v2/local/search/address.json", method: .get, parameters: parameters, headers: headers)
//            .responseJSON(completionHandler: {
//                response in
//                switch response.result {
//                case .success(let value):
//                    print("success")
//                    if let document = JSON(value)["documents"].array {
//                        for item in document {
//                            let address = item["address_name"].string ?? ""
//                            let roadAddress = item["road_address"]["address_name"].string ?? ""
//                            let buildingName = item["road_address"]["building_name"].string ?? ""
//                            var zipcode = item["address"]["zip_code"].string ?? ""
//                            if(zipcode == ""){
//                                zipcode = item["road_address"]["zone_no"].string ?? ""
//                            }
//                            self.addressList += [Address(address: address, roadAddress: roadAddress, buildingName: buildingName, zipCode: zipcode)]
//                        }
//                        self.addressTableView.reloadData()
//                    }
//                case .failure(let err):
//                    print("err")
//
//                }
//            })
    }
}



