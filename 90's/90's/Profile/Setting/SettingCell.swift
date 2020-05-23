//
//  SettingCell.swift
//  90's
//
//  Created by 홍정민 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Alamofire

protocol switchActionDelegate {
    
    func didClickedLink(index: Int)
    
}

class SettingCell: UITableViewCell {
    
    var delegate : switchActionDelegate?
    var currentIndex: Int?
    var state: Int? = 0
    var noticeList = ["마케팅 이벤트 알림","앨범 기간 알림", "앨범이 종료되기 전 알림", "구매 및 배송 알림"]
    var albumUidArray : [Int] = []
    var albumNameArray : [String] = []
    var albumCreateArray : [String] = []
    var albumEndArray : [String] = []
    
    var albumUid : Int = 0
    
    
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var isOn : Bool = false {
        didSet {
            if(isOn){
                settingSwitch.isOn = true
                
            }
            else {
                settingSwitch.isOn = false
            }
        }
    }
    
    override func awakeFromNib() {
        networkSetting()
        self.delegate?.didClickedLink(index: currentIndex ?? 0)
        print(currentIndex) // 여기서 nil뜨네요
        

        
    }
    
    @IBAction func clickSwitch(_ sender: Any) {
        
        if settingSwitch.isOn {
            print("switch On")
            
            let content = UNMutableNotificationContent()
            //APN form
            if noticeList[currentIndex ?? 0] == "마케팅 이벤트 알림" {
                
                content.title = "90s"
                content.body = noticeList[currentIndex ?? 0]
                content.badge = 1
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats:false)
                let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
                UserDefaults.standard.set("1", forKey: "switch1")
                print(UserDefaults.standard.value(forKey: "switch1") ?? 0 )
                
            }
                //이건 모르겠는뎅....
            else if noticeList[currentIndex ?? 0] == "앨범 기간 알림" {
                
                content.title = "90s"
                content.body = noticeList[currentIndex ?? 0]
                content.badge = 1
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats:false)
                let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
                UserDefaults.standard.set("2", forKey: "switch2")
                print(UserDefaults.standard.value(forKey: "switch2") ?? 0 )
                
            }
                //알람 트리거로 해결 가능. 앨범 만든 날짜 , timeInterval 이용
            else if noticeList[currentIndex ?? 0] == "앨범이 종료되기 전 알림" {
                
                UserDefaults.standard.set("3" , forKey: "switch3")
                calcDate()
                print(UserDefaults.standard.value(forKey: "switch3") ?? 0 )
                
                
            }
                //APN form
            else if noticeList[currentIndex ?? 0] == "구매 및 배송 알림" {
                content.title = "90s"
                content.body = noticeList[currentIndex ?? 0]
                content.badge = 1
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats:false)
                let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                UserDefaults.standard.set("4", forKey: "switch4")
                print(UserDefaults.standard.value(forKey: "switch4") ?? 0 )
            }
            
        }
        
        if !settingSwitch.isOn {
            print("Switch Off")
            if noticeList[currentIndex ?? 0] == "마케팅 이벤트 알림" {
                UserDefaults.standard.set(nil, forKey: "switch1")
                print(UserDefaults.standard.value(forKey: "switch1") ?? "" )
            }
            else if noticeList[currentIndex ?? 0] == "앨범 기간 알림" {
                UserDefaults.standard.set(nil, forKey: "switch2")
                print(UserDefaults.standard.value(forKey: "switch2") ?? "" )
                
            }
            else if noticeList[currentIndex ?? 0] == "앨범이 종료되기 전 알림" {
                UserDefaults.standard.set(nil, forKey: "switch3")
                print(UserDefaults.standard.value(forKey: "switch3") ?? 0 )
            }
            else if noticeList[currentIndex ?? 0] == "구매 및 배송 알림" {
                UserDefaults.standard.set(nil, forKey: "switch4")
                print(UserDefaults.standard.value(forKey: "switch4") ?? "" )
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
                    print(self.albumEndArray)
                    
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
        
        //        let endDate = sortedArray[0]
        let endDate = "2020-05-31"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        
        guard let date = dateFormatter.date(from: endDate) else {
            fatalError()
        }
        let testdate : Date = dateFormatter.date(from: endDate) ?? Date()
        
        print(testdate)
        
        let now = NSDate()
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        
        let startDate = now as Date
        
        print(startDate)
        
        let timeInterval = date.timeIntervalSince(startDate)
        
        
        let days = Int(timeInterval / 86400)
        
        
        print("\(days) 일 남았습니다.")
        
        print("\(timeInterval) 초 남았습니다.")
        print(timeInterval - 60*60*24*7)
        
        let content = UNMutableNotificationContent()
        content.title = "90s"
        content.body = "앨범이 종료되기 전 \(days) 일 남았습니다."
        content.badge = 1
        
        if UserDefaults.standard.integer(forKey: "switch3") == 3 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7 //timeInterval - 60*60*24*7 + 100 //100은 constant
                , repeats:false)
            let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        else {
            print("UserDefault Nil")
        }
    }
    
}

extension Date {
    func dayMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}



