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
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var firstFlapBtn: UIButton!
    @IBOutlet weak var secondFlapBtn: UIButton!
    
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var advanceBtn: UIButton!
    @IBOutlet weak var superAdBtn: UIButton!
    
    @IBOutlet weak var noramlShipBtn: UIButton!
    @IBOutlet weak var advanceShipBtn: UIButton!
    @IBOutlet weak var superAdShipBtn: UIButton!
    
    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var shipLabel: UILabel!
    
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    
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
    
    
    override func viewDidLoad() {
//        self.view.backgroundColor = .white
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
        
        // iPhone X..
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
            self.previewImageHeight.constant = 196
            self.topConstraint.constant = 88
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.previewImageHeight.constant = 187
            self.topConstraint.constant = 80
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
        
        self.coverImageView.image = tempImage
        
        normalBtn.isSelected = false
        advanceBtn.isSelected = false
        superAdBtn.isSelected = false
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
    
    //MARK: View IBAction
    @IBAction func OptionClick(_ sender: Any) {
        
        
        
        isTotalOptionViewAppear = !isTotalOptionViewAppear
        
        
        if isTotalOptionViewAppear {
            self.BottomViewConstraint.constant = self.view.frame.height
            self.scrollView.isScrollEnabled = true
        }
        else
        {
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
            
            self.FirstOptionConstraint.constant = 239
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 50.5 + 239
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
                self.completeBtnTopConstraint.constant = 0
                
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
                self.completeBtnTopConstraint.constant = 0
                
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
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderFinishViewController") as! OrderFinishViewController
//
//        vc.modalPresentationStyle = .fullScreen
//        self.navigationItem.title = " "
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "iconBack")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "iconBack")
//        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//
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
    
    
    @IBAction func normalClick(_ sender: Any) {
        cal1 = !cal1
        calc =  0
        print(calc)
        normalBtn.isSelected = true
        advanceBtn.isSelected = false
        superAdBtn.isSelected = false
        normalBtn.setImage(UIImage(named: "ovalSelectOption"), for: .selected)
        self.printLabel.text = "유광"
        
        if (noramlShipBtn.isSelected  == true || advanceBtn.isSelected == true || superAdBtn.isSelected == true) && ( normalBtn.isSelected == true || advanceShipBtn.isSelected == true || superAdShipBtn.isSelected == true)
        {
            CompleteBtn.backgroundColor = .black
        }
        
    }
    
    @IBAction func adClick(_ sender: Any) {
        cal2 = !cal2
        if cal2 {
            calc = calc + 0
        }
        else {
            calc = calc - 0
        }
        print(calc)
        normalBtn.isSelected = false
        advanceBtn.isSelected = true
        superAdBtn.isSelected = false
        advanceBtn.setImage(UIImage(named: "ovalSelectOption"), for: .selected)
        self.printLabel.text = "무광"
        
        if (noramlShipBtn.isSelected  == true || advanceBtn.isSelected == true || superAdBtn.isSelected == true) && ( normalBtn.isSelected == true || advanceShipBtn.isSelected == true || superAdShipBtn.isSelected == true)
        {
            CompleteBtn.backgroundColor = .black
        }
        
    }
    
    @IBAction func ad2Click(_ sender: Any) {
        cal3 = !cal3
        if cal3 {
            calc = calc + 0
        }
        else {
            calc = calc - 0
        }
        print(calc)
        normalBtn.isSelected = false
        advanceBtn.isSelected = false
        superAdBtn.isSelected = true
        superAdBtn.setImage(UIImage(named: "ovalSelectOption"), for: .selected)
        self.printLabel.text = "랜덤"
        
        if (noramlShipBtn.isSelected  == true || advanceBtn.isSelected == true || superAdBtn.isSelected == true) && ( normalBtn.isSelected == true || advanceShipBtn.isSelected == true || superAdShipBtn.isSelected == true)
        {
            CompleteBtn.backgroundColor = .black
        }
        
    }
    
    @IBAction func normalShipClick(_ sender: Any) {
        cal4 = !cal4
        calc =  0
        print(calc)
        noramlShipBtn.isSelected = true
        advanceShipBtn.isSelected = false
        superAdShipBtn.isSelected = false
        noramlShipBtn.setImage(UIImage(named: "ovalSelectOption"), for: .selected)
        self.shipLabel.text = "일반"
        
        if (noramlShipBtn.isSelected  == true || advanceBtn.isSelected == true || superAdBtn.isSelected == true) && ( normalBtn.isSelected == true || advanceShipBtn.isSelected == true || superAdShipBtn.isSelected == true)
        {
            CompleteBtn.backgroundColor = .black
        }
    }
    
    
    
    @IBAction func adShipClick(_ sender: Any) {
        cal5 = !cal5
        if cal5 {
            calc = calc + 5000
        }
        else {
            calc = calc - 5000
        }
        noramlShipBtn.isSelected = false
        advanceShipBtn.isSelected = true
        superAdShipBtn.isSelected = false
        advanceShipBtn.setImage(UIImage(named: "ovalSelectOption"), for: .selected)
        self.shipLabel.text = "특급"
        
        if (noramlShipBtn.isSelected  == true || advanceBtn.isSelected == true || superAdBtn.isSelected == true) && ( normalBtn.isSelected == true || advanceShipBtn.isSelected == true || superAdShipBtn.isSelected == true)
        {
            CompleteBtn.backgroundColor = .black
        }
    }
    
    

    
    @IBAction func adShipInfo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Print", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
                
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func superShipinfo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Print", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "PopUp2ViewController") as! PopUp2ViewController
                      
              vc.modalTransitionStyle = .crossDissolve
              vc.modalPresentationStyle = .overCurrentContext
              self.present(vc, animated: true, completion: nil)
              
        
    }
    
    
    @IBAction func ad2ShipClick(_ sender: Any) {
        cal6 = !cal6
        if cal6 {
            calc = calc + 10000
        }
        else {
            calc = calc - 10000
        }
        noramlShipBtn.isSelected = false
        advanceShipBtn.isSelected = false
        superAdShipBtn.isSelected = true
        superAdShipBtn.setImage(UIImage(named: "ovalSelectOption"), for: .selected)
        self.shipLabel.text = "등기"
        
        if (noramlShipBtn.isSelected  == true || advanceBtn.isSelected == true || superAdBtn.isSelected == true) && ( normalBtn.isSelected == true || advanceShipBtn.isSelected == true || superAdShipBtn.isSelected == true)
        {
            CompleteBtn.backgroundColor = .black
        }
        
        
    }
    
}
