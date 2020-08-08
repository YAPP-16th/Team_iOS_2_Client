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

enum AddPhotoMode {
    case photoLibrary
    case camera
}

struct PhotoEditorTypes{
    
    static let titles: [String?] = ["Filter"]
    
    static let replacingOccurrencesWord : String = "CIPhotoEffect"
    static let filterNameLabelAnimationDelay: TimeInterval = TimeInterval(1)
    
    
    
    static let filterNameArray: [String] = ["lut_1","lut_grain", "lut_grunge", "lut_pinky", "lut_wrap", "lut_faded", "lut_scrape", "lut_lensflare",]
    static let filterImage : [String] = ["None" , "Grain", "Grunge","Pinky", "Wrap" , "Faded", "Scrape","Lensflare"]
    //        .sorted(by: >)
    static let filterFrame : [String] = ["b_None" ,"b_grain","b_grunge", "b_pinky", "b_wrap" , "b_faded", "b_scrape","b_lensflare"]
    //        .sorted(by: >)
    
    
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


class FilterViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filteredImage: UIImageView!
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var captureBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var outputimageViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var galleryConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    
    @IBOutlet weak var galleryLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    
    @IBOutlet weak var topCaptureBtnConstraint: NSLayoutConstraint!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    var photoOutput: AVCapturePhotoOutput?
    var orientation: AVCaptureVideoOrientation = .portrait
    var isCollectionViewAppear = true
    let galleryPicker = UIImagePickerController()
    let context = CIContext()
    var filterIndex: Int = 0 // 스와이프로 필터를 선택 시에 현재 필터 인덱스를 저장할 프로퍼티
    var filterName: String = "lut_1" // CIFilter를 적용할 때 필요한 필터 이름
    var photoMode: AddPhotoMode? // 카메라, 사진앨범 모드인지 구분하는 저장 프로퍼티
    var topImage = UIImage(named: "b_None")
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    static let maxInflightBuffers = 20
    var resizedPixelBuffers: [CVPixelBuffer?] = []

    var FilterArray: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupDevice()
        setupInputOutput()
        delegateSetting()
        setUpCoreImage()
        filterName = PhotoEditorTypes.filterNameArray[filterIndex]
        
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipeGestureRecognizer.direction = .left
        rightSwipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(leftSwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
        view.addGestureRecognizer(pinchRecognizer)
        
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            self.outputimageViewConstraint.constant = 115
            self.collectionViewHeight.constant = -80
            self.galleryConstraint.constant = 102
            self.filterConstraint.constant = 102
            
        }
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.outputimageViewConstraint.constant = 115
            self.collectionViewHeight.constant = -80
            self.galleryConstraint.constant = 102
            self.filterConstraint.constant = 102
        }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.filteredImage.image = UIImage(named: "b_None")
        let size = CGSize(width:   self.filteredImage.frame.width  , height: self.filteredImage.frame.height )
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        // .none, .slide, .fade
    }
    



    
    @IBAction func photoCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
        self.captureSession.stopRunning()
    }
    
    @IBAction func albumClick(_ sender: Any) {
        
        self.captureSession.stopRunning()
        galleryPicker.sourceType = .photoLibrary
        galleryPicker.delegate = self
        present(galleryPicker, animated: true)
    }
    
    // MARK:- Take a Picture Camera

    @IBAction func ontapTakePhoto(_ sender: Any) {
        
        if #available(iOS 9.0, *) {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        } else {
            AudioServicesPlaySystemSound(1108)
        }
        
        captureSession.stopRunning()
        
        print(self.filteredImage.frame.size)
        print(self.filteredImage.image?.size)
        
        
        let storyboard = UIStoryboard(name: "Sticker", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "imageCropVC") as! ImageCropVC
        nextVC.image = self.filteredImage.image
        
        self.navigationController?.pushViewController(nextVC, animated: true)

//        UIImageWriteToSavedPhotosAlbum(self.filteredImage.image! , nil, nil, nil)
        
        self.albumBtn.layer.masksToBounds = true
        self.albumBtn.layer.cornerRadius = self.albumBtn.bounds.width / 2
        
        self.albumBtn.setBackgroundImage(self.filteredImage.image , for: UIControl.State.normal)
        
