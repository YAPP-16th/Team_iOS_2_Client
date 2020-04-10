//
//  CheckPhotoViewController.swift
//  90's
//
//  Created by 조경진 on 2020/03/29.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class CheckPhotoViewController : UIViewController {

    @IBOutlet weak var CheckImageView: UIImageView!
    var tempImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        CheckImageView.image = tempImage
    }

    @IBAction func saveAction(_ sender: Any) {
        print("!!!!!")
        AlbumDatabase.arrayList[0].photos.append(CheckImageView.image!)
        self.dismiss(animated: true, completion: nil)
        print("!!!!!")
    }

    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
