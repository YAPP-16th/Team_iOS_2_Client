//
//  PopUpViewController.swift
//  90's
//
//  Created by 조경진 on 2020/05/03.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var OkBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Ok(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OkBtn.layer.cornerRadius = 8
        popupView.layer.cornerRadius = 14
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // iPhone X..
                if UIScreen.main.nativeBounds.height == 1792.0 {
                    
                    self.topConstraint.constant = 305
                }
                    // iPhone 8..
                else if UIScreen.main.nativeBounds.height == 1334.0
                {
                    self.topConstraint.constant = 230
                    
                }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
