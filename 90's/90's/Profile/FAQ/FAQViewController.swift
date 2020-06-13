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
    
    
    var faqList = [FAQ(question: "90’s 내 실물 앨범은 어떻게 받나요?", answer: "하단 탭 바의 좌측에 있는 아이콘을 클릭하여 ‘앨범 신청하기’를 누르신 후, ‘인화 용지’와 ‘배송’을 선택해 주세요. ‘배송 정보’ 내 ‘수령인,’ ‘배송지,’ ‘연락처’를  적으신 후 하단의 계좌로 무통장 입금해주세요. 영업일 기준 48시간 내로 결제확인 메일을 보내드립니다."),
                   FAQ(question: "90’s의 가격은 어떻게 측정되나요?", answer: "주문하신 앨범의 레이아웃에 맞추어 앨범을 맞춤 제작하게 됩니다. 레이아웃의 사진 수에 상관없이 사진 한 장당 1,000원의 가격이 측정됩니다. 이후 원하시는 배송 형태에 따라 추가적은 요금이 부과됩니다."),
                   FAQ(question: "결제 후 아무런 인증 메일이 오지 않았습니다.", answer: "금액을 송금하신 계좌의 입금 주명과 예금주를 재확인해주시기 바랍니다. 공휴일, 주말을 제외한 영업일 기준 48시간 이내 90’s로부터 회신이 오지 않았다면 지불하신 금액은 자동 환급됩니다."),
                   FAQ(question: "환불정책은 어떻게 되나요?", answer: "90’s는 모든 앨범을 수작업으로 제작하기에 주문이 들어간 이후에는 환불이 불가합니다. 그러나 ‘입금 대기’ 상태에서는 아직 주문이 들어가지 않았기에 환불이 가능합니다. ‘주문 상세’로 들어가신 다음 ‘주문 취소’를 눌러주세요."),
                   FAQ(question: "예상했던 결과물과 다른 앨범이 나온 것 같아요.\n후속조치를 어떻게 취할까요?", answer: "처음 앨범을 생성했을 때 나오는 ‘앨범커버’와 ‘레이아웃’을 토대로 주문제작이 들어가게 됩니다. 레이아웃이 스크린에 보이게 되는 사진의 개수가, 실제 앨범에 나타나는 사진의 개수와 동일합니다. (예시: ‘polaroid’ 레이아웃의 경우 수령하시는 실제 앨범에 4개의 사진이 한 페이지에 들어가게 됩니다)"),
                   FAQ(question: "이메일/비밀번호를 잊어버렸어요.", answer: "‘로그인’ 화면 하단에 위치한 ‘이메일 찾기’와 ‘비밀번호 찾기’를 통해 찾아주세요."),
                   FAQ(question: "전화번호를 변경하고 싶어요.", answer: "‘내 정보 관리’에 들어가셔서 비밀번호를 입력하시고 전화번호를 수정해주세요."),
                   FAQ(question: "휴대폰 인증 문자를 받지 못했어요.", answer: "휴대폰의 스팸함을 확인해주세요. 스팸함에 없는 경우, 통신사에 따라 인증 발송/차단 해제에 시간이 소요될 수 있으며 자세한 사항은 통신사로 문의해주세요."),
                   FAQ(question: "푸시 알람을 끄고 싶어요.", answer: "‘프로필’ 내 ‘설정’에 들어가셔서, 푸시 알람을 설정해주세요. 푸시 알람을 끄시면 90s가 제공하는 다양한 혜택을 받아보실 수 없습니다."),
                   FAQ(question: "회원 탈퇴를 하고 싶어요.", answer: "프로필 우측 하단의 ‘회원 탈퇴’를 클릭해주세요. 모든 개인정보는 ‘개인정보처리 약관’에 삭제됩니다.")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUI(){
        self.tabBarController?.tabBar.isHidden = true
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
