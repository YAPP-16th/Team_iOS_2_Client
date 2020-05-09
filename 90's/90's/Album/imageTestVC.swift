//
//  imageTestVC.swift
//  90's
//
//  Created by 성다연 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class imageTestVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func button(_ sender: UIButton) {
        print("button clicked!")

        AlbumService.shared.photoDownload(albumUid: 66, photoUid: 68, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    print("photoDownload loading!")
                    guard let data = response.data else {return}
                    let testImage = UIImage(data: data)
                    print("photoDownload : \(testImage)")
                    let decoder = try? JSONDecoder().decode(PhotoDownloadData.self, from: data)
                    self.image = UIImage(data: data)
                    self.imageView.image = self.image
                case 401...404:
                    print("forbidden access in \(status)")
                default:
                    return
                }
            }
        })
    }
    
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
