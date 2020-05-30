//
//  PopUp2ViewController.swift
//  90's
//
//  Created by 조경진 on 2020/05/03.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class PopUp2ViewController: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    
    @IBOutlet weak var PopupView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    
    var albumName:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 8
        PopupView.layer.cornerRadius = 14
        contentTextView.text = "입금확인이 된 이후 영업일 기준 당일에\n\(albumName!)가 도착합니다. 안전하게 댁까지 전달해드릴게요!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // iPhone X..
                if UIScreen.main.nativeBounds.height >= 1792.0 {
                    
                    self.topConstraint.constant = 305
                }
                    // iPhone 8..
                else if UIScreen.main.nativeBounds.height <= 1334.0
                {
                    self.topConstraint.constant = 230
                    
                }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ok(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
