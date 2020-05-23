//
//  LeaveReasonViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/23.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol clickReasonDelegate: NSObjectProtocol {
    func clickReason(_ isClicked : Bool)
}

class LeaveReasonViewController: UIViewController {

    let reasonArray = ["사용하기 어려워요", "오류가 많아서 불편해요", "흥미가 없어졌어요","기타"]
    @IBOutlet weak var reasonTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func clickCloseBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setUI(){
        reasonTableView.delegate = self
        reasonTableView.dataSource = self
    }
   

}

extension LeaveReasonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
