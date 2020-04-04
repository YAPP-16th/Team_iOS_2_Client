//
//  testViewController.swift
//  cameraTest
//
//  Created by 조경진 on 2020/03/14.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit
import AVFoundation
//import LUTFilter

struct Filter {
    let filterName : String
    var filterEffectValue : Any?
    var filterEffectValueName: String?
    
    
    
    init(filterName: String, filterEffectValue : Any?, filterEffectValueName : String?){
        self.filterName = filterName
        self.filterEffectValue = filterEffectValue
        self.filterEffectValueName = filterEffectValueName
    }
}


class testViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filteredImage: UIImageView!
    @IBOutlet weak var takeButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    var photoOutput: AVCapturePhotoOutput?
    var orientation: AVCaptureVideoOrientation = .portrait
    
    let context = CIContext()
    var filterIndex: Int = 0 // 스와이프로 필터를 선택 시에 현재 필터 인덱스를 저장할 프로퍼티
    var filterName: String = "CILinearToSRGBToneCurve" // CIFilter를 적용할 때 필요한 필터 이름
    //    var filterName: String?
    var photoMode: AddPhotoMode? // 카메라, 사진앨범 모드인지 구분하는 저장 프로퍼티
    var topImage = UIImage(named: "frame_landscape")
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    
    override func viewDidLoad() {
        
        takeButton.layer.cornerRadius = takeButton.frame.size.width / 2
        takeButton.clipsToBounds = true
        
        super.viewDidLoad()
        
        setupDevice()
        setupInputOutput()
        
        //        filterName = PhotoEditorTypes.filterNameArray[filterIndex]
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipeGestureRecognizer.direction = .left
        rightSwipeGestureRecognizer.direction = .right
        
        view.addGestureRecognizer(leftSwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        
        orientation = AVCaptureVideoOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                { (authorized) in
                    DispatchQueue.main.async
                        {
                            if authorized
                            {
                                self.setupInputOutput()
                            }
                    }
            })
        }
    }
    
    @IBAction func ontapTakePhoto(_ sender: Any) {
        
        if #available(iOS 9.0, *) {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        } else {
            AudioServicesPlaySystemSound(1108)
        }
        
        print("!!!!!!!!!!!!")
        print(self.filteredImage.image)
        print("!!!!!!!!!!!!")
        
        UIImageWriteToSavedPhotosAlbum(self.filteredImage.image! , nil, nil, nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckPhotoViewController") as! CheckPhotoViewController
        vc.tempImage = self.filteredImage.image
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        //            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK:- Change Camera Effect Filter From Swipe Gesture
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            NSLog("Swipe Left")
            filterIndex = (filterIndex + 1) % PhotoEditorTypes.numberOfFilterType()
            
        }
        
        if (sender.direction == .right) {
            NSLog("Swipe Right")
            print(PhotoEditorTypes.numberOfFilterType())
            filterIndex = (filterIndex - 1) % PhotoEditorTypes.numberOfFilterType()
            
            if filterIndex < 0 {
                filterIndex = filterIndex + PhotoEditorTypes.numberOfFilterType()
            }
        }
        
        if filterIndex == filterIndex {
            print(filterIndex, filterName)
            filterName = PhotoEditorTypes.filterNameArray[filterIndex]
            filterNameLabel.text = filterName.replacingOccurrences(of: PhotoEditorTypes.replacingOccurrencesWord, with: "")
            fadeViewInThenOut(view: filterNameLabel, delay: PhotoEditorTypes.filterNameLabelAnimationDelay)
        }
    }
    
    
    
    
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard let device = captureDevice else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let screenSize = self.view.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: self.view).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: self.view).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            print(focusPoint)
            if let device = captureDevice {
                do {
                    try device.lockForConfiguration()
                    
                    device.focusPointOfInterest = focusPoint
                    //                    device.focusMode = .continuousAutoFocus
                    device.focusMode = .autoFocus
                    //device.focusMode = .locked
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                }
                catch {
                    // just ignore
                }
            }
        }
    }
    
    func setupDevice() {
        filteredImage.contentMode = .scaleAspectFill
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            setupCorrectFramerate(currentCamera: currentCamera!)
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            let videoOutput = AVCaptureVideoDataOutput()
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    func setupCorrectFramerate(currentCamera: AVCaptureDevice) {
        for vFormat in currentCamera.formats {
            //see available types
            //print("\(vFormat) \n")
            
            var ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
            let frameRates = ranges[0]
            
            do {
                //set to 240fps - available types are: 30, 60, 120 and 240 and custom
                // lower framerates cause major stuttering
                if frameRates.maxFrameRate == 240 {
                    try currentCamera.lockForConfiguration()
                    currentCamera.activeFormat = vFormat as AVCaptureDevice.Format
                    //for custom framerate set min max activeVideoFrameDuration to whatever you like, e.g. 1 and 180
                    currentCamera.activeVideoMinFrameDuration = frameRates.minFrameDuration
                    currentCamera.activeVideoMaxFrameDuration = frameRates.maxFrameDuration
                }
            }
            catch {
                print("Could not set active format")
                print(error)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = orientation
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        let comicEffect = CIFilter(name: "CIColorCube")
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        
        comicEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
        
        let cgImage = self.context.createCGImage((comicEffect?.outputImage!)!, from: cameraImage.extent)!
        //        let cgImage = self.context.createCGImage(filter.outputImage!, from: cameraImage.extent)!
        
        DispatchQueue.main.async {
            let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            let filteredImage = UIImage(cgImage: cgImage)
            
            UIGraphicsBeginImageContext(size)
            
            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            filteredImage.draw(in: areaSize)
            
            self.topImage!.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
            
            var newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
           // self.filteredImage.image = newImage.applyLUTFilter(LUT: UIImage(named: self.filterName), volume: 1.0)
            
            //            self.filteredImage.image = newImage.applyLUTFilter(LUT: UIImage(named: self.filterName), volume: 1.0)
            //            self.filteredImage.image = filteredImage

            
        }
    }
}

extension testViewController : AVCapturePhotoCaptureDelegate {
    
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        
        // Initialise an UIImage with our image data
        var capturedImage = self.filteredImage.image
        
        
        print(capturedImage)
        
        //        사진을 저장하는건 사실 여기서 되는건데 임의로 작업을 수정함
        
        //        if let testImage = capturedImage {
        //            let inputImage = CIImage(image: testImage)
        //            let filteredImage = inputImage?.applyingFilter("CILinearToSRGBToneCurve")
        //            let filteredExtent = (filteredImage?.extent)!
        //            let renderedImage = context.createCGImage(filteredImage!, from: filteredExtent)
        //            //               testImage =  UIImage(cgImage: renderedImage!)
        //            // Save our captured image to photos album
        //            UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: renderedImage! ) , nil, nil, nil)
        //        }
        //        UIImageWriteToSavedPhotosAlbum(capturedImage! , nil, nil, nil)
        
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



extension testViewController {
    
    // LUT Filter apply
    func colorCubeFilterFromLUT(imageName : String)-> CIFilter? {
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
        
        // create CIColorCube Filter
        let filter = CIFilter(name: "CIColorCube")
        filter?.setValue(colorCubeData, forKey: "inputCubeData")
        filter?.setValue(size, forKey: "inputCubeDimension")
        
        return filter
    }
    //
    //    func colorCubeFilterFromLUT(imageName : String)-> CIFilter? {
    //        let size = 64
    //
    //        let lutImage    = UIImage(named: "LUT")!.cgImage
    //        let lutWidth    = lutImage!.width
    //        let lutHeight   = lutImage!.height
    //        let rowCount    = lutHeight / size
    //        let columnCount = lutWidth / size
    //
    //        if ((lutWidth % size != 0) || (lutHeight % size != 0) || (rowCount * columnCount != size)) {
    //            NSLog("Invalid colorLUT %@", "LUT");
    //            return nil
    //        }
    //
    //        let bitmap  = getBytesFromImage(image: UIImage(named: "LUT"))!
    //        let floatSize = MemoryLayout<Float>.size
    //
    //        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: size * size * size * 4 * floatSize)
    //        var z = 0
    //        var bitmapOffset = 0
    //
    //        for _ in 0 ..< rowCount {
    //            for y in 0 ..< size {
    //                let tmp = z
    //                for _ in 0 ..< columnCount {
    //                    for x in 0 ..< size {
    //                        let alpha   = Float(bitmap[bitmapOffset]) / 255.0
    //                        let red     = Float(bitmap[bitmapOffset+1]) / 255.0
    //                        let green   = Float(bitmap[bitmapOffset+2]) / 255.0
    //                        let blue    = Float(bitmap[bitmapOffset+3]) / 255.0
    //                        let dataOffset = (z * size * size + y * size + x) * 4
    //
    //                        cubeData[dataOffset + 3] = alpha
    //                        cubeData[dataOffset + 2] = red
    //                        cubeData[dataOffset + 1] = green
    //                        cubeData[dataOffset + 0] = blue
    //                        bitmapOffset += 4
    //                    }
    //                    z += 1
    //                }
    //                z = tmp
    //            }
    //            z += columnCount
    //        }
    //
    //        let colorCubeData = NSData(bytesNoCopy: cubeData, length: size * size * size * 4 * floatSize, freeWhenDone: true)
    //
    //        // create CIColorCube Filter
    //        let filter = CIFilter(name: "CIColorCube")
    //        filter?.setValue(colorCubeData, forKey: "inputCubeData")
    //        filter?.setValue(size, forKey: "inputCubeDimension")
    //
    //        return filter
    //    }
    
    
    
    func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        let ciImage = CIImage(image: UIView().createImage())
        let filter = CIFilter(name: filterEffect.filterName)
        filter?.setDefaults()
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        let filteredImage = UIImage(cgImage: outputCGImage!)
        
        return filteredImage
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


struct PhotoEditorTypes{
    
    static let titles: [String?] = ["Filter"]
    
    static let replacingOccurrencesWord : String = "CIPhotoEffect"
    static let filterNameLabelAnimationDelay: TimeInterval = TimeInterval(1)
    
    //    static let filterNameArray: [String] = ["CIPhotoEffectTransfer", "CIPhotoEffectInstant", "Normal", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectTonal", "CIPhotoEffectFade", "CIPhotoEffectChrome", "CIPhotoEffectTransfer"].sorted(by: >)
    
    static let filterNameArray: [String] = ["arapaho", "arapaho", "LUT", "LUT2", "LUT3", "LUT4", "LUT5", "arapaho"].sorted(by: >)
    
    static func numberOfFilterType() -> Int {
        return filterNameArray.count
    }
    static func titleForIndexPath(_ indexPath: IndexPath) -> String {
        return filterNameArray[indexPath.row]
    }
    
    static func normalStatusFromFilterNameArray() -> String {
        return filterNameArray.first!
    }
    
    
}
func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
    
    // 포토 라이브러리에서 이미지를 가져온 경우 return
    //      if photoMode == .photoLibrary {
    //          return
    //      }
    let animationDuration = 0.25
    
    // Fade in the view
    UIView.animate(withDuration: animationDuration, animations: { () -> Void in
        view.alpha = 1
    }) { (Bool) -> Void in
        
        // After the animation completes, fade out the view after a delay
        
        UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
            view.alpha = 0
            
        },
                       completion: nil)
    }
}

enum AddPhotoMode {
    case photoLibrary
    case camera
}
