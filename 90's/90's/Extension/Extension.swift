//
//  Extension.swift
//  AlbumExample
//
//  Created by 성다연 on 24/03/2020.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import AVFoundation


extension String {
    //이메일 정규식 검증
    public func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}

extension Int {
    public func numberToPrice(_ price : Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result = numberFormatter.string(from: NSNumber(value:price))!
        return result
    }
}


extension UICollectionViewCell {
    func subImageViewSetting(imageView : UIImageView!, top : CGFloat!, left : CGFloat!, right: CGFloat!, bottom: CGFloat!){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: top).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: left).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -right).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -bottom).isActive = true
        
        imageView.contentMode = .scaleToFill
    }
}


extension UICollectionView {
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}


extension UIViewController{
    func checkDeviseVersion(backView: UIView!){
        if isDeviseVersionLow == false {
            backView.isHidden = false
        }else {
            backView.isHidden = true
        }
    }
    
    // LUT Filter apply
    func colorCubeFilterFromLUT(imageName : String, originalImage : UIImage)-> CIFilter? {
        let size = 64
        
        let lutImage    = UIImage(named: imageName)!.cgImage
        let lutWidth    = lutImage!.width
        let lutHeight   = lutImage!.height
        let rowCount    = lutHeight / size
        let columnCount = lutWidth / size
        
        if ((lutWidth % size != 0) || (lutHeight % size != 0) || (rowCount * columnCount != size)) {
            NSLog("Invalid colorLUT %@", imageName);
            return nil
        }
        
        let bitmap  = getBytesFromImage(image: UIImage(named: imageName))!
        let floatSize = MemoryLayout<Float>.size
        
        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: size * size * size * 4 * floatSize)
        var z = 0
        var bitmapOffset = 0
        
        for _ in 0 ..< rowCount {
            for y in 0 ..< size {
                let tmp = z
                for _ in 0 ..< columnCount {
                    for x in 0 ..< size {
                        let alpha   = Float(bitmap[bitmapOffset]) / 255.0
                        let red     = Float(bitmap[bitmapOffset+1]) / 255.0
                        let green   = Float(bitmap[bitmapOffset+2]) / 255.0
                        let blue    = Float(bitmap[bitmapOffset+3]) / 255.0
                        let dataOffset = (z * size * size + y * size + x) * 4
                        
                        cubeData[dataOffset + 3] = alpha
                        cubeData[dataOffset + 2] = red
                        cubeData[dataOffset + 1] = green
                        cubeData[dataOffset + 0] = blue
                        bitmapOffset += 4
                    }
                    z += 1
                }
                z = tmp
            }
            z += columnCount
        }
        
        let colorCubeData = NSData(bytesNoCopy: cubeData, length: size * size * size * 4 * floatSize, freeWhenDone: true)
        let ciOriginImage = CIImage(image: originalImage)
        
        // create CIColorCube Filter
        let filter = CIFilter(name: "CIColorCube")
        filter?.setValue(ciOriginImage, forKey: kCIInputImageKey)
        filter?.setValue(colorCubeData, forKey: "inputCubeData")
        filter?.setValue(size, forKey: "inputCubeDimension")
        
