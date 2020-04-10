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
    
    
    //MARK: View IBOutlet
    @IBOutlet weak var OptionView: UIView!
    @IBOutlet weak var CompleteBtn: UIButton!
    @IBOutlet weak var FirstOptionView: UIView!
    @IBOutlet weak var SecondOptionView: UIView!
    @IBOutlet weak var countOptionView: UIView!
    
    @IBOutlet weak var totalSum1: UILabel!
    @IBOutlet weak var totalSum2: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    var isTotalOptionViewAppear = false
    var isFirstOptionViewAppear = true
    var isSecondOptionViewAppear = true
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        self.totalCount.text = "00"
        
        if !isTotalOptionViewAppear {
            self.BottomViewConstraint.constant = self.view.frame.height
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            self.countOptionView.isHidden = true
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 63.5
            self.countOptionViewConstraint.constant = self.view.frame.height
        }
        
        
    }
    
    //MARK: View IBAction
    @IBAction func OptionClick(_ sender: Any) {
        
        isTotalOptionViewAppear = !isTotalOptionViewAppear
        
        if isTotalOptionViewAppear {
            
            self.BottomViewConstraint.constant = self.view.frame.height
        } else {
            self.view.backgroundColor = .darkGray
            self.BottomViewConstraint.constant = 450
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
        
        self.countOptionViewConstraint.constant = 431
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

//        self.navigationController?.title = "결제 내역"
        vc.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(vc, animated: true)
        self.show(vc, sender: nil)
    }
    
    @IBAction func minusBtnAction(_ sender: Any) {
        self.totalCount.text = "stepper 쓰자"
    }
    
    @IBAction func plusBtnAction(_ sender: Any) {
        self.totalCount.text = "stepper 쓰자"
    }
    
    
    
}
