//
//  FAQViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

struct FAQ {
    var question:String
    var answer:String
    var open = false
}

class FAQViewController: UIViewController {
    @IBOutlet weak var faqTableView: UITableView!
    
    var faqList = [FAQ(question: "어떻게 기부를 하나요가 무슨말이징", answer: "모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰"),
                   FAQ(question: "어떻게 기부를 하나요가 무슨말이징", answer: "모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰"),
                   FAQ(question: "질문이 있으신가요", answer: "모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰 모여서 각잡고 일하는 우리들에게 수비드를 해주는 수비드보이 현창쓰")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUI(){
        faqTableView.delegate = self
        faqTableView.dataSource = self
    }
    
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    //section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqList.count
    }
    
    //cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //만약 open = true이면 2개의 셀을 보여줌, [기본 셀1 + 펼쳐질 셀1]
        if(faqList[section].open == true) {
            return 2
        } else {
            return 1
        }
    }
    
    //cell 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //섹션의 0번째는 기본 셀, 1번째는 펼쳐질 셀이 됨
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! QuestionCell
            if(faqList[indexPath.section].open){
                cell.indicatorImage.image = UIImage(named: "pathCloseActionsheet")
            }else {
                cell.indicatorImage.image = UIImage(named: "pathOpenActionsheet")
            }
            cell.questionLabel.text = faqList[indexPath.section].question
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! AnswerCell
            cell.answerLabel.text = faqList[indexPath.section].answer
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? QuestionCell else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        
        if index.row == 0 {
            //열려있을 시 변수 변경
            print("\(indexPath.section) : \(faqList[indexPath.section].open)")
            if faqList[indexPath.section].open == true {
                faqList[indexPath.section].open = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }else {
                faqList[indexPath.section].open = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
    }
    
    
}
