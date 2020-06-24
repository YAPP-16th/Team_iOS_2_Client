//
//  AddressSearchViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/15.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol SearchAddressDelegate : NSObjectProtocol {
    func passSelectedAddress(_ roadAddress: String, _ numAddress: String, _ zipCode: String)
}

class AddressSearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfQuery: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var exampleView: UIView!
    var roadAddress:String!
    var numAddress:String!
    var zipCode: String!
    weak var searchDelegate : SearchAddressDelegate?
    
    override func viewDidLoad() {
        setUI()
        setObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfQuery.resignFirstResponder()
        if(!(textField.text == "")){
            let searchWord = textField.text!
            doSearchAddress(searchWord)
        }
        return true
    }
    
    @IBAction func clickCloseBtn(_ sender: Any){
        dismiss(animated: true)
    }
    
    @IBAction func searchAdress(_ sender: Any) {
        guard let searchWord = tfQuery.text else { return }
        doSearchAddress(searchWord)
    }
    
    func setUI(){
        addressTableView.delegate = self
        addressTableView.dataSource = self
        tfQuery.delegate = self
        addressTableView.isHidden = true
    }
    
    func setObserver(){
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfQuery, queue: .main, using : {
            _ in
            let str = self.tfQuery.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView.backgroundColor = UIColor(red: 0/255,green: 0/255, blue: 0/255, alpha: 1.0)
            }else {
                self.selectorImageView.backgroundColor = UIColor(red: 218/255,green: 220/255, blue: 227/255, alpha: 1.0)
            }
        })
    }
    
    func doSearchAddress(_ searchWord : String){
        AddressService.shared.addressSearch(query: searchWord, completion: { response in
            if let status = response.response?.statusCode {
                print("\(status)")
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    guard let addressResult = try? decoder.decode(AddressResult.self, from: data) else {
                        return
                    }
                    
                    if let documents = addressResult.documents?.first {
                        let zoneNo = documents.road_address?.zone_no
                        if zoneNo != "" {
                            self.roadAddress = documents.road_address?.address_name
                            self.zipCode = zoneNo
                            self.numAddress = documents.address_name
                            self.addressTableView.reloadData()
                            self.addressTableView.isHidden = false
                        }else{
                            self.showNotFoundErrAlert()
                        }
                    }else {
                        self.showNotFoundErrAlert()
                    }
                    break
                case 400...500:
                    self.showErrAlert()
                    break
                default:
                    break
                }
            }
            
        })
    }
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "검색 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func showNotFoundErrAlert(){
        let alert = UIAlertController(title: "우편번호 검색 불가", message: "정확한 주소를 입력해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}


extension AddressSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
        cell.roadAddressLabel.text = roadAddress
        cell.numberAddressLabel.text = numAddress
        cell.postNumLabel.text = zipCode
        cell.layer.cornerRadius = 4.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor =  UIColor(red: 199/255, green: 201/255, blue: 208/255, alpha: 0.7).cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.dismiss(animated: true, completion: {
            self.searchDelegate!.passSelectedAddress(self.roadAddress, self.numAddress, self.zipCode)
        })
    }
    
}


