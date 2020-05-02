//
//  ManageInfoViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ManageInfoViewController: UIViewController {

    @IBOutlet weak var infoTableView: UITableView!
    var infoList = ["이메일 변경", "비밀번호 변경", "전화번호 변경"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }
    
    func pushView(_ vc: String){
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: vc) else { return }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension ManageInfoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        cell.selectionStyle = .none //셀 선택 시 선택 이펙트 삭제하기
        cell.infoNameLabel.text = infoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushView("EmailPhoneViewController")
        default:
            return
        }
    }
    
}
