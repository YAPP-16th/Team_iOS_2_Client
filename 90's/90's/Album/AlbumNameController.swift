//
//  AlbumNameController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation
import UIKit

class AlbumNameController : UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var tfAlbumName: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        tfAlbumName.becomeFirstResponder()
        tfAlbumName.delegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfAlbumName.endEditing(true)
    }

    
    
}

