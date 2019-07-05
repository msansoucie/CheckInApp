//
//  VCPrintBarcode.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/27/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit
//import ExternalAccessory

class VCPrintBarcode: UIViewController {
    
    var year: String = ""
    var miles: String = ""
    var vin: String = ""
    
    var barcodeVIN: String = ""
    var barcodeImage: UIImage? = nil
    
    @IBOutlet weak var lblYearMiles: UILabel!
    @IBOutlet weak var lblTextVIN: UILabel!
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTextVIN.text = vin
        
        let printButton = UIBarButtonItem(title: "Print", style: .done, target: self, action: #selector(testC))
        self.navigationItem.rightBarButtonItem = printButton
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        lblYearMiles.layer.borderWidth = 2.0
        
        lblYearMiles.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblYearMiles.numberOfLines = 2

        lblYearMiles.text = "\(year)\n\(Int(miles)!.delimiter) MI"
        barcodeImage = generateBarcode(from: barcodeVIN)!
        barcodeImageView.image = barcodeImage
        
    }

    @objc func testC(){
        let instanceOfCustomeObject: CustomObject = CustomObject()
        instanceOfCustomeObject.someMethod()
        //instanceOfCustomeObject.sendZplOverBluetooth()
        instanceOfCustomeObject.image = self.view.toImage()
        instanceOfCustomeObject.mileage = miles
        instanceOfCustomeObject.year = year
        
        //^PQ2^XZ will print 2 copies
        
       
        
        instanceOfCustomeObject.label = "^XA ^FWR ^FO250,20^GB550,1180,4^FS    ^FO500,400^A0,200,200^FD\(year)^FS ^FO300,100^A0,200,200^FD\(Int(miles)?.delimiter ?? miles) MI^FS ^FO100,300 ^BY3 ^BCR,100,Y,N,N ^FD2CKDL43F086045757^FS ^PQ2 ^XZ"
        //"^XA ^FWR ^FO300,20^GB500,1180,4^FS ^FO500,400^A0,300,250^FD\(year)^FS ^FO300,100^A0,300,250^FD\(Int(miles)?.delimiter ?? miles) MI^FS ^FO100, 50 ^BY5 ^BCR,100,Y,N,N ^FD2CKDL43F086045757^FS ^XZ"
    
 
        instanceOfCustomeObject.sampleWithGCD()
        
    }
    

   /* func saveImage(){
        print("Trying to save an image")
        let image: UIImage? = self.view.toImage()
        if !(image == nil) {
            // get the documents directory url
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] // Get documents folder
            let dataPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("ImagesFolder").absoluteString //Set folder name
            print(dataPath)
            //Check is folder available or not, if not create
            if !FileManager.default.fileExists(atPath: dataPath) {
                try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
            }
            
            // create the destination file url to save your image
            let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent("imageName.jpg")//Your image name
            print("File URL: \(fileURL)")
            //print(fileURL)
            // get your UIImage jpeg data representation
            let data = image?.jpegData(compressionQuality: 1.0)//Set image quality here
            do {
                print("Please Work")

                // writes the image data to disk
                try data?.write(to: fileURL, options: .atomic)
            } catch {
                print("error:", error)
            }
        }

    }*/
    
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }

   @objc func sendToPrinter() {
        let printerController = UIPrintInteractionController.shared
        
        let printInfo = UIPrintInfo(dictionary: nil)
        
        printInfo.jobName = "Testing Printer Settings"
        printInfo.outputType = .general
        
        printerController.printInfo = printInfo
        printerController.printingItem = self.view.toImage()
        
        printerController.present(animated: true) { (_, isPrinted, error) in
            
            if error == nil {
                if isPrinted {
                    print("It Printed!!!")
                }else{
                    print("It Did Not Print")
                }
            }else{
                print("PRINTER ERROR: \(String(describing: error))")
            }
        }
    }

}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



