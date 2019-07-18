//
//  VCPrintBarcode.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/27/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit
import CoreBluetooth
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
        instanceOfCustomeObject.image = self.view.toImage()
        instanceOfCustomeObject.mileage = miles
        instanceOfCustomeObject.year = year
        
        //^PQ2^XZ will print 2 copies
        instanceOfCustomeObject.label = "^XA ^FWR ^FO250,20^GB550,1180,4^FS    ^FO500,400^A0,200,200^FD\(year)^FS ^FO300,250^A0,200,200^FD\(Int(miles)?.delimiter ?? miles) MI^FS ^FO100,300 ^BY3 ^BCR,100,Y,N,N ^FD\(vin)^FS ^PQ2 ^XZ"

 
        instanceOfCustomeObject.sampleWithGCD()
        
    }
    

    
    
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



