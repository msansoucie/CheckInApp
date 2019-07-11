//
//  VCVehicle.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/7/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCVehicle: UIViewController {
    
    var counter = 0
    
    //variables for the vin, dealer and vehicles class
    var vin: String = ""
    var dealer: DealerInfoObject? = nil
    var thisVehicleClass: VehicleClass? = nil
    var vList = [DecodedVINObject]()
    var laneLotList = [LaneLotObject]()
    
   // var selectedBody: String = ""
    var selectedLane: String = ""
    
    //jason for the list of possible vehicle types
    struct vinVehicles: Decodable {
        var vl:[v]
    }
    struct v: Decodable {
        var ID: String
        var VID: String
        var Make: String
        var Model: String
        var Series: String
        var Yr: String
        var UVC: String
    }
    
    struct ReservedLotsLanes: Decodable {
        var vl:[laneLot]
    }
    struct laneLot: Decodable {
        var LanelotID: String
        var LaneID: String
        var DLrID: String
        var LaneLot: String
        var AucID: String
        var SaleDate: String
        var LotID: String
        
        var vin: String
        var make: String
        var model: String
        var yr: String
        var lotmemo: String
    }
    
    var bodyTypes = ["Enter Body Manually"]
    var laneLots = [String]()
    var colors = ["Black", "White", "Silver", "Blue", "Gray", "Green", "Brown", "Red"]
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    

    
    // Constraints
   // @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    //@IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtMileage: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    
    @IBOutlet weak var txtvComments: UITextView!
    //@IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tvBody: UITableView!
    @IBOutlet weak var tvLaneLot: UITableView!
    
    @IBOutlet weak var btnNEWSelectBody: UIButton!
    @IBOutlet weak var btnSelectLotLane: UIButton!
    
    //Errors
    @IBOutlet weak var lblYearError: UILabel!
    @IBOutlet weak var lblMakeError: UILabel!
    @IBOutlet weak var lblModelError: UILabel!
    @IBOutlet weak var lblColorError: UILabel!
    @IBOutlet weak var lblMileageError: UILabel!
    @IBOutlet weak var lblBodyError: UILabel!
    @IBOutlet weak var lblLaneError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(vin)")
        
        verifyVIN(vin: vin)
        
        //hide the keyboard when the user clicks anywhere else
        self.hideKeyboardWhenTappedAround()
    
        //hide the tables of the body and
        tvBody.isHidden = true
        tvLaneLot.isHidden = true
        
        self.btnNEWSelectBody.titleLabel!.numberOfLines = 0  // <-- Or to desired number of lines
        self.btnNEWSelectBody.titleLabel!.adjustsFontSizeToFitWidth = true
        
        txtvComments.layer.borderWidth = 1
        
        let printButton = UIBarButtonItem(title: "Print", style: .done, target: self, action: #selector(printTabButton))
        self.navigationItem.rightBarButtonItem = printButton
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    
    func checkFieldEntry(btnClicked: String) -> Bool{
        
        var allFieldsChecked = true
        
        if txtYear.text == ""{
            lblYearError.isHidden = false
            allFieldsChecked = false
        }else{
            lblYearError.isHidden = true
        }
        if txtMileage.text == "" {
            lblMileageError.isHidden = false
            allFieldsChecked = false
        }else{
            lblMileageError.isHidden = true
        }
        if txtMake.text == "" {
            lblMakeError.isHidden = false
            allFieldsChecked = false
        }else{
            lblMakeError.isHidden = true
        }
        if txtModel.text == "" {
            lblModelError.isHidden = false
            allFieldsChecked = false
        }else{
            lblModelError.isHidden = true
        }
        if txtColor.text == "" {
            lblColorError.isHidden = false
            allFieldsChecked = false
        }else{
            lblColorError.isHidden = true
        }
        
        if btnClicked == "save"{
            if btnNEWSelectBody.title(for: .normal) == "Select Body"{
                lblBodyError.isHidden = false
                allFieldsChecked = false
            }else{
                lblBodyError.isHidden = true
            }
            if btnSelectLotLane.title(for: .normal) == "Select Lane" {
                lblLaneError.isHidden = false
                allFieldsChecked = false
            }else{
                lblLaneError.isHidden = true
            }
        }
        
        return allFieldsChecked
        
    
    }
    
    @objc func printTabButton(){
 
        let _ = checkFieldEntry(btnClicked: "print")
        
        if txtYear.text != "" && txtMileage.text != "" && txtMake.text != "" && txtModel.text != "" && txtColor.text != "" {//&& btnNEWSelectBody.title(for: .normal) != "Select Body" && btnSelectLotLane.title(for: .normal) != "Select Lane"{
            lblYearError.isHidden = true
            lblMileageError.isHidden = true
            lblMakeError.isHidden = true
            lblModelError.isHidden = true
            lblColorError.isHidden = true
            lblBodyError.isHidden = true
            lblLaneError.isHidden = true
            printLabel()
        }

    }
    
    
    //will setup the reservations
    func GetReservations(dealerID: String){
        
        showSpinner(onView: self.view)
        
        print("DealerID: \(dealerID)")
     
        laneLots.removeAll()
    
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/GetLaneLots?requestSTR=\(dealerID)"//requestSTR=\(vin)"
       // print(todoEndpoint)
        
        guard let url = URL(string: todoEndpoint) else {
            print("ERROR: cannot create URL")
            self.removeSpinner()
            return
        }
        
        var urlRequest = URLRequest(url: url)
        print(urlRequest)
        
        urlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("text/xml", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest){ data, response, error in
            guard error == nil else {
                print("ERROR: calling GET: \(error!)")
                self.removeSpinner()
                return
            }
            
            guard let data = data else { print("DATA ERROR!!!"); return }
            do{
               
                var availableCount = 0
                var unAvailableCount = 0
                
                let lotlanes = try JSONDecoder().decode(ReservedLotsLanes.self, from: data)
                
                DispatchQueue.main.async {
                
                    for i in lotlanes.vl {
                       // print("LaneLotID:\(i.LanelotID), DlrID:\(i.DLrID), LaneLot:\(i.LaneLot), AucID:\(i.AucID), SaleDate:\(i.SaleDate), LotID\(i.LotID), vin:\(i.vin), make:\(i.make), model:\(i.model), yr\(i.yr), lotmemo:\(i.lotmemo)")
                        if i.vin == "" && i.make == "" && i.model == ""{
                            
                            self.laneLots.append("\(i.LaneID)-\(i.LotID)")
                            availableCount = availableCount + 1
                            
                        }else {
                            unAvailableCount = unAvailableCount + 1
                        }
                    }
                    
                    print("There are \(availableCount + unAvailableCount) spots reserved, with \(availableCount) available and \(unAvailableCount) occupied")
                    self.tvLaneLot.reloadData()
                    
                }
            
                
            }catch let jsonErr{
                print("-------------\(jsonErr) --------------")
                self.removeSpinner()
                
                let alert = UIAlertController(title: "JSON Error:", message: "\(jsonErr)", preferredStyle: .alert)
                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.removeSpinner()

            }
            self.removeSpinner()
            
        }
        task.resume()
      
    }
    
    @IBAction func UploadVehicle(_ sender: Any) {
        
        if !checkFieldEntry(btnClicked: "save") {
            print("NOT ALL FIELDS ARE IN!!!")
        }else{
            let sDealer = self.dealer!
            let sVIN = self.vin
            let sYear = self.txtYear.text?.trimmingCharacters(in: .whitespaces)
            let sMake = self.txtMake.text?.trimmingCharacters(in: .whitespaces)
            let sModel = self.txtModel.text?.trimmingCharacters(in: .whitespaces)
            let sBody = btnNEWSelectBody?.titleLabel?.text!//.trimmingCharacters(in: .whitespaces)
            let sLotLane = btnSelectLotLane.titleLabel?.text!
            let sComments = txtvComments.text?.trimmingCharacters(in: .whitespaces)
        
            print("(\(sDealer.DlrID))")
            print("(\(sDealer.DlrName))")
            print("(\(sVIN))")
            print("(\(sYear!))")
            print("(\(sMake!))")
            print("(\(sModel))")
            print("(\(sBody!))")
            print("(\(sLotLane!))")
            print("(\(String(describing: sComments)))")

        
            
        //var chosenVData: DecodedVINObject? = nil
        //for v in vList{
          //  if v.Series == btnSelectBody.titleLabel?.text{
       //         chosenVData = v
        //    }
      //  }
       // let uploadData = CheckInObject(Dealer: self.dealer!, laneLot: "ENTER Lanelot Here", vin: self.vin, vData: chosenVData!, vType: self.thisVehicleClass!)
        
       // print("Uploaded Data\n Dealer: \(uploadData.Dealer.DlrName), laneLot: \(uploadData.laneLot), vin: \(uploadData.vin), vData \(uploadData.vData.), vType: \(uploadData.vType)")
            //CheckInObject(Dealer: self.dealer!, laneLot: "ENTER Lanelot Here", vin: self.vin, vdata: , vType: self.thisVehicleClass)
        
            navigationController?.popToRootViewController(animated: true)
        }
    }
    

    //MARK DECODE THE VIN
    func verifyVIN(vin: String){
        showSpinner(onView: self.view)
        
        let todoEndpoint: String = "https://mobiletest.aane.com/auction.asmx/VINDecode?requestSTR=\(vin)"
        
        print(todoEndpoint)
        //empty the list
        vList.removeAll()
        
        guard let url = URL(string: todoEndpoint) else {
            print("ERROR: cannot create URL")
            self.removeSpinner()
            return
        }
        
        var urlRequest = URLRequest(url: url)
        //print(urlRequest)
        
        urlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("text/xml", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest){ data, response, error in
            
            guard error == nil else{
                print("ERROR: calling GET: \(error!)")
                self.removeSpinner()
                return
            }
            
            guard let data = data else { print("DATA ERROR!!!"); return }
            
            do{
                print(data)
                let vehicles = try JSONDecoder().decode(vinVehicles.self, from: data)
                
                DispatchQueue.main.async {
                    // print(t)
                    if vehicles.vl.isEmpty{
    
                        if self.thisVehicleClass?.VehClassDesc == "Car / Truck"{
                           // self.isValid = false
                            let alert = UIAlertController(title: "No Vehicle Found", message: "Unable to link a car/truck with this valid vin: \(self.vin)", preferredStyle: .alert)
                            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            //self.isValid = true
                            let alert = UIAlertController(title: "Manually Entry Required", message: "Valid VIN for \n\(self.thisVehicleClass!.VehClassDesc) \nfields must be entered manually", preferredStyle: .alert)
                            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                       // self.isValid = true
                        for v in vehicles.vl{
                          
                           // print("--------- Coming From Call ---------")
                            print("ID: \(v.ID), VID: \(v.VID), Make: \(v.Make), Model: \(v.Model), Series: \(v.Series), Yr: \(v.Yr), UVC: \(v.UVC)")
                            //print("--------- Coming From Call ---------")
                            
                            let vel = DecodedVINObject(ID: v.ID, VID: v.VID, Make: v.Make, Model: v.Model, Series: v.Series, Yr: v.Yr, UVC: v.UVC)
                            self.vList.append(vel)
                        }
                        
                        self.removeSpinner()
                        
                        if self.vList[0].Model.contains("Unit Already checked in")  {
                          //  self.isValid = true
                            print("\(self.vList[0].Model)")
                            let alert = UIAlertController(title: "Already Checked In", message: "This unit has already been checked in", preferredStyle: .alert)
                            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }else if self.vList[0].Model.contains("Invalid VIN") || self.vList[0].Model.contains("VIN must be 17 characters"){
                           // self.isValid = false
                            print("\(self.vList[0].Model)")
                            let alert = UIAlertController(title: "Invaild VIN", message: "\(self.vList[0].Model)", preferredStyle: .alert)
                            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else{
                          //  self.isValid = true
                            self.txtYear.text = self.vList[0].Yr
                            self.txtMake.text = self.vList[0].Make
                            self.txtModel.text = self.vList[0].Model
                            
                            //adds the different body types to the body table
                            for v in self.vList{
                                self.bodyTypes.append(v.Series)
                            }
                            //adds these values to the end of the list
                            //self.bodyTypes.append("Enter Body Manually")
                            self.bodyTypes.append("Unknown")

                            if self.bodyTypes.count == 3 {
                                //self.btnNEWSelectBody.titleLabel?.text = self.bodyTypes[1]
                                self.btnNEWSelectBody.setTitle(self.bodyTypes[1], for: .normal)
                            }
                            
                            self.tvBody.reloadData()
                        }
                    }
                }
                
            } catch let jsonErr{
                print("-------------\(jsonErr) --------------")
                self.removeSpinner()
                //self.isValid = false
                let alert = UIAlertController(title: "JSON Error:", message: "\(jsonErr)", preferredStyle: .alert)
                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.removeSpinner()
        }
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let s = thisVehicleClass!.VehClassDesc
        self.navigationItem.title = "\(s): \(vin)"
        
        if counter != 0 {
            //setBody()
        }
        counter = counter + 1
    }
    
    @IBAction func SelectBody(_ sender: Any) {
        if tvBody.isHidden{
           tvBody.isHidden = false
        }else{
            tvBody.isHidden = true
        }
    }
    
    @IBAction func SelectLane(_ sender: Any) {
        
        
        if tvLaneLot.isHidden{
            if laneLots.isEmpty{
                GetReservations(dealerID: dealer!.DlrID)
            }
            tvLaneLot.isHidden = false
        }else{
            tvLaneLot.isHidden = true
        }
    }
    
    @IBAction func TakePhotos(_ sender: Any) {
        performSegue(withIdentifier: "toCamera", sender: nil)
    }
    
    
    
    func printLabel(){
        //create an instande of the Objective-C Class
        let instanceOfCustomeObject: CustomObject = CustomObject()
        //test method
        instanceOfCustomeObject.someMethod()
        //create the values for the year and miles
        let y = txtYear.text
        let m = txtMileage.text
        //create the lable in ZPL
        instanceOfCustomeObject.label = "^XA ^FWR ^FO250,20 ^GB550,1180,4^FS    ^FO500,400 ^A0,200,200^FD\(y!)^FS     ^FO300,250 ^A0,200,200^FD\(Int(m!)?.delimiter ?? m!) MI^FS ^FO100,300 ^BY3 ^BCR,100,N,N,N ^FD\(vin)^FS    ^FO35,400 ^A0R,0,50 ^FD\(vin)^FS ^PQ2 ^XZ"
        
        //"^XA ^FWR ^FO250,20^GB550,1180,4^FS ^FO500,400^A0,200,200^FD\(y!)^FS ^FO300,250^A0,200,200^FD\(Int(m!)?.delimiter ?? m!) MI^FS ^FO100,300 ^BY3 ^BCR,100,Y,N,N ^FD\(vin)^FS ^PQ2 ^XZ"
        
        //prints the label through the method call with seapreate threading
        instanceOfCustomeObject.sampleWithGCD()
    }
 
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        let uppercased = textField
        if uppercased == txtColor ||  uppercased == txtMake || uppercased == txtModel {
            if string == "" {
                // User presses backspace
                textField.deleteBackward()
            } else {
                // User presses a key or pastes
                textField.insertText(string.uppercased())
            }
            // Do not let specified text range to be changed
            return false
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCamera"{
            self.navigationItem.title = "Back"
            let vc = segue.destination as! VCCamera
            vc.vin = self.vin
            vc.dealer = self.dealer
        //Depreaciated!!!!!
        }else if segue.identifier == "getCode"{
            self.navigationItem.title = "Back"
            let vc = segue.destination as! VCPrintBarcode
            vc.barcodeVIN = self.vin
            vc.vin = self.vin
            vc.year = "\(self.txtYear.text!)"
            vc.miles = "\(self.txtMileage.text!)"
        }
    }
    
    
    
    func manualBodyEntry() {
        var txtEnterBody: UITextField?
        
        txtEnterBody?.autocapitalizationType = .allCharacters
        
        let alert = UIAlertController(title: "Input Body", message: "Enter the body manually", preferredStyle: .alert)
        
        alert.addTextField {
            text -> Void in
            txtEnterBody = text
            txtEnterBody?.placeholder = "Enter Body Here"
        }
        
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (action)  in
            if txtEnterBody?.text != "" {
                self.btnNEWSelectBody.setTitle(txtEnterBody?.text, for: .normal)
            }
            self.tvBody.isHidden = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action)  in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(enterAction)
        present(alert, animated: true, completion: nil)
    }
    
}



extension VCVehicle: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tvBody{
            return bodyTypes.count
        }else if tableView == self.tvLaneLot {
            return laneLots.count
        }else{
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tvBody{
            let cell = tvBody.dequeueReusableCell(withIdentifier: "bodyCell") as! TVCBody
            cell.lblBodyType.text = bodyTypes[indexPath.row]
           // selectedBody = bodyTypes[indexPath.row]
            return cell
        }else if tableView == self.tvLaneLot{
            let cell = tvLaneLot.dequeueReusableCell(withIdentifier: "lotlaneCell") as! TVCLaneLot
            cell.lblLaneLot.text = laneLots[indexPath.row]
            selectedLane = laneLots[indexPath.row]
            return cell
        }else{
            let cell = tvLaneLot.dequeueReusableCell(withIdentifier: "lotlaneCell") as! TVCLaneLot
            cell.lblLaneLot.text = "UNKNOWN ERROR!!!"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tvBody{
            
            if bodyTypes[indexPath.row] == "Enter Body Manually"{
                manualBodyEntry()
            }else{
                btnNEWSelectBody.setTitle(bodyTypes[indexPath.row], for: .normal)
                tvBody.isHidden = true
            }
        } else if tableView == self.tvLaneLot{
            btnSelectLotLane.setTitle(laneLots[indexPath.row], for: .normal)
            tvLaneLot.isHidden = true
        }
    }
    
}

extension VCVehicle: UITextFieldDelegate, UITextViewDelegate{
    //allow only ints to be used in yr and mileage
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtYear || textField == txtMileage {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        
        if textField == txtColor {
            let allowedCharacters = "qwertyuioplkjhgfdsazxcvbnm QWERTYUIOPLKJHGFDSAZXCVBNM"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        
        return true
    }
}


extension UIViewController {
    //dismiss the keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
