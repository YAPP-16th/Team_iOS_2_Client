//
//  OrderFinishViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class OrderFinishViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//           self.tabBarController?.tabBar.isHidden = false
           self.navigationController?.navigationBar.isHidden = false
       }
    
    
    @IBAction func cancelgotoAlbum(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
