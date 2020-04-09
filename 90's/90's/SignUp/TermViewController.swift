//
//  TermViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol ClickDelegate : NSObjectProtocol {
    func cellClick(isClicked : Bool)
    
}



class TermViewController: UIViewController {
    
    @IBOutlet weak var termTableView: UITableView!
    @IBOutlet weak var agreeAllTermBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    let termTitle = ["이용약관 (필수)", "카메라 및 앨범 (필수)", "마케팅 정보 (필수)"]
    var isAllTermBtnClicked = false
    var agreeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termTableView.delegate = self
        termTableView.dataSource = self
    }
    
    @IBAction func agreeAllTerms(_ sender: Any) {
        let cellArr = termTableView.visibleCells
        
        for cell in cellArr {
            let cell = cell as! TermCell
            if(!isAllTermBtnClicked){
                cell.isClicked = true
            } else {
                cell.isClicked = false
            }
        }
        
        isAllTermBtnClicked = !isAllTermBtnClicked
        
        if(isAllTermBtnClicked){
            agreeAllTermBtn.backgroundColor = UIColor.black
            okBtn.backgroundColor = UIColor.black
        }else {
            agreeAllTermBtn.backgroundColor = UIColor.gray
            okBtn.backgroundColor = UIColor.gray
        }
        self.termTableView.reloadData()
    }
    
    @IBAction func clickOkBtn(_ sender: Any) {
    }
    
}





extension TermViewController : UITableViewDelegate {
    
}

extension TermViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermCell") as! TermCell
        
        cell.clickDelegate = self
        cell.termTitle.text = termTitle[indexPath.row]
        cell.indexPath = indexPath
        
        
        return cell
    }
    
}

extension TermViewController : ClickDelegate {
    func cellClick(isClicked: Bool) {
        if(isClicked) {
            agreeCount += 1
        }else {
            agreeCount -= 1
        }
        termTableView.reloadData()
        
        if(agreeCount == 3){
            okBtn.backgroundColor = UIColor.black
            agreeAllTermBtn.backgroundColor = UIColor.black
            okBtn.isEnabled = true
        }else {
            okBtn.backgroundColor = UIColor.gray
            agreeAllTermBtn.backgroundColor = UIColor.gray
            okBtn.isEnabled = false
        }
    }
    
    
}


