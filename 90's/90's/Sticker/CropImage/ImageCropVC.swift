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
    var cropArea : CGRect {
        get{
            let factor = photoImageView.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = photoImageView.imageFrame()
            let x = (scrollView.contentOffset.x + layoutImageView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + layoutImageView.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = layoutImageView.frame.size.width * scale * factor
            let height = layoutImageView.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}
 

extension ImageCropVC : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
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
        let croppedCGImage = photoImageView.image?.cgImage?.cropping(to: cropArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        image = croppedImage
        scrollView.zoomScale = 1
        
        if image != nil {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "imageRenderVC") as! ImageRenderVC
            
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.image = image
            nextVC.selectLayout = self.selectedLayout
            nextVC.albumUid = self.albumUid
            nextVC.imageName = self.imageName
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

class CropAreaView: UIImageView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
