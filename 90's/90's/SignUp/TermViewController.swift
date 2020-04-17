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
    func indicatorClick(index : Int)
}


class TermViewController: UIViewController {
    
    @IBOutlet weak var termTableView: UITableView!
    @IBOutlet weak var agreeAllTermBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    let termTitle = ["이용약관 (필수)", "개인정보 수집 및 이용동의 (필수)", "연령(만 14세 이상)확인 (필수)"]
    var isAllTermBtnClicked = false
    var agreeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            agreeAllTermBtn.setBackgroundImage(UIImage(named: "checkboxInact"), for: .normal)
            okBtn.backgroundColor = UIColor(displayP3Red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
            okBtn.isEnabled = true
        }else {
            agreeAllTermBtn.setBackgroundImage(UIImage(named: "checkboxgray"), for: .normal)
            okBtn.backgroundColor = UIColor(displayP3Red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
            okBtn.isEnabled = false
        }
        self.termTableView.reloadData()
    }
    
    @IBAction func clickOkBtn(_ sender: Any) {
        let emailVC = storyboard?.instantiateViewController(identifier: "EmailViewController") as! EmailViewController
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    func setUI(){
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        termTableView.delegate = self
        termTableView.dataSource = self
        okBtn.isEnabled = false
        okBtn.layer.cornerRadius = 8.0
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
        cell.indexNumber = indexPath.row
        cell.clickDelegate = self
        cell.termTitle.text = termTitle[indexPath.row]
        
        return cell
    }
    
}

extension TermViewController : ClickDelegate {
    func indicatorClick(index: Int) {
        let termDetailVC = storyboard?.instantiateViewController(identifier: "TermDetailViewController") as! TermDetailViewController
        self.navigationController?.pushViewController(termDetailVC, animated: true)
//        switch index {
//        case 0:
//
//        case 1:
//
//        case 2:
//
//        default:
//
//        }
    }
    
    func cellClick(isClicked: Bool) {
        if(isClicked) {
            agreeCount += 1
        }else {
            agreeCount -= 1
        }
        termTableView.reloadData()
        
        if(agreeCount == 3){
            agreeAllTermBtn.setBackgroundImage(UIImage(named: "checkboxInact"), for: .normal)
            okBtn.backgroundColor = UIColor(displayP3Red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
            okBtn.isEnabled = true
        }else {
            agreeAllTermBtn.setBackgroundImage(UIImage(named: "checkboxgray"), for: .normal)
            okBtn.backgroundColor = UIColor(displayP3Red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
            okBtn.isEnabled = false
        }
    }
    
    
}


