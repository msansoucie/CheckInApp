//
//  VCPrintBarcode.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/27/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

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
        
        let printButton = UIBarButtonItem(title: "Print", style: .done, target: self, action: #selector(sendToPrinter))
        self.navigationItem.rightBarButtonItem = printButton
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        
        lblYearMiles.layer.borderWidth = 2.0
        
        lblYearMiles.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblYearMiles.numberOfLines = 2
        
        /*print(year)
        print(miles)
        print(Int(miles)!.delimiter)*/
        
        lblYearMiles.text = "\(year)\n\(Int(miles)!.delimiter) MI"
        barcodeImage = generateBarcode(from: barcodeVIN)!
        barcodeImageView.image = barcodeImage
        
        sendToPrinterWithObjectC()
        
    }
    
    
    func sendToPrinterWithObjectC(){
        let serial: String = ""
        let connection: MfiBtPrinterConnection = MfiBtPrinterConnection(serialNumber: serial)
        
        connection.open()
        
        
        if(connection.isConnected()) {
            do {
                //try SGD.SET("bluetooth.page_scan_window", withValue: "60", andWithPrinterConnection: connection)
                
                let  printer   =  try ZebraPrinterFactory.getInstance(connection)
                
                let lang =  printer.getControlLanguage()
                
                if(lang != PRINTER_LANGUAGE_CPCL){
                    
                    let tool = printer.getToolsUtil()
                    
                    
                   try tool?.sendCommand("Test Print")
                    //try  tool.sendCommand(dosya)
                    
                }
                
            } catch {
                print(error)
            }
            
            connection.close()
            
        }else{
            print("IS NOT CONNECTED!")
        }
        

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