//        captureSession.beginConfiguration()
//        captureSession.commitConfiguration()
//        captureSession.startRunning()
        
//        self.dismiss(animated: true, completion: nil)
        
    }
    
    func cropImageToSquare(_ image: UIImage) -> UIImage {
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        var imageWidth = image.size.width
        var imageHeight = image.size.height
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            // Swap width and height if orientation is landscape
            imageWidth = image.size.height
            imageHeight = image.size.width
        default:
            break
        }
        
        // The center coordinate along Y axis
        let rcy = imageHeight * 0.5
        let rect = CGRect(x: rcy - imageWidth * 0.5, y: 0, width: imageWidth, height: imageWidth)
        let imageRef = image.cgImage?.cropping(to: rect)
        return UIImage(cgImage: imageRef!, scale: 1.0, orientation: image.imageOrientation)
    }
    
    @IBAction func showFilter(_ sender: Any) {
        
        if isCollectionViewAppear {
            
            filterBtn.setImage(UIImage(named: "path18Grey"), for: .normal)
            takeButton.frame.size = CGSize(width: 15, height: 35)
            albumBtn.isHidden = true
            galleryLabel.isHidden = true
            filterLabel.isHidden = true
            
            
            if UIScreen.main.nativeBounds.height >= 1792.0 {
                self.collectionViewHeight.constant = -5
                self.captureBtnConstraint.constant = 15
                self.filterConstraint.constant = -20
            }
            else if UIScreen.main.nativeBounds.height <= 1334.0
            {
                self.collectionViewHeight.constant = -5
                self.captureBtnConstraint.constant = 40
                self.filterConstraint.constant = -10
            }
            
            
            
        }
            
        else {
            
            filterBtn.setImage(UIImage(named: "iconFilterBlack"), for: .normal)
            takeButton.frame.size = CGSize(width: 76, height: 77)
            albumBtn.isHidden = false
            galleryLabel.isHidden = false
            filterLabel.isHidden = false
            print(self.captureBtnConstraint.constant)
            
            if UIScreen.main.nativeBounds.height >= 1792.0 {
                self.outputimageViewConstraint.constant = 115
                self.collectionViewHeight.constant = -80
                self.captureBtnConstraint.constant = 79
                self.filterConstraint.constant = 102
                self.galleryConstraint.constant = 102
                
            }
            else if UIScreen.main.nativeBounds.height <= 1334.0
            {
                self.outputimageViewConstraint.constant = 115
                self.collectionViewHeight.constant = -80
                self.captureBtnConstraint.constant = 79
                self.filterConstraint.constant = 102
                self.galleryConstraint.constant = 102
                
            }
            
        }
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
        
        isCollectionViewAppear  = !isCollectionViewAppear
    }
    
    
    
    // MARK:- Change Camera Effect Filter From Swipe Gesture
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            NSLog("Swipe Left")
            filterIndex = (filterIndex + 1) % PhotoEditorTypes.numberOfFilterType()
            filterCollectionView.scrollToItem(at: [0,filterIndex], at: .left, animated: true)
        }
        
        if (sender.direction == .right) {
            NSLog("Swipe Right")
            print(PhotoEditorTypes.numberOfFilterType())
            filterCollectionView.scrollToItem(at: [0,filterIndex], at: .right, animated: true)
            filterIndex = (filterIndex - 1) % PhotoEditorTypes.numberOfFilterType()
            
            if filterIndex < 0 {
                filterIndex = filterIndex + PhotoEditorTypes.numberOfFilterType()
            }
        }
        
        if filterIndex == filterIndex {
            print(filterIndex, filterName)
            filterName = PhotoEditorTypes.filterNameArray[filterIndex]
            filterNameLabel.text = PhotoEditorTypes.filterImage[filterIndex]
            fadeViewInThenOut(view: filterNameLabel, delay: PhotoEditorTypes.filterNameLabelAnimationDelay)
            
            filterCollectionView.selectItem(at: [0,filterIndex], animated: true, scrollPosition: .centeredHorizontally)
            self.topImage = UIImage(named: PhotoEditorTypes.filterFrame[filterIndex])
            
            
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
        
        print(screenSize)
        if let touchPoint = touches.first {
            
            let x = touchPoint.location(in: self.filteredImage).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: self.filteredImage).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            print(focusPoint)
            if let device = captureDevice {
                do {
                    try device.lockForConfiguration()
                    print("Focus")
                    device.focusPointOfInterest = focusPoint
                    //device.focusMode = .continuousAutoFocus
                    device.focusMode = .autoFocus
                    //device.focusMode = .locked
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
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
        filteredImage.clipsToBounds = true
        
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
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
            captureSession.beginConfiguration()
            
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            captureSession.commitConfiguration()
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    func setUpCoreImage() {
        // Since we might be running several requests in parallel, we also need
        // to do the resizing in different pixel buffers or we might overwrite a
        // pixel buffer that's already in use.
        let inputWidth = self.filteredImage.frame.width
        let inputHeight = self.filteredImage.frame.height
        
        for _ in 0..<FilterViewController.maxInflightBuffers {
            var resizedPixelBuffer: CVPixelBuffer?
            let status = CVPixelBufferCreate(nil, Int(inputWidth), Int(inputHeight),
                                             kCVPixelFormatType_32BGRA, nil,
                                             &resizedPixelBuffer)
            
            if status != kCVReturnSuccess {
                print("Error: could not create resized pixel buffer", status)
            }
            resizedPixelBuffers.append(resizedPixelBuffer)
        }
    }
    
    func setupCorrectFramerate(currentCamera: AVCaptureDevice) {
        for vFormat in currentCamera.formats {
            //see available types
            //print("\(vFormat) \n")
            
            let ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
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
    
    //MARK: 카메라 아웃풋
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = orientation
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        let filterEffect = CIFilter(name: "CIMedianFilter")
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        filterEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
        let cgImage = self.context.createCGImage((filterEffect?.outputImage!)!, from: cameraImage.extent)!
        
        DispatchQueue.main.async {
            let filteredImage = UIImage(cgImage: cgImage)
//            self.filteredImage.image = filteredImage.mergeWith(topImage: self.topImage! , bottomImage: filteredImage).applyLUTFilter(LUT: UIImage(named: self.filterName), volume: 1.0)
            
        }
    }
    
    
    
    
}

extension FilterViewController : AVCapturePhotoCaptureDelegate {
    
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
        guard AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) != nil else {
            return
        }
        // Initialise an UIImage with our image data
        let capturedImage = self.filteredImage.image
//        print(capturedImage!)
        
    }
    
    
}


extension FilterViewController {
    
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

extension FilterViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func delegateSetting(){
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print(PhotoEditorTypes.filterNameArray.count)
        return PhotoEditorTypes.filterNameArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.selectImageView.isHidden = true
        cell.FilterImageView.image = UIImage(named: PhotoEditorTypes.filterImage[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterCell
        cell.selectImageView.isHidden = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        albumCover = PhotoEditorTypes.filterNameArray[indexPath.row]
        filterName = PhotoEditorTypes.filterNameArray[indexPath.row]
        self.topImage = UIImage(named: PhotoEditorTypes.filterFrame[indexPath.row])
        filterNameLabel.text = PhotoEditorTypes.filterImage[indexPath.row]
        fadeViewInThenOut(view: filterNameLabel, delay: PhotoEditorTypes.filterNameLabelAnimationDelay)
        let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterCell
        
        cell.selectImageView.isHidden = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 80)
    }
    
}

extension FilterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.captureSession.startRunning()
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var tempImage : UIImage? = nil
        
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(url, forKey: "assetURL")
            tempImage = image
            
        }
        
        dismiss(animated: true,completion: {
            let storyboard = UIStoryboard(name: "Sticker", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "imageCropVC") as! ImageCropVC
            vc.modalPresentationStyle = .fullScreen
            vc.image = tempImage
            self.present(vc, animated: true, completion: nil)
        })
    }
}

extension UIImageView {
    
    override open var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
    
}

