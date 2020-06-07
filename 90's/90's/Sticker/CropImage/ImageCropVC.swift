//
//  ImageCropVC.swift
//  90's
//
//  Created by 성다연 on 2020/06/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ImageCropVC: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var layoutImageView: UIImageView!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtn(_ sender: UIButton) { nextVC() }
    
    var image : UIImage?
    var selectedLayout : AlbumLayout! = .Polaroid
    var albumUid : Int = 0
    var imageName : String = ""
    var cropArea : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension ImageCropVC : UIScrollViewDelegate {
    
}


extension ImageCropVC {
    func defaultSetting(){
        photoImageView.image = image
        layoutImageView.image = selectedLayout.cropImage
        layoutImageView.center = view.center
        
        let deviceSize = iPhone8Model() ?
            returnLayoutStickerLowDeviceSize(selectedLayout: selectedLayout) :
            returnLayoutStickerHighDeviceSize(selectedLayout: selectedLayout)
        
        layoutImageView = applyBackImageViewLayout(selectedLayout: selectedLayout, smallBig: deviceSize, imageView: layoutImageView)
        setRenderLayoutViewFrameSetting(view: view, imageView: layoutImageView)
    }
    
    func nextVC(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "imageRenderVC") as! ImageRenderVC
        
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.image = image
        nextVC.selectLayout = self.selectedLayout
        nextVC.albumUid = self.albumUid
        nextVC.imageName = self.imageName
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
