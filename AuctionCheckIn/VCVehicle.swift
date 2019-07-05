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
    
    struct ReservedLotsLanes: Decodable{
        var vl:[laneLot]
    }
    struct laneLot: Decodable{
        var LaneLotID: String
        var LaneID: String
        var DlrID: String
        var LaneLot: String
        var AucID: String
        var saleDate: String
        var LotID: String
    }
    
    var bodyTypes = ["<NA>"]
    var laneLots = ["Select Lane"]
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
    @IBOutlet weak var lblLaneErrror: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(vin)")
        verifyVIN(vin: vin)

        GetReservations(dealerID: dealer!.DlrID)
        
        //hide the keyboard when the user clicks anywhere else
        self.hideKeyboardWhenTappedAround()
    
        //hide the tables of the body and
        tvBody.isHidden = true
        tvLaneLot.isHidden = true
        
        self.btnNEWSelectBody.titleLabel!.numberOfLines = 0  // <-- Or to desired number of lines
        self.btnNEWSelectBody.titleLabel!.adjustsFontSizeToFitWidth = true
        
        txtvComments.layer.borderWidth = 1
    }
    
    //will setup the reservations
    func GetReservations(dealerID: String){
        
        print("DealerID: \(dealerID)")    
        
        var test = [LaneLotObject]()
        test.append(LaneLotObject(LaneLotID: "5854802", LaneID: "1", DlrID: "514253", LaneLot: "2019-06-06_1_1_1", AucID: "0", saleDate: "2019-06-06 00:00:00", LotID: "1"))
        test.append(LaneLotObject(LaneLotID: "5854803", LaneID: "1", DlrID: "514253", LaneLot: "2019-06-06_1_1_2", AucID: "0", saleDate: "2019-06-06 00:00:00", LotID: "2"))
        test.append(LaneLotObject(LaneLotID: "5854801", LaneID: "1", DlrID: "514253", LaneLot: "2019-06-06_1_1_36", AucID: "0", saleDate: "2019-06-06 00:00:00", LotID: "36"))
        
        for l in test {
        laneLots.append("\(l.LaneID)-\(l.LotID)")
        }
        tvLaneLot.reloadData()

       /* showSpinner(onView: self.view)
        
        let todoEndpoint: String = "https://mobiletest.aane.com/auction.asmx/VINDecode?"//requestSTR=\(vin)"
        print(todoEndpoint)
        
        //empty the list
        laneLots.removeAll()
        
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
                let l = try JSONDecoder().decode(ReservedLotsLanes.self, from: data)
                
                DispatchQueue.main.async {
                    l.vl
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
                
            }
            
        }
        task.resume()*/

        

    }
    
    @IBAction func UploadVehicle(_ sender: Any) {
        
        _ = self.dealer
        _ = self.vin
        _ = self.txtYear.text
        _ = self.txtMake.text
        _ = self.txtModel.text
        _ = btnNEWSelectBody.titleLabel?.text
        _ = btnSelectLotLane.titleLabel?.text
        _ = txtvComments.text
        
        
        
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
    
   /* func disablePageIfBad(){
    
        if isValid == false{
            txtColor.isEnabled = false
            txtYear.isEnabled = false
            txtMake.isEnabled = false
            txtModel.isEnabled = false
            txtMileage.isEnabled = false
        }
    }*/
    

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
                            let alert = UIAlertController(title: "Manually Entry Required", message: "Valid VIN for this vehicle labeled \n \"\(self.thisVehicleClass!.VehClassDesc)\" \nfields must be entered manually", preferredStyle: .alert)
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
                            
                            for v in self.vList{
                                self.bodyTypes.append(v.Series)
                            }
                            
                            
                            
                            if self.bodyTypes.count == 2 {
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
            setBody()
        }
        counter = counter + 1
        /* if selectedBody != ""{
            btnSelectBody.titleLabel?.text = selectedBody
            print(selectedBody)
        }*/
        
        /*
        if selectedLane != "" {
            btnSelectLotLane.titleLabel?.text = selectedLane
        }*/
        
        
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
            tvLaneLot.isHidden = false
        }else{
            tvLaneLot.isHidden = true
        }
    }
    
    @IBAction func TakePhotos(_ sender: Any) {
        //setBody()

        performSegue(withIdentifier: "toCamera", sender: nil)
    }
    
    @IBAction func PrintSticker(_ sender: Any) {
    
        if txtYear.text == ""{
            lblYearError.isHidden = false
        }else{
            lblYearError.isHidden = true
        }
        if txtMileage.text == "" {
            lblMileageError.isHidden = false
        }else{
            lblMileageError.isHidden = true
        }
        if txtMake.text == "" {
            lblMakeError.isHidden = false
        }else{
            lblMakeError.isHidden = true
        }
        if txtModel.text == "" {
            lblModelError.isHidden = false
        }else{
            lblModelError.isHidden = true
        }
        if txtColor.text == "" {
            lblColorError.isHidden = false
        }else{
            lblColorError.isHidden = true
        }
        
        // HTF is this affecting the button text?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!
        /*if btnNEWSelectBody.titleLabel?.text == "Select Body" {   //"Select Body" {
            lblBodyError.isHidden = false
        }else{
            lblBodyError.isHidden = true
        }*/
        
        if txtYear.text != "" && txtMileage.text != "" && txtMake.text != "" && txtModel.text != "" && txtColor.text != "" {//&& btnNEWSelectBody.titleLabel?.text != "Select Body"{
            
            lblYearError.isHidden = true
            lblMileageError.isHidden = true
            lblMakeError.isHidden = true
            lblModelError.isHidden = true
            lblColorError.isHidden = true
            lblBodyError.isHidden = true
            performSegue(withIdentifier: "getCode", sender: nil)
        }
        
        setBody()
    }
    

    
    func setBody(){
       // if btnNEWSelectBody.titleLabel?.text != selectedBody{
           // btnNEWSelectBody.titleLabel?.text = selectedBody
      //  }
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
        }else if segue.identifier == "getCode"{
            self.navigationItem.title = "Back"
            let vc = segue.destination as! VCPrintBarcode
            vc.barcodeVIN = self.vin
            vc.vin = self.vin
            vc.year = "\(self.txtYear.text!)"
            vc.miles = "\(self.txtMileage.text!)"
            
        }
    }
    
    
    
}

/*extension VCVehicle: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}*/

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
            btnNEWSelectBody.titleLabel?.text = bodyTypes[indexPath.row]
            //selectedBody = bodyTypes[indexPath.row]
            tvBody.isHidden = true
        } else if tableView == self.tvLaneLot{
            btnSelectLotLane.titleLabel?.text = laneLots[indexPath.row] 
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
