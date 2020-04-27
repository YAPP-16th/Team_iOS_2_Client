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


extension UIView {
    public func addShadowEffect(){
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 7)
        self.clipsToBounds = false
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
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
    
    func clickSetting(imageView : UIImageView!, hidden : Bool){
        imageView.isHidden = !imageView.isHidden
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
    
    func applyBackImageViewLayout(selectedLayout : AlbumLayout, imageView : UIImageView ) -> UIImageView {
        switch selectedLayout {
            case .Polaroid:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Polaroid.size.width, height: AlbumLayout.Polaroid.size.height)
                imageView.image = AlbumLayout.Polaroid.image
                return imageView
            case .Mini:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Mini.size.width, height: AlbumLayout.Mini.size.height)
                imageView.image = AlbumLayout.Mini.image
                return imageView
            case .Memory:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Memory.size.width, height: AlbumLayout.Memory.size.height)
                imageView.image = AlbumLayout.Memory.image
                return imageView
            case .Portrab:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Portrab.size.width, height: AlbumLayout.Portrab.size.height)
                imageView.image = AlbumLayout.Portrab.image
                return imageView
            case .Tape:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Tape.size.width, height: AlbumLayout.Tape.size.height)
                imageView.image = AlbumLayout.Tape.image
                return imageView
            case .Portraw:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Portraw.size.width, height: AlbumLayout.Portraw.size.height)
                imageView.image = AlbumLayout.Portraw.image
                return imageView
            case .Filmroll:
                imageView.frame = CGRect(x: 0, y: 0, width: AlbumLayout.Filmroll.size.width, height: AlbumLayout.Filmroll.size.height)
                imageView.image = AlbumLayout.Filmroll.image
                return imageView
            }
    }
    
    func applyImageViewLayout(selectedLayout : AlbumLayout, imageView : UIImageView, image : UIImage) -> UIImageView {
        var size : CGSize = CGSize(width: 0, height: 0)
        
        switch selectedLayout {
        case .Polaroid:
            size = CGSize(width: AlbumLayout.Polaroid.size.width - 20, height: AlbumLayout.Polaroid.size.height - 50)
            imageView.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Mini:
            size =  CGSize(width: AlbumLayout.Mini.size.width - 24, height: AlbumLayout.Mini.size.height - 48)
            imageView.frame = CGRect(x: 12, y: 9, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Memory:
            size = CGSize(width: AlbumLayout.Memory.size.width - 48, height: AlbumLayout.Memory.size.height - 52)
            imageView.frame = CGRect(x: 24, y: 26, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Portrab:
            size = CGSize(width: AlbumLayout.Portrab.size.width - 20, height: AlbumLayout.Portrab.size.height - 24)
            imageView.frame = CGRect(x: 10, y: 12, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Tape:
            size = CGSize(width: AlbumLayout.Tape.size.width - 44, height: AlbumLayout.Tape.size.height - 80)
            imageView.frame = CGRect(x: 23, y: 43, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Portraw:
            size = CGSize(width: AlbumLayout.Portraw.size.width - 18, height: AlbumLayout.Portraw.size.height - 30)
            imageView.frame = CGRect(x: 9, y: 15, width: size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
        case .Filmroll:
            size = CGSize(width: AlbumLayout.Filmroll.size.width - 68, height: AlbumLayout.Filmroll.size.height - 3)
            imageView.frame = CGRect(x: 34, y: 3, width:size.width, height: size.height)
            imageView.image = image.imageResize(sizeChange: size)
            return imageView
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
