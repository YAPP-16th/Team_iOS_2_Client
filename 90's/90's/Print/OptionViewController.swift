//
//  OptionViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class OptionViewController : UIViewController {
    
    
    @IBOutlet weak var BottomViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var FirstOptionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var SecondOptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var OptionView: UIView!
    @IBOutlet weak var CompleteBtn: UIButton!
    @IBOutlet weak var FirstOptionView: UIView!
    @IBOutlet weak var SecondOptionView: UIView!
    
    @IBOutlet weak var stackViewConnected: NSLayoutConstraint!
    var isTotalOptionViewAppear = false
    var isFirstOptionViewAppear = true
    var isSecondOptionViewAppear = true

    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        if !isTotalOptionViewAppear {
            self.BottomViewConstraint.constant = self.view.frame.height
            self.FirstOptionView.isHidden = true
            self.SecondOptionView.isHidden = true
            self.FirstOptionConstraint.constant = 0
            self.SecondOptionConstraint.constant = 0
            self.stackViewConnected.constant = 63.5
        }
        
        
    }
    
    
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
        self.view.backgroundColor = .white
        self.BottomViewConstraint.constant = self.view.frame.height
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
    
    
}
