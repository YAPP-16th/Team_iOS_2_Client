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
        
//        AlbumService.shared.photoUpload(albumUid: "3", image: UIImage(named: "husky")!, photoOrder: "100", completion: {
//            response in
//            if let status = response.response?.statusCode {
//                switch status {
//                case 200:
//                    guard let data = response.data else {return}
//                    print("received data = \(data)")
//                case 401...404 :
//                    print("forbidden access in \(status)")
//                default:
//                    return
//                }
//            }
//        })
        
        AlbumService.shared.photoDownload(albumUid: 3, photoUid: 100, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    let testImage = UIImage(data: data)
                    //let decoder = try? JSONDecoder().decode(PhotoDownloadData.self, from: data)
                    print("testImage = \(testImage?.size)")
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
