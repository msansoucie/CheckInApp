//
//  VCNewPhoto.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 10/15/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCNewPhoto: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnRetake: UIButton!
    
    var theImage: UIImage?
    var crORolPhoto: String?
    var vin: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnUpload.layer.cornerRadius = 0.5 * btnUpload.bounds.size.width
        btnRetake.layer.cornerRadius = 0.5 * btnRetake.bounds.size.width

        if theImage == nil {
            let alert = UIAlertController(title: "Error", message: "The image has a nil value", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController!.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            myImage.image = theImage
        }
        
        if crORolPhoto == "CR" {
            self.navigationItem.title = "Condition Photo"
        }else if crORolPhoto == "OL" {
            self.navigationItem.title = "Online Photo"
        }else {
            let alert = UIAlertController(title: "Error", message: "An unknown value is being used for photoType", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController!.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    @IBAction func uploadImage(_ sender: Any) {
        switch crORolPhoto {
            case "CR":
                crUpload()
            case "OL":
                olUpload()
            default:
                let alert = UIAlertController(title: "Error", message: "An unknown value is being used for photoType", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController!.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func olUpload(){
    let alert = UIAlertController(title: "Upload OL", message: "Are you sure you want to upload this Online Photo?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
        self.navigationController!.popViewController(animated: true)
    }))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        //sends it to OL photos (LIVEDB!!!!!!!!!!!!!!!)
        self.Upload(myURL: "https://mobile.aane.com/Auction.asmx/SendPicture")
    }))
    self.present(alert, animated: true, completion: nil)
    }
    func crUpload(){
        let alert = UIAlertController(title: "Upload CR", message: "Are you sure you want to upload this Condition Photo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            self.navigationController!.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //sends it to CR photos (testDB)
            self.Upload(myURL: "https://mobile.aane.com/Auction.asmx/CheckInSendPicture")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func Upload(myURL: String){
        let v = vin! + String(false)
        let localImageName = "NotStoredLocally\(String(describing: vin))"
        let DorOPhoto = myImage.image
        
        let paramName = v
        let fileName = localImageName
        let image = DorOPhoto
        
        let url = URL(string: myURL)
        print(url!)
        
        let boundary = UUID().uuidString
               
        let session = URLSession.shared
               
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
               
        print("paramname: \(paramName)")
               
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        print("urlRequest: \(urlRequest)")
               
        var data = Data()
               
        //Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
               
        let imgResized =  image!.resizeWithPercent(percentage: 0.3)
               
        let img = imgResized?.jpegData(compressionQuality: 0.4)

        let base64String = img?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
               
        data.append(base64String!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        self.showSpinner(onView: self.view)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            DispatchQueue.main.async {
                    
            if error != nil {
                self.removeSpinner()
                       
                let alert = UIAlertController(title: "ERROR", message: "\(String(describing: error))", preferredStyle: .alert)
                print("\(error!)")
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                  
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                //print("JSON DATA: \(jsonData)")
                       
                if let json = jsonData as? [String: Any] {
                    print("THE JSON IS: \(json)")
                    self.removeSpinner()
                    if let r = json["result"] as? String{
                        print("this is from the service: \(r) -Matt!")
                        if r == "Success" {
                            let id = json["imageid"] as? Int
                                   
                            let alert = UIAlertController(title: r, message: "Photo successfully uploaded\nImageID: \(id ?? 0000000000)", preferredStyle: .alert)
                                
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }else {
                            self.removeSpinner()
                            let alert = UIAlertController(title: "ERROR", message: "Could not upload photo, make sure vehicle is registered on property", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else {
                        let alert = UIAlertController(title: "ERROR", message: "\(json)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.removeSpinner()
                }else{
                    let alert = UIAlertController(title: "ERROR", message: "That wasn't supposed to happen, ensure the webservice has not been altered", preferredStyle: .alert)
                           
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                    self.removeSpinner()
                }
            }
        }).resume()
    }
    
    
    @IBAction func retakePhoto(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}
