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
    
    //MARK: View IBOutlet
    @IBOutlet weak var OptionView: UIView!
    @IBOutlet weak var CompleteBtn: UIButton!
    @IBOutlet weak var FirstOptionView: UIView!
    @IBOutlet weak var SecondOptionView: UIView!
    @IBOutlet weak var countOptionView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var totalSum1: UILabel!
    @IBOutlet weak var totalSum2: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    //    @IBOutlet weak var coverCollectionView: UICollectionView!
    @IBOutlet weak var firstFlapBtn: UIButton!
    @IBOutlet weak var secondFlapBtn: UIButton!
    
    var isTotalOptionViewAppear = false
    var isFirstOptionViewAppear = true
    var isSecondOptionViewAppear = true
    var coverImage : UIImage? = nil
    var cal1 = false
    var cal2 = false
    var cal3 = false
    var cal4 = false
    var cal5 = false
    var cal6 = false
    
    var calc : Int = 0
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        self.totalCount.text = "0"
        
        if !isTotalOptionViewAppear {
            self.BottomViewConstraint.constant = self.view.frame.height
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            self.countOptionView.isHidden = true
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 0
            self.completeBtnConstraint.constant = 0
//            self.stackViewConnected.constant = 63.5
            self.countOptionViewConstraint.constant = self.view.frame.height
        }
        
        self.coverImageView.image = UIImage(named: "testEmpty")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        //        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: View IBAction
    @IBAction func OptionClick(_ sender: Any) {
        
        isTotalOptionViewAppear = !isTotalOptionViewAppear
        
        if isTotalOptionViewAppear {
            
            self.BottomViewConstraint.constant = self.view.frame.height
        } else {
            self.view.backgroundColor = .darkGray
            
            if UIScreen.main.nativeBounds.height == 1792.0 {
                
                self.BottomViewConstraint.constant = 450 - 145
                
                //            self.outputimageViewConstraint.constant = 135
            }
            else if UIScreen.main.nativeBounds.height == 1334.0
            {
                self.BottomViewConstraint.constant = 450 - 88
                
                //            self.outputimageViewConstraint.constant = 88
            }
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        self.view.backgroundColor = .white
        self.BottomViewConstraint.constant = self.view.frame.height
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
    
    
    @IBAction func CompleteBtn(_ sender: Any) {
        self.view.backgroundColor = .darkGray
        
        self.BottomViewConstraint.constant = self.view.frame.height
        self.totalSum1.text = String(calc)
        self.totalSum2.text = String(calc)
        print(self.view.frame.height)
        if UIScreen.main.nativeBounds.height == 1792.0 {
            self.countOptionViewConstraint.constant = self.view.frame.height - 443
            
            //            self.outputimageViewConstraint.constant = 135
        }
        else if UIScreen.main.nativeBounds.height == 1334.0
        {
            self.countOptionViewConstraint.constant = self.view.frame.height - 443             
            //            self.outputimageViewConstraint.constant = 88
        }
        
        self.countOptionView.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
    
    @IBAction func FirstOptionClick(_ sender: Any) {
        
        isFirstOptionViewAppear = !isFirstOptionViewAppear
        
        if isFirstOptionViewAppear {
            
            self.FirstOptionConstraint.constant = 260
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 63.5 + 260
            self.FirstOptionView.isHidden = false
            self.SecondOptionView.isHidden = true
            
        } else {
            
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 63.5 
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func SecondOptionClick(_ sender: Any) {
        
        isSecondOptionViewAppear = !isSecondOptionViewAppear
        
        if isSecondOptionViewAppear {
            
            self.SecondOptionConstraint.constant = 260
            self.FirstOptionConstraint.constant = 0
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = false
        } else {
            self.SecondOptionConstraint.constant = 0
            self.FirstOptionConstraint.constant = 0
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
        
    }
    @IBAction func countOptionCancelClick(_ sender: Any) {
        
        self.view.backgroundColor = .white
        self.countOptionViewConstraint.constant = self.view.frame.height
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
    
    @IBAction func orderAction(_ sender: Any) {
        
        self.view.backgroundColor = .white
        self.countOptionViewConstraint.constant = self.view.frame.height
        //
        //        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderFinishViewController") as! OrderFinishViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func minusBtnAction(_ sender: Any) {
        let old = Int(self.totalCount.text ?? "0")
        
        self.totalCount.text = String(old! - 1)
        self.totalSum1.text = String(calc * old!) + "원"
        self.totalSum2.text = String(calc * old!) + "원"
    }
    
    @IBAction func plusBtnAction(_ sender: Any) {
        let old = Int(self.totalCount.text ?? "0")
        self.totalCount.text = String(old! + 1)
        self.totalSum1.text = String(calc * old!) + "원"
        self.totalSum2.text = String(calc * old!) + "원"
    }
    
    @IBAction func normalClick(_ sender: Any) {
        cal1 = !cal1
        calc =  0
    }
    
    @IBAction func adClick(_ sender: Any) {
        cal2 = !cal2
        if cal2 {
            calc = calc + 1500
        }
        else {
            calc = calc - 1500
        }
    }
    
    @IBAction func ad2Click(_ sender: Any) {
        cal3 = !cal3
        if cal3 {
            calc = calc + 3000
        }
        else {
            calc = calc - 3000
        }
    }
    
    @IBAction func normalShipClick(_ sender: Any) {
        cal4 = !cal4
        calc =  0
    }
    
    @IBAction func adShipClick(_ sender: Any) {
        cal5 = !cal5
        if cal5 {
            calc = calc + 1500
        }
        else {
            calc = calc - 1500
        }
    }
    
    @IBAction func ad2ShipClick(_ sender: Any) {
        cal6 = !cal6
        if cal6 {
            calc = calc + 3000
        }
        else {
            calc = calc - 3000
        }
    }
    
}
