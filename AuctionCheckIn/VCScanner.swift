//
//  VCScanner.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/7/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit
import AVFoundation

class VCScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    var dealer: DealerInfoObject? = nil
    
    var count: Int = 0
    
   // @IBOutlet weak var square: UIImageView!
    var capturedVIN: String = ""
    
    var cameFromManual = false
    var manualVIN: String? = ""
    
    var vehClassString: String = "Car / Truck"
    
    var txtEnterVIN: UITextField?
    // var vList = [DecodedVINObject]()
    // var vehClassList = [VehicleClass](VehicleClass.init(VehClassID: "1", VehClassDesc: "Car / Truck", VehicleClassID: "1", aascsortid: "0"))
    
    var vehClassList: [VehicleClass] = [VehicleClass.init(VehClassID: "1", VehClassDesc: "Car / Truck", VehicleClassID: "1", aascsortid: "0"),VehicleClass.init(VehClassID: "2", VehClassDesc: "Motorhome", VehicleClassID: "1", aascsortid: "2"), VehicleClass.init(VehClassID: "3", VehClassDesc: "Boat", VehicleClassID: "1", aascsortid: "3"), VehicleClass.init(VehClassID: "4", VehClassDesc: "Motorcycle", VehicleClassID: "1", aascsortid: "4"), VehicleClass.init(VehClassID: "5", VehClassDesc: "Other", VehicleClassID: "1", aascsortid: "5"), VehicleClass.init(VehClassID: "6", VehClassDesc: "Oversized", VehicleClassID: "1", aascsortid: "") ]
    
    @IBOutlet weak var btnManualVIN: UIButton!
    @IBOutlet weak var btnVehClass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the keyboard when the user clicks anywhere else
        self.hideKeyboardWhenTappedAround()
        
        btnVehClass.titleLabel?.adjustsFontSizeToFitWidth = true
       // btnVehClass.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        print("Dealer: \(String(describing: dealer?.DlrName))")
        self.navigationItem.title = "Dealer: \(String(describing: dealer!.DlrName))"
        self.navigationItem.backBarButtonItem?.title = "Change Dealer"

        KeepClassButtonSame()
        
        // Do any additional setup after loading the view.
        let session = AVCaptureSession()
        
        var defaultVideoDevice: AVCaptureDevice?
        
        // Choose the back dual camera if available, otherwise default to a wide angle camera.
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = dualCameraDevice
        }
        else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = backCameraDevice
        }
        else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            defaultVideoDevice = frontCameraDevice
        }
        do {
            let input = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            
            session.addInput(input)
            
        }
        catch {
            print("ERROR")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        //run on main thread
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //Bar codes assigned below code39 code128 etc
        //output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.code128
            , AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.qr
            , AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43
            , AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8]
        video = AVCaptureVideoPreviewLayer(session: session)
        
        //    let orient = UIDevice.current.orientation
        //   print("orient: \(orient)")

        video.frame = view.layer.bounds
        
        //     self.video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        view.layer.addSublayer(video)
       // self.view.bringSubviewToFront(square)
        
        //   self.view.bringSubviewToFront(butClose)
        session.startRunning()
    }
    
    
    @IBAction func ChangeClass(_ sender: Any) {
        for v in vehClassList{
            print("\(v.VehClassID),   \(v.VehClassDesc),    \(v.VehicleClassID),     \(v.aascsortid)")
        }
        
        let alert = UIAlertController(title: "Select Class", message: "Select the class that this vehicle belongs to.", preferredStyle: .alert)
        //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
        let cartuck = UIAlertAction(title: "\(vehClassList[0].VehClassDesc)", style: UIAlertAction.Style.default) { UIAlertAction in
            //self.btnVehClass.titleLabel?.text = self.vehClassList[0].VehClassDesc
            self.btnVehClass.setTitle(self.vehClassList[0].VehClassDesc, for: .normal)
            
            self.vehClassString = self.vehClassList[0].VehClassDesc
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cartuck)
        let motorhome = UIAlertAction(title: "\(vehClassList[1].VehClassDesc)", style: UIAlertAction.Style.default) { UIAlertAction in
            //self.btnVehClass.titleLabel?.text = self.vehClassList[1].VehClassDesc
            self.btnVehClass.setTitle(self.vehClassList[1].VehClassDesc, for: .normal)

            self.vehClassString = self.vehClassList[1].VehClassDesc
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(motorhome)
        let boat = UIAlertAction(title: "\(vehClassList[2].VehClassDesc)", style: UIAlertAction.Style.default) { UIAlertAction in
            //self.btnVehClass.titleLabel?.text = self.vehClassList[2].VehClassDesc
            self.btnVehClass.setTitle(self.vehClassList[2].VehClassDesc, for: .normal)

            self.vehClassString = self.vehClassList[2].VehClassDesc
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(boat)
        let motorcycle = UIAlertAction(title: "\(vehClassList[3].VehClassDesc)", style: UIAlertAction.Style.default) { UIAlertAction in
            //self.btnVehClass.titleLabel?.text = self.vehClassList[3].VehClassDesc
            self.btnVehClass.setTitle(self.vehClassList[3].VehClassDesc, for: .normal)
            
            self.vehClassString = self.vehClassList[3].VehClassDesc
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(motorcycle)
        let other = UIAlertAction(title: "\(vehClassList[4].VehClassDesc)", style: UIAlertAction.Style.default) { UIAlertAction in
            //self.btnVehClass.titleLabel?.text = self.vehClassList[4].VehClassDesc
            self.btnVehClass.setTitle(self.vehClassList[4].VehClassDesc, for: .normal)

            self.vehClassString = self.vehClassList[4].VehClassDesc
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(other)
        let oversized = UIAlertAction(title: "\(vehClassList[5].VehClassDesc)", style: UIAlertAction.Style.default) { UIAlertAction in
            //self.btnVehClass.titleLabel?.text = self.vehClassList[5].VehClassDesc
            self.btnVehClass.setTitle(self.vehClassList[5].VehClassDesc, for: .normal)

            self.vehClassString = self.vehClassList[5].VehClassDesc
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(oversized)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //will upload the data
    @IBAction func SaveVehicleToAuctionX(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func enterVinManually(_ sender: Any) {
        KeepClassButtonSame()

        txtEnterVIN?.autocapitalizationType = .allCharacters
        
        let alert = UIAlertController(title: "\(vehClassString) VIN", message: "Enter The VIN Manually", preferredStyle: .alert)
        
        alert.addTextField {
            text -> Void in
            self.txtEnterVIN = text
            self.txtEnterVIN?.placeholder = "Enter VIN"
            self.KeepClassButtonSame()
           // self.manualVIN = txtEnterVIN?.text
        }
        
        let enterAction = UIAlertAction(title: "Submit", style: .default) { (action)  in
            if let vin = self.txtEnterVIN?.text {
                if vin == "" {
                    print("Did not enter VIN")
                    
                } else if vin.count != 17 {//ALLOWED FOR SOME VEHICLES THAT MAY HAVE MORE OR LESS, TESTING!!!
                    print("VIN is missing or has too many characters")
                    self.KeepClassButtonSame()
                    self.cameFromManual = true
                    self.manualVIN = vin
                    
                    //self.verifyVIN(vin: vin)
                    self.performSegue(withIdentifier: "toVCVehicle", sender: nil)
                   // self.present(alert, animated: true, completion: nil)
                }
                else{
                    print("VIN was entered as <\(vin)>")
                    self.KeepClassButtonSame()
                    self.cameFromManual = true
                    self.manualVIN = vin
                    
                    //self.verifyVIN(vin: vin)
                    self.performSegue(withIdentifier: "toVCVehicle", sender: nil)
                }
            }else{
                print("Did not enter VIN")
                self.KeepClassButtonSame()
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action)  in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(enterAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVCVehicle"{
            let vc = segue.destination as! VCVehicle
            
            //vc.vin = capturedVIN
            if cameFromManual == true {
                
                var upercasedVIN: String = ""
                for c in manualVIN! {
                    upercasedVIN.append(c.uppercased())
                }
                
                vc.vin = checkVIN(testingVIN: upercasedVIN)
                cameFromManual = false
                
            } else{
                 vc.vin = checkVIN(testingVIN: capturedVIN)
            }
        
            vc.dealer = dealer
            
            for v in vehClassList{
                
                if vehClassString == v.VehClassDesc {
                    vc.thisVehicleClass = v
                }
            }
            
            //self.navigationController?.navigationBar.topItem?.title = "Rescan"
            let backItem = UIBarButtonItem()
            backItem.title = "Rescan"
            navigationItem.backBarButtonItem = backItem
        
        }
    }
    
    func checkVIN(testingVIN: String) -> String{
        print(testingVIN)
        if testingVIN.uppercased().contains("I") || testingVIN.uppercased().contains("O") || testingVIN.uppercased().contains("Q") || testingVIN.uppercased().contains("-") || testingVIN.uppercased().contains("+") || testingVIN.uppercased().contains("<") || testingVIN.uppercased().contains(">") || testingVIN.uppercased().contains("!") || testingVIN.uppercased().contains(".") {
            
            print("VIN has bad letters!!!\n\(testingVIN)")
            //let newvin = vin.stringByTrimmingCharactersInSet(badLetters)
            var newV = testingVIN.replacingOccurrences(of: "I", with: "")
            newV = newV.replacingOccurrences(of: "O", with: "")
            newV = newV.replacingOccurrences(of: "Q", with: "")
            newV = newV.replacingOccurrences(of: "-", with: "")
            newV = newV.replacingOccurrences(of: "+", with: "")
            newV = newV.replacingOccurrences(of: "<", with: "")
            newV = newV.replacingOccurrences(of: ">", with: "")
            newV = newV.replacingOccurrences(of: "!", with: "")
            newV = newV.replacingOccurrences(of: ".", with: "")

            let newVIN = newV
            return newVIN
            
        }else{
            print("VIN IS GOOD!!")
            return testingVIN
        }
    }
    
    //attempt to keep the button from changing back to car / truck
    func KeepClassButtonSame(){
        if vehClassString == "" {
           // btnVehClass.titleLabel?.text = "Car / Truck"
            btnVehClass.setTitle("Car / Truck", for: .normal)
        }else {
            btnVehClass.setTitle(vehClassString, for: .normal)
            //btnVehClass.titleLabel?.text = vehClassString
        }
        setCameraOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Dealer: \(String(describing: dealer!.DlrName))"
        count = 0
        
       KeepClassButtonSame()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        KeepClassButtonSame()
        
    }
    
    @objc func setCameraOrientation() {
        
        if let connection =  self.video.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                let o: AVCaptureVideoOrientation
                //changes made to allow for only landscape use
                switch (orientation) {
                    case .portrait: o = .landscapeRight       //portrait
                    case .landscapeRight: o = .landscapeLeft // landscapeLeft
                    case .landscapeLeft: o = .landscapeRight  //landscapeRight
                    case .portraitUpsideDown: o = .landscapeRight //portraitUpsideDown
                    default: o = .landscapeRight  //portrait
                }
                
                previewLayerConnection.videoOrientation = o
                
                video.frame = self.view.bounds
            }
        }
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
         KeepClassButtonSame()
         setCameraOrientation()
    }
    
    
    func goToVeh(){
        //preverts the scanner form creating multiple child VC's due to the camera capturing multiple shots of the barcode while scanning
        if count == 0 {
            //verifyVIN(vin: capturedVIN)
            performSegue(withIdentifier: "toVCVehicle", sender: nil)
            count = count + 1
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            //if metadataObjects[0] is AVMetadataMachineReadableCodeObject {
            //   let object =  metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            //  let alert = UIAlertController(title: "QR Code", message: object!.stringValue, preferredStyle: .alert)
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.code128 {
                    //let alert = UIAlertController(title: "code128 Code", message: object.stringValue, preferredStyle: .alert)
                    //alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    //   alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in UIPasteboard.general.string = object.stringValue
                   capturedVIN = object.stringValue!
                   goToVeh()
                    /*----------------------!!!!!HANDLE TRANSITION HERE!!!!!----------------------
                    alert.addAction(UIAlertAction(title: "Copy Close", style: .destructive, handler: {
                        _ in  if self.delegate != nil {
                            self.delegate?.sendData(data:object.stringValue!)
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }}))*/
                    
                    //present(alert, animated: true, completion: nil)
                }
                else if object.type == AVMetadataObject.ObjectType.qr {
                   capturedVIN = object.stringValue!
                   goToVeh()
                }
                else if object.type == AVMetadataObject.ObjectType.code39 {
                    capturedVIN = object.stringValue!
                    goToVeh()
                }
                else if object.type == AVMetadataObject.ObjectType.code93 {
                    capturedVIN = object.stringValue!
                    goToVeh()
                }
                else if object.type == AVMetadataObject.ObjectType.code39Mod43 {
                    capturedVIN = object.stringValue!
                    goToVeh()
                }
                else if object.type == AVMetadataObject.ObjectType.ean13 {
                    capturedVIN = object.stringValue!
                    goToVeh()
                }
                else if object.type == AVMetadataObject.ObjectType.ean8 {
                    capturedVIN = object.stringValue!
                    goToVeh()
                }
            }
        }
    }
    
    func pressed(_ object: Any){
        UIPasteboard.general.string = (object as AnyObject).stringValue
        print(object)
        
    }

    class func showAlertMessage(message:String, viewController: UIViewController) {
        DispatchQueue.main.async {
            /*
             let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
             
             let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
             
             alertMessage.addAction(cancelAction)
             
             viewController.present(alertMessage, animated: true, completion: nil)
             */
            //     let alert = UIAlertController(title: "Upload Status", message: message, preferredStyle: .alert)
            //     alert.addAction(UIAlertAction(title: "Okay", style: .default){(action)->() in })
            
            let alert = UIAlertController(title: "code39 VIN Scan", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
            /*
             alert.addAction(UIAlertAction(title: "Accept", style: .destructive, handler:{
             _ in  if self.delegate != nil {
             self.delegate?.sendData(data:object.stringValue!)
             self.navigationController?.popViewController(animated: true)
             self.dismiss(animated: true, completion: nil)
             }
             }))
             
             */
            
            viewController.present(alert, animated: true, completion: {() -> Void in
                alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                
            })
            
            
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         KeepClassButtonSame()
        
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
        
        return false
    }

}

