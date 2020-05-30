//
//  SettingCell.swift
//  90's
//
//  Created by 홍정민 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Alamofire

class SettingCell: UITableViewCell {
    
    var currentIndex: Int?
    var state: Int? = 0
    var noticeList = ["마케팅 이벤트 알림", "앨범이 종료되기 전 알림", "구매 및 배송 알림"]
    var albumUidArray : [Int] = []
    var albumNameArray : [String] = []
    var albumCreateArray : [String] = []
    var albumEndArray : [String] = []
    
    var albumUid : Int = 0
    
    
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        networkSetting()
        
    }
    
    @IBAction func clickSwitch(_ sender: Any) {
        
        if settingSwitch.isOn {
            print("switch On")
            
            let content = UNMutableNotificationContent()
            //APN form
            if noticeList[currentIndex ?? 0] == "마케팅 이벤트 알림" {

                UserDefaults.standard.set("1", forKey: "switch1")
                print(UserDefaults.standard.value(forKey: "switch1") ?? 0 )
                sendToken(argument: UserDefaults.standard.integer(forKey: "switch1"))
                
            }
                
                //알람 트리거로 해결 가능. 앨범 만든 날짜 , timeInterval 이용
            else if noticeList[currentIndex ?? 0] == "앨범이 종료되기 전 알림" {
                
                UserDefaults.standard.set("2" , forKey: "switch2")
                calcDate()
                print(UserDefaults.standard.value(forKey: "switch2") ?? 0 )
                
                
            }
                //APN form
            else if noticeList[currentIndex ?? 0] == "구매 및 배송 알림" {
                
                UserDefaults.standard.set("3", forKey: "switch3")
                print(UserDefaults.standard.value(forKey: "switch3") ?? 0 )
                sendToken(argument: UserDefaults.standard.integer(forKey: "switch3"))
            }
            
        }
        
        if !settingSwitch.isOn {
            print("Switch Off")
            if noticeList[currentIndex ?? 0] == "마케팅 이벤트 알림" {
                UserDefaults.standard.set(nil, forKey: "switch1")
                print(UserDefaults.standard.value(forKey: "switch1") ?? 0 )
            }

            else if noticeList[currentIndex ?? 0] == "앨범이 종료되기 전 알림" {
                UserDefaults.standard.set(nil, forKey: "switch2")
                print(noticeList[currentIndex ?? 0])
                print(UserDefaults.standard.value(forKey: "switch2") ?? 0 )
            }
            else if noticeList[currentIndex ?? 0] == "구매 및 배송 알림" {
                UserDefaults.standard.set(nil, forKey: "switch3")
                print(UserDefaults.standard.value(forKey: "switch3") ?? 0)
            }
            
        }
        
    }
    
    
    
}

extension SettingCell {
    
    func networkSetting(){
        
        AlbumService.shared.albumGetAlbums(completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode([album].self, from: data) else {return}
                    self.albumUidArray = value.map({$0.uid})
                    self.albumNameArray = value.map({$0.name})
                    self.albumCreateArray = value.map({$0.created_at})
                    self.albumEndArray = value.map({$0.endDate})
//                    print(self.albumEndArray)
                    
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumMain - getAlbums")
                default:
                    return
                }
            }
        })
    }
    
    func calcDate(){
        
        print((albumCreateArray).count)
        let sortedArray = albumEndArray.sorted(by: <)
        print(sortedArray)
        var endDate = ""
        
        if sortedArray.count == 0 {
             endDate = "2099-03-30"
        }
        
        else {
             endDate = sortedArray[0]
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: endDate) else {
            fatalError()
        }
                
        let now = NSDate()
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        let startDate = now as Date
        
        let timeInterval = date.timeIntervalSince(startDate)        
        let days = Int(timeInterval / 86400)
        
        
        print("\(days) 일 남았습니다.")
        print("\(timeInterval) 초 남았습니다.")
        
        let content = UNMutableNotificationContent()
        content.title = "90s"
        content.body = "앨범이 종료되기 전 \(days) 일 남았습니다."
        content.badge = 1
        
        if UserDefaults.standard.integer(forKey: "switch2") == 2 {
            if days  <= 7 { // 1주일 보다 적게 남았다.
                print("1주일 미만")
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10 //60*60*24 //임의로 하루 뒤에 트리거 작동 //100은 constant
                    , repeats:false)
                content.body = "앨범이 종료되기 전 1주 미만 남았습니다."
                let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
                
            else { // 1주일 보다 많이 남았다.
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  timeInterval - 60*60*24*7 + 100 //100은 constant
                    , repeats:false)
                let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
        }
            
        else {
            print("UserDefault Value Nil")
        }
    }
    
    //여기로 서버에 전송해주면 될듯
    func sendToken(argument : Int){
        
        if argument == 1 { // 마케팅 알림
            print(AppDelegate.APN_Token)
            //일단 보내놓고 
        }
        
        if argument == 3 { // 구매 및 배송 알림
            print(AppDelegate.APN_Token)
        }
        
    }
    
}




