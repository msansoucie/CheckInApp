//
//  VCUser.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 11/20/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCUser: UIViewController {

    @IBOutlet weak var txtOne: UITextField!
    @IBOutlet weak var txtTwo: UITextField!
    @IBOutlet weak var btnButton: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    var user: UserDataObject? = nil
    var delegate: getUserDataProtocol?
    
    struct returnUser: Decodable {
        let vl:[u]
    }
    struct u: Decodable {
        var SecID: String
        var FullName: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtOne.placeholder = "User ID"
        txtTwo.placeholder = "Password"
    }
    
    @IBAction func ClickEnter(_ sender: Any) {
        
        //user = UserDataObject(secID: "1", FullName: "test")
        //delegate?.getUD(u: user!)
        //self.dismiss(animated: true, completion: nil)
        

        if txtOne.text != "" && txtTwo.text != "" {
            getSecID()
        }
        
        
    }
    
    
    
    func getSecID(){
        showSpinner(onView: self.view)
        let todoEndpoint: String = forURLs(s: "https://mobile.aane.com/auction.asmx/GetSecID?requestStr=\(txtOne.text!)&requesStr1=\(txtTwo.text!)")
        
        guard let url = URL(string: todoEndpoint) else {
           // self.removeSpinner()
            print("ERROR: cannot create URL")
            self.alertMessages(title: "Error", message: "Failed to create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("text/xml", forHTTPHeaderField: "Accept")
               
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest){ data, response, error in
            guard error == nil else{
                self.removeSpinner()
                print("ERROR: calling GET: \(error!)")
                self.alertMessages(title: "Error", message: "\(error!)")
                return
            }
            guard let data = data else {
                self.removeSpinner()
                print("DATA ERROR!!!")
                self.lblError.isHidden = false
                self.alertMessages(title: "Data Error", message: "Could not convert data to valid JSON")
                return
            }
            do {
                let newUser = try JSONDecoder().decode(returnUser.self, from: data)
                self.removeSpinner()
                DispatchQueue.main.async {
                    if newUser.vl.count != 1 {
                        self.alertMessages(title: "Error", message: "Did not pull the data correctly")
                        print("too big")
                        self.lblError.isHidden = false

                    }else{
                        if newUser.vl[0].SecID == "0" && newUser.vl[0].FullName == "N/A" {
                            self.alertMessages(title: "Invalid User", message: "Ensure username and password are correct")
                            //print("bad credentials")
                            self.lblError.isHidden = false

                        }else{
                            self.user = UserDataObject(secID: newUser.vl[0].SecID, FullName: newUser.vl[0].FullName)
                            self.delegate?.getUD(u: self.user!)
                            print("Good")
                            self.lblError.isHidden = true
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            }catch let jsonErr{
                self.removeSpinner()
                self.alertMessages(title: "JSON Error", message: "\(jsonErr)")
                self.lblError.isHidden = false
                print("Error: \(jsonErr)")
            }
        }
        task.resume()
    }
    
    
    
    func alertMessages(title: String, message: String)  {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { action in
        })))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
