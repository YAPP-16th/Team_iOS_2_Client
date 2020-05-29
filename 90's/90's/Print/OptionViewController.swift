//
//  OptionViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class OptionViewController : UIViewController {
    
    //MARK: Constraint IBOutlet
    @IBOutlet weak var BottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var FirstOptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var SecondOptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewConnected: NSLayoutConstraint!
    @IBOutlet weak var countOptionViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var completeBtnConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTopreviewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var completeBtnTopConstraint: NSLayoutConstraint!
    
    
    
    //MARK: View IBOutlet
    @IBOutlet weak var OptionView: UIView!
    @IBOutlet weak var CompleteBtn: UIButton!
    @IBOutlet weak var FirstOptionView: UIView!
    @IBOutlet weak var SecondOptionView: UIView!
    @IBOutlet weak var countOptionView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var totalSum1: UILabel!
    @IBOutlet weak var totalSum2: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var firstFlapBtn: UIButton!
    @IBOutlet weak var secondFlapBtn: UIButton!
    
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var advanceBtn: UIButton!
    
    @IBOutlet weak var noramlShipBtn: UIButton!
    @IBOutlet weak var superAdShipBtn: UIButton!
    @IBOutlet weak var advanceShipBtn: UIButton!
  
    
    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var shipLabel: UILabel!
    
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var coverNameLabel: UILabel!
    @IBOutlet weak var layoutLabel: UILabel!
    
    
    var isTotalOptionViewAppear = false
    var coverImage : UIImage? = nil
    var cal1 = false
    var cal2 = false
    var cal3 = false
    var cal4 = false
    var cal5 = false
    var cal6 = false
    var calc : Int = 0
    var tempImage: UIImage? = nil
    var albumInfo: album!
    var photoCount: Int!
    var totalPrice = 14300 //14300이 기존 가격
    var isClickPaperType = false
    var isClickShipType = false
    var paperType = ""
    var shipType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.isHidden = true
        
        self.totalCount.text = "1"
        self.printLabel.text = ""
        self.shipLabel.text = ""
        self.previewImage.image = self.coverImageView.image
        
        OptionView.layer.cornerRadius = 14
        countOptionView.layer.cornerRadius = 14
        nextBtn.layer.cornerRadius = 10
        CompleteBtn.layer.cornerRadius = 10
        orderBtn.layer.cornerRadius = 10
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height +
            UIApplication.shared.statusBarFrame.size.height
        print(navigationBarHeight)
        // iPhone X..
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
            self.previewImageHeight.constant = 196
            self.topConstraint.constant = navigationBarHeight
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.previewImageHeight.constant = 187
            self.topConstraint.constant = navigationBarHeight
        }
        
        if !isTotalOptionViewAppear {
            self.BottomViewConstraint.constant = self.view.frame.height
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            self.countOptionView.isHidden = true
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 0
            self.completeBtnConstraint.constant = 36
            self.stackViewConnected.constant = 50.5
            self.countOptionViewConstraint.constant = self.view.frame.height
            
        }
        
        
        let startDate = albumInfo.created_at.split(separator: "T")[0]
        let endDate = albumInfo.endDate
        let idxStartDate:String.Index = startDate.index(startDate.startIndex, offsetBy: 2)
        let idxEndDate:String.Index = endDate.index(endDate.startIndex, offsetBy: 2)
        let startDateStr = String(startDate[idxStartDate...]).replacingOccurrences(of: "-", with: ".")
        let endDateStr = String(endDate[idxEndDate...]).replacingOccurrences(of: "-", with: ".")
        
        
        let coverImage = getCoverByUid(value: albumInfo.cover.uid)
        coverImageView.image = coverImage
        albumNameLabel.text = albumInfo.name
        dateLabel.text = startDateStr + "~" + endDateStr
        photoCountLabel.text = "\(photoCount!)/\(albumInfo.photoLimit)"
        coverNameLabel.text = albumInfo.cover.name
        layoutLabel.text =  self.getLayoutByUid(value: albumInfo.layoutUid).layoutName
        
        
        normalBtn.isSelected = false
        advanceBtn.isSelected = false
        noramlShipBtn.isSelected = false
        advanceShipBtn.isSelected = false
        superAdShipBtn.isSelected = false
        secondFlapBtn.isSelected = false
        firstFlapBtn.isSelected = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: View IBAction
    @IBAction func OptionClick(_ sender: Any) {
        
        
        
        isTotalOptionViewAppear = !isTotalOptionViewAppear
        
        
        if isTotalOptionViewAppear {
            self.backView.isHidden = false
            self.scrollView.isScrollEnabled = false
            // iPhone X..
            if UIScreen.main.nativeBounds.height >= 1792.0 {
                
                self.BottomViewConstraint.constant = self.view.frame.height  - 516
                
            }
                // iPhone 8..
            else if UIScreen.main.nativeBounds.height <= 1334.0
            {
                self.BottomViewConstraint.constant = self.view.frame.height  - 516 + 30
                
            }
            
        }
        else
        {
            self.BottomViewConstraint.constant = self.view.frame.height
            self.scrollView.isScrollEnabled = true
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        self.scrollView.isScrollEnabled = true
        self.backView.isHidden = true
        self.BottomViewConstraint.constant = self.view.frame.height
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
    
    
    @IBAction func CompleteBtn(_ sender: Any) {
        
        self.backView.isHidden = false
        self.BottomViewConstraint.constant = self.view.frame.height
        self.totalSum1.text = String(calc)
        self.totalSum2.text = String(calc)
        self.countOptionViewConstraint.constant = self.view.frame.height - 443
        self.countOptionView.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
    
    @IBAction func FirstOptionClick(_ sender: Any) {
        
        firstFlapBtn.isSelected = !firstFlapBtn.isSelected
        
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
            self.BottomViewConstraint.constant = self.view.frame.height  - 516
            
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.BottomViewConstraint.constant = self.view.frame.height  - 516 + 30
            
        }
        
        if firstFlapBtn.isSelected {
            
            self.FirstOptionConstraint.constant = 175
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 50.5 + 175
            self.FirstOptionView.isHidden = false
            self.SecondOptionView.isHidden = true
            
            
        } else {
            
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 50.5
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            
            if CompleteBtn.backgroundColor == .black {
                self.BottomViewConstraint.constant = self.view.frame.height - 320
                self.completeBtnTopConstraint.constant = 10
                
            }
            
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func SecondOptionClick(_ sender: Any) {
        
        secondFlapBtn.isSelected = !secondFlapBtn.isSelected
        
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
            self.BottomViewConstraint.constant = self.view.frame.height  - 516
            
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.BottomViewConstraint.constant = self.view.frame.height  - 516 + 30
            
        }
        
        if firstFlapBtn.isSelected {
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 239
            self.stackViewConnected.constant = 50.5
            self.FirstOptionView.isHidden = true
            self.firstFlapBtn.isSelected = false
            self.SecondOptionView.isHidden = false
        }
        
        if secondFlapBtn.isSelected {
            
            self.SecondOptionConstraint.constant = 239
            self.FirstOptionConstraint.constant = 0
            self.FirstOptionView.isHidden = true
            self.firstFlapBtn.isSelected = false
            self.SecondOptionView.isHidden = false
            
        } else {
            self.SecondOptionConstraint.constant = 0
            self.FirstOptionConstraint.constant = 0
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            firstFlapBtn.isSelected = false
            
            if CompleteBtn.backgroundColor == .black {
                self.BottomViewConstraint.constant = self.view.frame.height - 320
                self.completeBtnTopConstraint.constant = 10
                
            }
            
            
        }
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
        
    }
    @IBAction func countOptionCancelClick(_ sender: Any) {
        self.backView.isHidden = true
        self.scrollView.isScrollEnabled = true
        self.countOptionViewConstraint.constant = self.view.frame.height
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        self.countOptionView.isHidden = true
    }
    
    @IBAction func orderAction(_ sender: Any) {
        
        self.backView.isHidden = true
        self.countOptionViewConstraint.constant = self.view.frame.height
        
        self.countOptionView.isHidden = true
        
        let finalOrderVC = storyboard?.instantiateViewController(withIdentifier: "OrderFinalViewController") as! OrderFinalViewController
        self.navigationController?.pushViewController(finalOrderVC, animated: true)
        
    }
    
    
    
    @IBAction func minusBtnAction(_ sender: Any) {
        var old = Int(self.totalCount.text ?? "1")
        old! = old! - 1
        self.totalCount.text = String(old!)
        self.totalSum1.text = String(calc * old!)
        self.totalSum2.text = String(calc * old!)
    }
    
    @IBAction func plusBtnAction(_ sender: Any) {
        var old = Int(self.totalCount.text ?? "1")
        old! = old! + 1
        self.totalCount.text = String(old!)
        self.totalSum1.text = String(calc * old!)
        self.totalSum2.text = String(calc * old!)
    }
    
    
    
    //종이 타입 클릭 시
    @IBAction func paperTypeClick(_ sender: Any) {
        if(!isClickPaperType) {
            isClickPaperType = !isClickPaperType
        }
        
        let btn = sender as! UIButton
        
        if(btn.tag == 1){
            normalBtn.isSelected = true
            advanceBtn.isSelected = false
        }else if(btn.tag == 2){
            normalBtn.isSelected = false
            advanceBtn.isSelected = true
        }
        
        if (isClickShipType){
            CompleteBtn.backgroundColor = .black
        }
        
    }
    
    
    //배송 타입 클릭 시
    @IBAction func shipTypeClick(_ sender: Any) {
        if(!isClickShipType) {
            isClickShipType = !isClickShipType
        }
        
        let btn = sender as! UIButton
        
        if(btn.tag == 3){
            noramlShipBtn.isSelected = true
            advanceShipBtn.isSelected = false
            superAdShipBtn.isSelected = false
        }else if(btn.tag == 4){
            noramlShipBtn.isSelected = false
            superAdShipBtn.isSelected = true
            advanceShipBtn.isSelected = false
        }else if(btn.tag == 5){
            noramlShipBtn.isSelected = false
            superAdShipBtn.isSelected = false
            advanceShipBtn.isSelected = true
        }
        
        if (isClickPaperType){
            CompleteBtn.backgroundColor = .black
        }
        
    }
    
    

    //일반 배송 info 버튼 클릭 시
    @IBAction func adShipInfo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Print", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //등기 배송 info 버튼 클릭 시
    @IBAction func superShipinfo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Print", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUp2ViewController") as! PopUp2ViewController
        vc.albumName = albumInfo.name
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
}
