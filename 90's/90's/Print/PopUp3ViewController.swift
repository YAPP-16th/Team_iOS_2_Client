
//  PopUp2ViewController.swift
//  90's
//
//  Created by 조경진 on 2020/05/03.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class PopUp3ViewController: UIViewController {

    @IBOutlet weak var OKBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var PopUpView3: UIView!
    
    @IBOutlet weak var TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ContentTextView: UITextView!

    var albumName:String!


    override func viewDidLoad() {
        super.viewDidLoad()
        OKBtn.layer.cornerRadius = 8
        PopUpView3.layer.cornerRadius = 14
        ContentTextView.text = "입금확인이 된 이후 영업일 기준 당일에\n\(albumName!)가 도착합니다. 안전하게 댁까지 전달해드릴게요!"
    }

    override func viewWillAppear(_ animated: Bool) {

        // iPhone X..
                if UIScreen.main.nativeBounds.height >= 1792.0 {

                    self.TopConstraint.constant = 305
                }
                    // iPhone 8..
                else if UIScreen.main.nativeBounds.height <= 1334.0
                {
                    self.TopConstraint.constant = 230

                }

    }

    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func OK(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
