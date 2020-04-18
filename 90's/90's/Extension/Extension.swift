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
}


extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
      let size = self.size
      let widthRatio  = targetSize.width  / size.width
      let heightRatio = targetSize.height / size.height
      let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
      let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
      self.draw(in: rect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return newImage!
    }

    
    func mergeWith(topImage: UIImage , bottomImage : UIImage) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: -100 , width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        
        print("!!!!!!!!!!!!")
        print(topImage.size)
        print(bottomImage.size)
        print("!!!!!!!!!!!!")
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return mergedImage
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
