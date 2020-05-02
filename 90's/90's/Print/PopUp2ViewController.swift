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
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ok(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 8
        PopupView.layer.cornerRadius = 14
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
