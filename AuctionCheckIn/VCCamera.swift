//
//  VCCamera.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/11/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit
import AVFoundation

class VCCamera: UIViewController, URLSessionDelegate, URLSessionDataDelegate {

    var vin: String = ""
    var dealer: DealerInfoObject? = nil
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?

    var portriatCamera: AVCaptureDevice?
    var landscapeCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
 
    @IBOutlet weak var btnCamera: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCamera.layer.cornerRadius = 0.5 * btnCamera.bounds.size.width
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCapturSession()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCameraOrientation()
    }
    
    
    //takes photo
    @IBAction func takePhoto(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto"{
            let vc = segue.destination as! VCPhotoPreview
            vc.myImage = image
            
            //TRYING TO SAVE MEMORY SPACE
           image = nil
        }
    }
    
    func rotateImage(image:UIImage) -> UIImage {
        var rotatedImage = UIImage()
        switch image.imageOrientation
        {
        case .right:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up )//.down)
            
        case .down:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up )//.left)
            
        case .left:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
            
        default:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        }
        return rotatedImage
    }
}

//---------------------------------------AVFoundation------------------------------------------------
extension VCCamera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            //print("--------------------------------IMAGEDATA------------------------------------")
            //print(imageData)
            image = UIImage(data: imageData)
            
            //makes sure the image is rotated right
            if (image!.imageOrientation.rawValue == cameraPreviewLayer!.connection!.videoOrientation.rawValue)
            {
                image = rotateImage(image: image!)
            }
            
            
            performSegue(withIdentifier: "toPhoto", sender: nil)
            
           // items.append(image!)
            //myCollectionView.reloadData()
            //performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
        }
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch{
            print(error)
        }
    }
    
    //adds the capture session of the camera to the view
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //   cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        
        cameraPreviewLayer?.frame = self.view.frame
        
        //cameraPreviewLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.7)
        //CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 0.7)
        
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCapturSession(){
        captureSession.startRunning()
    }
    
    @objc func setCameraOrientation() {
        if let connection =  self.cameraPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                let o: AVCaptureVideoOrientation
                switch (orientation) {
                    case .portrait: o = .landscapeRight       //portrait             MODIFIED SO ITS ONLY IN LANDSCAPE
                    case .landscapeRight: o = .landscapeLeft // landscapeLeft
                    case .landscapeLeft: o = .landscapeRight  //landscapeRight
                    case .portraitUpsideDown: o = .landscapeRight //portraitUpsideDown
                    default: o = .landscapeRight  //portrait
                }
                
                previewLayerConnection.videoOrientation = o
                cameraPreviewLayer!.frame = self.view.bounds
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        setCameraOrientation()
    }
    
}


extension Data{
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