        return filter
    }
    
    
    func getBytesFromImage(image: UIImage?) -> [UInt8]? {
        var pixelValues: [UInt8]?
        if let imageRef = image?.cgImage {
            let width = Int(imageRef.width)
            let height = Int(imageRef.height)
            let bitsPerComponent = 8
            let bytesPerRow = width * 4
            let totalBytes = height * bytesPerRow
            
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
        }
        return pixelValues!
    }
    
    func returnLayoutSize(selectedLayout : AlbumLayout) -> CGSize{
        switch selectedLayout {
        case .Polaroid : return AlbumLayout.Polaroid.size
        case .Mini : return AlbumLayout.Mini.size
        case .Memory : return AlbumLayout.Memory.size
        case .Portrab : return AlbumLayout.Portrab.size
        case .Tape : return AlbumLayout.Tape.size
        case .Portraw : return AlbumLayout.Portraw.size
        case .Filmroll : return AlbumLayout.Filmroll.size
        }
    }
    
    func returnLayoutBigSize(selectedLayout : AlbumLayout) -> CGSize {
        switch selectedLayout {
        case .Polaroid : return AlbumLayout.Polaroid.bigsize
        case .Mini : return AlbumLayout.Mini.bigsize
        case .Memory : return AlbumLayout.Memory.bigsize
        case .Portrab : return AlbumLayout.Portrab.bigsize
        case .Tape : return AlbumLayout.Tape.bigsize
        case .Portraw : return AlbumLayout.Portraw.bigsize
        case .Filmroll : return AlbumLayout.Filmroll.bigsize
        }
    }
    
    func applyBackImageViewLayout(selectedLayout : AlbumLayout, smallBig: CGSize, imageView : UIImageView ) -> UIImageView {
        switch selectedLayout {
            
        case .Polaroid:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Polaroid.image
            return imageView
        case .Mini:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Mini.image
            return imageView
        case .Memory:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Memory.image
            return imageView
        case .Portrab:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Portrab.image
            return imageView
        case .Tape:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Tape.image
            return imageView
        case .Portraw:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Portraw.image
            return imageView
        case .Filmroll:
            imageView.frame = CGRect(x: 0, y: 0, width: smallBig.width, height: smallBig.height)
            imageView.image = AlbumLayout.Filmroll.image
            return imageView
        }
    }
    
    func applyImageViewLayout(selectedLayout : AlbumLayout, smallBig: CGSize, imageView : UIImageView, image : UIImage) -> UIImageView {
        var size : CGSize = CGSize(width: 0, height: 0)
        
        switch selectedLayout {
        case .Polaroid:
            size = CGSize(width: smallBig.width - 20, height: smallBig.height - 50)
            imageView.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Mini:
            size =  CGSize(width: smallBig.width - 24, height: smallBig.height - 48)
            imageView.frame = CGRect(x: 12, y: 9, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Memory:
            size = CGSize(width: smallBig.width - 48, height: smallBig.height - 52)
            imageView.frame = CGRect(x: 24, y: 26, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Portrab:
            size = CGSize(width: smallBig.width - 20, height: smallBig.height - 24)
            imageView.frame = CGRect(x: 10, y: 12, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Tape:
            size = CGSize(width: smallBig.width - 44, height: smallBig.height - 80)
            imageView.frame = CGRect(x: 23, y: 43, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Portraw:
            size = CGSize(width: smallBig.width - 18, height: smallBig.height - 30)
            imageView.frame = CGRect(x: 9, y: 15, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Filmroll:
            size = CGSize(width: smallBig.width - 68, height: smallBig.height - 6)
            imageView.frame = CGRect(x: 34, y: 3, width:size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        }
    }
    
    func setSaveViewLayout(view : UIView, selectLayout : AlbumLayout){
        let size = returnLayoutBigSize(selectedLayout: selectLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = size
        
        view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        let distance = (self.view.frame.width - view.frame.width) / 2
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: distance).isActive = true
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -distance).isActive = true
        view.addShadowEffect()
    }
    
    // 제네릭 적용
    func subLabelSetting(view : UILabel!, superView : UIView!, top : CGFloat?, left : CGFloat?, right: CGFloat?, bottom: CGFloat?){
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if top != nil { view.topAnchor.constraint(equalTo: superView.topAnchor,constant: top!).isActive = true
        }
        else if left != nil { view.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: left!).isActive = true
        }
        else if right != nil { view.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -right!).isActive = true
        }
        else if bottom != nil { view.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottom!).isActive = true
        }
        
        view.contentMode = .scaleToFill
    }
    
    func layoutSetting(albumLayout : AlbumLayout) -> String {
        switch albumLayout {
        case .Polaroid : return "Polaroid"
        case .Mini : return "Mini"
        case .Memory : return "Memory"
        case .Portrab : return "Portrab"
        case .Portraw : return "Portraw"
        case .Filmroll : return "Filmroll"
        case .Tape : return "Tape"
        }
    }
}


extension UIImage {
    func imageResize (sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension UIView {
    public func createImage() -> UIImage {
        print("create Image : frame is \(self.frame)")
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.frame.width, height: self.frame.height), true, 1)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}


extension UIColor {
    class func colorRGBHex(hex:Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue:CGFloat(b/255.0), alpha : CGFloat(alpha))
    }
}


extension UIImage {
    func mergeWith(topImage: UIImage,bottomImage: UIImage) -> UIImage {
        
        //    let bottomImage = self
        
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}

extension UIView {
    func addShadowEffect(){
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 7)
        self.clipsToBounds = false
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    func setRoundedCorner() {
        let roundedPath = UIBezierPath.init(roundedRect: UIView().bounds, byRoundingCorners: [.topRight , .bottomLeft , .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = roundedPath.cgPath
        layer.masksToBounds = true
        layer.mask = roundedLayer
    }
    
    
    // Set Rounded View
    func makeRounded(cornerRadius : CGFloat?){
        
        // UIView 의 모서리가 둥근 정도를 설정
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    
    func setBorder(borderColor : UIColor?, borderWidth : CGFloat?) {
        
        // UIView 의 테두리 색상 설정
        if let borderColor_ = borderColor {
            self.layer.borderColor = borderColor_.cgColor
        } else {
            // borderColor 변수가 nil 일 경우의 default
            self.layer.borderColor = UIColor(red: 205/255, green: 209/255, blue: 208/255, alpha: 1.0).cgColor
        }
        
        // UIView 의 테두리 두께 설정
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            // borderWidth 변수가 nil 일 경우의 default
            self.layer.borderWidth = 1.0
        }
    }
}
