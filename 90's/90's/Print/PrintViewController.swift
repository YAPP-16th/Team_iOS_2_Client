//
//  PrintViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class PrintViewController : UIViewController {
    
    
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var firstOptionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondOptionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstOptionView: UIView!
    @IBOutlet weak var secondOptionView: UIView!
    
    var isTotalOptionViewAppear = false
    var isFirstOptionViewAppear = true
    var isSecondOptionViewAppear = true

    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        if !isTotalOptionViewAppear {self.bottomViewConstraint.constant = self.view.frame.height}
        if !isFirstOptionViewAppear {self.firstOptionConstraint.constant = 179}
        if !isSecondOptionViewAppear {self.secondOptionConstraint.constant = 179}
        
    }
    
    @IBAction func optionClick(_ sender: Any) {
        
        isTotalOptionViewAppear = !isTotalOptionViewAppear
        
        if isTotalOptionViewAppear {
            
            self.bottomViewConstraint.constant = self.view.frame.height
        } else {
            self.view.backgroundColor = .darkGray
            self.bottomViewConstraint.constant = 153
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.backgroundColor = .white
        self.bottomViewConstraint.constant = self.view.frame.height
         UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }


    @IBAction func completeBtn(_ sender: Any) {
        self.view.backgroundColor = .white
        self.bottomViewConstraint.constant = self.view.frame.height
         UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
    
    @IBAction func firstOptionClick(_ sender: Any) {
        
        isFirstOptionViewAppear = !isFirstOptionViewAppear
        
        if isFirstOptionViewAppear {
            
            self.firstOptionConstraint.constant = 19
            
        } else {
            self.firstOptionConstraint.constant = 179
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func secondOptionClick(_ sender: Any) {
        
        isSecondOptionViewAppear = !isSecondOptionViewAppear
        
        if isSecondOptionViewAppear {
            
            self.secondOptionConstraint.constant = 19
        } else {
            self.secondOptionConstraint.constant = 179
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
        
    }
    
}
