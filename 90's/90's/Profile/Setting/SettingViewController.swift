//
//  SettingViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var noticeList = ["마케팅 이벤트 알림", "앨범이 종료되기 전 알림", "구매 및 배송 알림"]
    var albumUidArray : [Int] = []
    var albumNameArray : [String] = []
    var albumCreateArray : [String] = []
    var albumEndArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        settingTableView.dataSource = self
        settingTableView.delegate = self
    }

}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        cell.settingNameLabel.text = noticeList[indexPath.row]
        cell.currentIndex = indexPath.row
        
        if UserDefaults.standard.integer(forKey: "switch1") == cell.currentIndex! + 1 {
            cell.settingSwitch.isOn = true
        }
        
        if UserDefaults.standard.integer(forKey: "switch2") == cell.currentIndex! + 1 {
            cell.settingSwitch.isOn = true
        }
        
        if UserDefaults.standard.integer(forKey: "switch3") == cell.currentIndex! + 1 {
            cell.settingSwitch.isOn = true
        }
        
//        if UserDefaults.standard.integer(forKey: "switch4") == cell.currentIndex! + 1 {
//            cell.settingSwitch.isOn = true
//        }
        
        return cell
    }
    
    
    
}

