//
//  VCVehicle.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/7/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

protocol UpdateImageProtocol {
    func getDefault(image: UIImage)
    
    func getMileage(image: UIImage)
    
    func getLeftRear(image: UIImage)
    
    func getRightRear(image: UIImage)
    
    func getRightFront(image: UIImage)
}

class VCVehicle: UIViewController, UpdateImageProtocol, getEquipmentTypeAndName {
    
    //prechecking aucid, and ACT
    var aucid: String = "0"
    
    
    var counter = 0
    var Odomcount = 0
    var LRcount = 0
    var RRcount = 0
    var RFcount = 0
    
    //variables for the vin, dealer and vehicles class
    var vin: String = ""
    var dealer: DealerInfoObject? = nil
    var thisVehicleClass: VehicleClass? = nil
    var vList = [DecodedVINObject]()
    var laneLotList = [LaneLotObject]()
    
    // var selectedBody: String = ""
    var selectedLane: String = ""
    
    var laneLotIDs = [String]()
    var lanelotID: String = "0"
    
    var ISONPROPERITY: Bool = false
    
    var addingInvReservation: Bool = false
    
    var crORolPhoto: String = "CR"
    
    @IBOutlet weak var scReconSelection: UISegmentedControl!
    
    @IBOutlet weak var btnTrans: UIButton!
    @IBOutlet weak var btnRadio: UIButton!
    
    var transCode: String = "0"
    var radioCode: String = "0"
    
    //var isBanks: Bool = false
    
    
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
        
        var AucStat: String
        var Mileage: String
        var VehColor: String
        var Body: String
        var LaneLotID: String
        var LaneID: String
        var LotID: String
        var StockNumber: String
        //var LOCATION: String
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
    
    
    struct EquipmentList:Decodable {
        let vl: [vcl]
    }
    struct vcl: Decodable{
        var EQGroup: String
        var EQCode: String
        var EQDesc: String
    }
    
    struct myResponse:Decodable{
        var Status: String
    }
    
    var bodyTypes = ["Enter Body Manually"]
    var laneLots = [String]()
    var avability = [String]()
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    var defaultOrMileage: String = ""
    
    var user: UserDataObject? = nil
    
    
    
    //MARK: Managing Equipment
    @IBOutlet weak var lblTrans: UILabel!
    @IBOutlet weak var lblRadio: UILabel!
    var equ: String = ""
    var screwedUpCode=[myScrewedUpCode]()
    //Entire Equipment List
    var equipmentList=[EquipmentCodes]()
    //Equipment List of Dropdown user selects
    var selectedList=[EquipmentCodes]()
    
    func getList(group: String) {
        selectedList.removeAll()
        for e in equipmentList {
            if e.EQGroup == group {
                selectedList.append(e)
            }
        }
    }
    @IBAction func transType(_ sender: Any) {
        equ = lblTrans.text!
        getList(group: "TRANSMISSION")
        performSegue(withIdentifier: "toSelectEquipment", sender: nil)
    }
    @IBAction func radioType(_ sender: Any) {
        equ = lblRadio.text!
        getList(group: "RADIO")
        performSegue(withIdentifier: "toSelectEquipment", sender: nil)
    }
    func getData(name: String, buttonName: String, code: String) {
         switch buttonName {
         case "Trans":
             btnTrans.setTitle(name, for: .normal)
             transCode = code
         case "Radio":
             btnRadio.setTitle(name, for: .normal)
             radioCode = code
         default:
             AlertMessage(title: "Error", message: "Invalid button value \(buttonName)", pop: false)
         }
     }
    
    
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
    
    //Default & Mileage ImageViews, AND OTHER CORNERS OF THE CAR
    @IBOutlet weak var UIIVDefault: UIImageView!
    @IBOutlet weak var UIIVMileage: UIImageView!
    
    @IBOutlet weak var UIIVLeftRear: UIImageView!
    @IBOutlet weak var UIIVRightRear: UIImageView!
    @IBOutlet weak var UIIVRightFront: UIImageView!
    
    //Errors
    @IBOutlet weak var lblYearError: UILabel!
    @IBOutlet weak var lblMakeError: UILabel!
    @IBOutlet weak var lblModelError: UILabel!
    @IBOutlet weak var lblColorError: UILabel!
    @IBOutlet weak var lblMileageError: UILabel!
    @IBOutlet weak var lblBodyError: UILabel!
    @IBOutlet weak var lblLaneError: UILabel!
    
    @IBOutlet weak var lblDefaultError: UILabel!
    @IBOutlet weak var lblOdometerError: UILabel!
    @IBOutlet weak var lblLeftRearError: UILabel!
    @IBOutlet weak var lblRightRearError: UILabel!
    @IBOutlet weak var lblRightFrontError: UILabel!
    
    @IBOutlet weak var txtStockNumber: UITextField!
    
    @IBOutlet weak var lblOldLaneLot: UILabel!
    
    @IBOutlet weak var btnOLPhoto: UIButton!
    @IBOutlet weak var btnCRPhoto: UIButton!
    @IBOutlet weak var btnChangeDealer: UIButton!
    
    @IBOutlet weak var vintextbox: UITextField!
    
    var defaultImage = UIImage(named: "default")
    var mileageImage = UIImage(named: "mileage")
    
    var leftRearImage = UIImage(named: "leftRear")
    var rightRearImage = UIImage(named: "rightRear")
    var rightFrontImage = UIImage(named: "frontRight")
    
    func getDefault(image: UIImage) {
        UIIVDefault.image = image
        defaultImage = image
    }
    func getMileage(image: UIImage) {
        UIIVMileage.image = image
        mileageImage = image
    }
    func getRightRear(image: UIImage) {
        UIIVRightRear.image = image
        rightRearImage = image
    }
    func getRightFront(image: UIImage) {
        UIIVRightFront.image = image
        rightFrontImage = image
    }
    func getLeftRear(image: UIImage) {
        UIIVLeftRear.image = image
        leftRearImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIIVDefault.layer.borderWidth = 1.5
        UIIVDefault.layer.borderColor = UIColor.black.cgColor
        UIIVMileage.layer.borderWidth = 1.5
        UIIVMileage.layer.borderColor = UIColor.black.cgColor
        
        UIIVLeftRear.layer.borderWidth = 1.5
        UIIVLeftRear.layer.borderColor = UIColor.black.cgColor
        UIIVRightRear.layer.borderWidth = 1.5
        UIIVRightRear.layer.borderColor = UIColor.black.cgColor
        UIIVRightFront.layer.borderWidth = 1.5
        UIIVRightFront.layer.borderColor = UIColor.black.cgColor
        
        print("\(vin)")
        vintextbox.text = vin
        
        print(dealer!.DlrName)
        print(dealer!.dlrReconFlag)
        
        
        if vin.count == 17 || vin.count == 6{
            verifyVIN(vin: vin)
        }else{
            let alert = UIAlertController(title: "Error", message: "Not the required amount of characters", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
             }))
             self.present(alert, animated: true, completion: nil)
        }
        
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedDefault))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedMileage))
        UIIVDefault.addGestureRecognizer(tap)
        UIIVMileage.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedLeftRear))
        UIIVLeftRear.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.tappedRightRear))
        UIIVRightRear.addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.tappedRightFront))
        UIIVRightFront.addGestureRecognizer(tap4)

        getEquipment() //will add new section
        AdjustReconType()
        
    }
    
    
    //Equipment Section
    func getEquipment(){
        //showSpinner(onView: self.view)
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/CheckInGetTransRadioEquipment?requestStr=\(0)"
        
        guard let url = URL(string: todoEndpoint) else {
            print("ERROR: cannot create URL")
            self.removeSpinner()
            return
        }
        
        print(url)
        var urlRequest = URLRequest(url: url)
        
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
            do {
                print(data)
                let t = try JSONDecoder().decode(EquipmentList.self, from: data)
                DispatchQueue.main.async {
                    //print(t.vl)
                    for i in t.vl{
                        self.screwedUpCode.append(myScrewedUpCode(EQGroup: i.EQGroup, EQDesc: i.EQDesc, EQCode: i.EQCode))
                    }
                    
                    for f in self.screwedUpCode{
                        print("\(f.EQCode), \(f.EQGroup), \(f.EQDesc)")
                    }
                    
                    self.fixMyError()
                    self.removeSpinner()
                }
                
            }catch {
                print("\(error)")
                self.removeSpinner()
            }
           // self.removeSpinner()
            
            
        }
        task.resume()
       // self.removeSpinner()
        
    }
    
    func fixMyError(){//fixes an error with the variable names of the equipment code on the server side
        for e in screwedUpCode{
            let f = EquipmentCodes(EQGroup: e.EQGroup, EQDesc: e.EQDesc, id: e.EQCode)
            equipmentList.append(f)
        }
        btnRadio.isEnabled = true
        btnTrans.isEnabled = true
    }
    
    
    
    func AdjustReconType(){
        switch dealer!.dlrReconFlag {
        case "285":
            scReconSelection.selectedSegmentIndex = 0
            print("na")
        case "286":
            scReconSelection.selectedSegmentIndex = 1
            print("tbs")
        case "287":
            scReconSelection.selectedSegmentIndex = 2
            print("full")
        case "288":
            scReconSelection.selectedSegmentIndex = 3
             print("mini")
        case "289":
            scReconSelection.selectedSegmentIndex = 4
             print("wash")
        default:
            scReconSelection.selectedSegmentIndex = 0
            let alert = UIAlertController(title: "Unknown Recon Flag", message: "Dealer has a recon flag of <\(dealer!.dlrReconFlag)>, cannot predetermine Recon type and must be set manually", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            
            present(alert, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func SelectReconType(_ sender: Any) {
        
        //scReconSelection.
    }
    
    
    
    func AlertMessage(title: String, message: String, pop: Bool){
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addInventoryRes(_ sender: Any) {
        tvLaneLot.isHidden = true
        laneLots.removeAll()
        
        performSegue(withIdentifier: "pullINVs", sender: nil)
    }
    
    
    @objc func tappedDefault() {
        defaultOrMileage = "Default"
        //print(UIIVDefault.image)
        // if UIIVDefault.image == nil {
        performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
        /* }else{
         let alert = UIAlertController(title: "Default Photo", message: "", preferredStyle: .alert)
         //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
         let view = UIAlertAction(title: "View", style: UIAlertAction.Style.default) {
         UIAlertAction in
         self.performSegue(withIdentifier: "viewImage", sender: nil)
         self.dismiss(animated: true, completion: nil)
         }
         let retake = UIAlertAction(title: "Retake", style: UIAlertAction.Style.default) {
         UIAlertAction in
         self.performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
         self.dismiss(animated: true, completion: nil)
         }
         alert.addAction(view)
         alert.addAction(retake)
         self.present(alert, animated: true, completion: nil)
         }*/
    }
    
    @objc func tappedMileage() {
        defaultOrMileage = "Mileage" //Millage
        // if UIIVMileage.image == nil {
        performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
        /* }else{
         let alert = UIAlertController(title: "Odometer Photo", message: "", preferredStyle: .alert)
         //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
         let view = UIAlertAction(title: "View", style: UIAlertAction.Style.default) {
         UIAlertAction in
         self.performSegue(withIdentifier: "viewImage", sender: nil)
         self.dismiss(animated: true, completion: nil)
         }
         let retake = UIAlertAction(title: "Retake", style: UIAlertAction.Style.default) {
         UIAlertAction in
         self.performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
         self.dismiss(animated: true, completion: nil)
         }
         let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
         UIAlertAction in
         self.dismiss(animated: true, completion: nil)
         }
         alert.addAction(view)
         alert.addAction(retake)
         alert.addAction(cancel)
         self.present(alert, animated: true, completion: nil)
         }*/
    }
    
    @objc func tappedLeftRear(){
        defaultOrMileage = "LeftRear"
        performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
    }
    @objc func tappedRightRear(){
        defaultOrMileage = "RightRear"
        performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
    }
    @objc func tappedRightFront(){
        defaultOrMileage = "RightFront"
        performSegue(withIdentifier: "TakeDefaultOrMileagePic", sender: nil)
    }
    
    
    func checkFieldEntry(btnClicked: String) -> Bool{
        
        var allFieldsChecked = true
        
        if txtYear.text == "" {
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
        
        
        if btnClicked == "save" {
            if btnNEWSelectBody.title(for: .normal) == "Select Body" {
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
            
            
            if ISONPROPERITY == false {
                
                //MARK: NOT REQUIRED TO UPLOAD A DEFAULT OR ODOM PIC
                /*if UIIVDefault.image == nil {
                 lblDefaultError.isHidden = false
                 allFieldsChecked = false
                 }else{
                 lblDefaultError.isHidden = true
                 }
                 if UIIVMileage.image == nil {
                 lblOdometerError.isHidden = false
                 allFieldsChecked = false
                 }else{
                 lblOdometerError.isHidden = true
                 }*/
                
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
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        waitASecond()
    }
    
    func waitASecond(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                   self.navigationItem.rightBarButtonItem?.isEnabled = true
               })
    }
    
    
    //will setup the reservations
    func GetReservations(dealerID: String){
        
        showSpinner(onView: self.view)
        
        print("DealerID: \(dealerID)")
        
        laneLotIDs.removeAll()
        laneLots.removeAll()
        avability.removeAll()
        
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
                    
                    //self.laneLots.append("< ADD RESERVATION >")
                    //self.avability.append("")
                    
                    for i in lotlanes.vl {
                        //print("LaneLotID:\(i.LanelotID), DlrID:\(i.DLrID), LaneLot:\(i.LaneLot), AucID:\(i.AucID), SaleDate:\(i.SaleDate), LotID\(i.LotID), vin:\(i.vin), make:\(i.make), model:\(i.model), yr\(i.yr), lotmemo:\(i.lotmemo)")
                        if (i.vin == "" && i.make == "" && i.model == "") || i.lotmemo != "" {
                            self.laneLots.append("\(i.LaneID)-\(i.LotID)")
                            self.laneLotIDs.append(i.LanelotID)
                            if i.lotmemo == ""{
                                self.avability.append("< available >")
                                // print("LaneLotID:\(i.LanelotID), DlrID:\(i.DLrID), LaneLot:\(i.LaneLot), AucID:\(i.AucID), SaleDate:\(i.SaleDate), LotID:\(i.LotID), vin:\(i.vin), make:\(i.make), model:\(i.model), yr:\(i.yr), lotmemo:\(i.lotmemo)")
                            }else{
                                self.avability.append("< \(i.lotmemo) >")
                            }
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
    
    
    //MARK: Begins the Save/Update process
    @IBAction func UploadVehicle(_ sender: Any) {
        if !checkFieldEntry(btnClicked: "save") {
            print("NOT ALL FIELDS ARE IN!!!")
        }else{
            let alert = UIAlertController(title: "Save", message: "Are you sure you want to save?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
                self.saveVehicle(type: self.ISONPROPERITY)
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveVehicle(type: Bool){
        let lLaneLotID = lanelotID
        let lvin = self.vin
        let seldlr = dealer!.DlrID
        let yr = txtYear.text!.trimmingCharacters(in: .whitespaces)
        let make = txtMake.text!.trimmingCharacters(in: .whitespaces)
        let model = txtModel.text!.trimmingCharacters(in: .whitespaces)
        let body = btnNEWSelectBody.titleLabel!.text!
        let mileage = txtMileage.text!.trimmingCharacters(in: .whitespaces)
        let vehcolor = txtColor.text!.trimmingCharacters(in: .whitespaces)
        let vehclassid = thisVehicleClass!.VehClassID
        let lSecID = String(user!.SecID)
        let sStockNo = txtStockNumber.text!
        let sComment = txtvComments.text!.trimmingCharacters(in: .whitespaces)
        var uvc = ""
         //MARK: Recon Request, if 0 no else yes
        let recon = scReconSelection.selectedSegmentIndex //added recon request
        
        for v in vList{
            if body == v.Series{
                uvc = v.UVC
                break
            }
        }
        
        //is on property
        if type == true {
            let alert = UIAlertController(title: "Update", message: "This will update the existing cars", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let updateURL: String = "https://mobile.aane.com/auction.asmx/updateVehiclesPRE?lAucID=\(self.aucid)&lLaneLotID=\(lLaneLotID)&seldlr=\(seldlr)&Yr=\(self.forURLs(s:yr))&make=\(self.forURLs(s:make))&model=\(self.forURLs(s:model))&body=\(self.forURLs(s:body))&mileage=\(self.forURLs(s:mileage))&vehcolor=\(self.forURLs(s:vehcolor))&vehclassid=\(vehclassid)&lSecID=\(lSecID)&sStockNO=\(self.forURLs(s:sStockNo))&sComment=\(self.forURLs(s:sComment))&UVC=\("TEMP")&reconRequest=\(recon)"
                print(updateURL)
                self.updateVehicle(todoEndpoint: updateURL)
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.default) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(OKAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{ //Is not on property, A NEW CAR
            showSpinner(onView: self.view)
            
            let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/CheckInVehicleMobile?lAucID=\(aucid)&lLaneLotID=\(lLaneLotID)&VIN=\(lvin)&seldlr=\(seldlr)&yr=\(forURLs(s:yr))&make=\(forURLs(s:make))&model=\(forURLs(s:model))&body=\(forURLs(s:body))&mileage=\(forURLs(s:mileage))&vehcolor=\(forURLs(s:vehcolor))&vehclassid=\(vehclassid)&lSecID=\(lSecID)&sStockNO=\(sStockNo)&sComment=\(forURLs(s:sComment))&UVC=\(uvc)&reconRequest=\(recon)"
            
            print("Here is the URL: \(todoEndpoint)")
            
            guard let url = URL(string: todoEndpoint) else {
                print("ERROR: cannot create URL")
                self.removeSpinner()
                return
            }
            
            var urlRequest = URLRequest(url: url)
            
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
                print(data)
                do {//MARK: MANAGE RETURN VALUE HERE
                    
                    
                    let r = try JSONDecoder().decode(myResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        self.removeSpinner()
                        
                        if r.Status.contains("FAILED") {
                            let alert = UIAlertController(title: "Error", message: "\(r.Status)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Status", message: "\(r.Status)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                //MARK: Image Send Starts Here! (UPLOAD)
                                self.sendImages()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        //{ "Status":Checkin FAILED LaneLot assignment failure }
                        
                    }
                    
                }catch{
                    print(error)
                    
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.removeSpinner()
                }
            }
            task.resume()
        }
    }
    
    func updateVehicle(todoEndpoint: String){
        print("Here is the URL: \(todoEndpoint)")
        
        guard let url = URL(string: todoEndpoint) else {
            print("ERROR: cannot create URL")
            self.removeSpinner()
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
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
            print(data)
            do {
                //let t = try JSONDecoder().decode(myResponse.self, from: data)
                let r = try JSONDecoder().decode(myResponse.self, from: data)
                
                DispatchQueue.main.async {
                    //
                    /*let alert = UIAlertController(title: "Success", message: "Vehicle equipment was successfully updated", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                     }))
                     self.present(alert, animated: true, completion: nil)*/
                    self.removeSpinner()
                    //MARK: ImageSend (UPDATE) Negated here if needed
                    
                    
                    
                    if !r.Status.contains("update successful") {
                        let alert = UIAlertController(title: "Error", message: "\(r.Status)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Status", message: "\(r.Status)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.sendImages()
                            //self.navigationController!.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    // self.navigationController!.popToRootViewController(animated: true)
                }
                
            }catch{
                print(error)
                
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                self.removeSpinner()
            }
            
        }
        task.resume()
    }
    
    
    func forURLs(s: String) -> String {
        let newString = s.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return newString.replacingOccurrences(of: " ", with: "%20")
    }
    
    
    //MARK DECODE THE VIN
    func verifyVIN(vin: String){
        showSpinner(onView: self.view)
    
        
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/VINDecode?requestSTR=\(vin)"
        
        //print(todoEndpoint)
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
                    
                    
                    
                    //MARK: Decode process starts here (Work on entering last 6 here)
                   // if vin.count == 6 {
                        
                    //}else{
                        if vehicles.vl.isEmpty{
                            if self.thisVehicleClass?.VehClassDesc == "Car / Truck"{
                                // self.isValid = false
                                let alert = UIAlertController(title: "No Vehicle Found", message: "Unable to link a car/truck with this valid vin: \(self.vin)\nMake sure you have selected the right class and that the vehicle is on property", preferredStyle: .alert)
                                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                //self.isValid = true
                                let alert = UIAlertController(title: "Manually Entry Required", message: "Valid VIN\nClass: (\(self.thisVehicleClass!.VehClassDesc))\nFields must be entered manually", preferredStyle: .alert)
                                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        //}else if vehicles.vl.count > 1 && vin.count == 6 { //MARK: vin should not be six characters and have more then 1 vin
                            //self.AlertMessage(title: "Multiple VINs Found", message: "Cannot properly process this at the moment", pop: true)
                            
                            
                            
                            
                        }else{ //Should only be ONE VIN!!!
                            // self.isValid = true
                            for v in vehicles.vl {
                                // print("--------- Coming From Call ---------")
                                print("ID:\(v.ID), VID:\(v.VID), Make:\(v.Make), Model:\(v.Model), Series:\(v.Series), Yr:\(v.Yr), UVC:\(v.UVC), AucStat:\(v.AucStat), Miles:\(v.Mileage), vehColor:\(v.VehColor), body:\(v.Body), laneLotID:\(v.LaneLotID), laneID:\(v.LaneID), lotID:\(v.LotID), Stock#:\(v.StockNumber)")
                                //", Location:\(v.LOCATION)")
                                //print("--------- Coming From Call ---------")
                                
                                let vel = DecodedVINObject(ID: v.ID, VID: v.VID, Make: v.Make, Model: v.Model, Series: v.Series, Yr: v.Yr, UVC: v.UVC, AucStat: v.AucStat, Mileage: v.Mileage, VehColor: v.VehColor, Body: v.Body, LaneLotID: v.LaneLotID, LaneID: v.LaneID, LotID: v.LotID, StockNumber: v.StockNumber)//, LOCATION: v.LOCATION)//DecodedVINObject(ID: v.ID, VID: v.VID, Make: v.Make, Model: v.Model, Series: v.Series, Yr: v.Yr, UVC: v.UVC,)
                                //print("\(vel.Make), \(vel.Make), \(vel.Model), \(vel.UVC)")
                                self.vList.append(vel)
                            }
                            
                            self.removeSpinner()
                            
                            //MARK: MANAGE EXISTING UNIT, ON PROPERTY, OR PREDELIVERY, SERVICE, RETURN?
                            if self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines) == "PRE" || self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines) == "ACT" || self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines) == "INV" || self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines) == "SLD" {
                                
                                //  self.isValid = true
                                print("\(self.vList[0].Model)")
                                let alert = UIAlertController(title: "Already Checked In", message: "Edit \(self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines)) Vehicle?", preferredStyle: .alert)
                                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    self.ISONPROPERITY = true
                                    self.aucid = self.vList[0].ID.trimmingCharacters(in: .whitespacesAndNewlines)
                                    // self.currentLaneLotID = self.vList[0].LaneLotID
                                    print("\n\nThis vehicle is already in the system, AucID: \(self.aucid)\n\n")
                                    
                                    self.txtYear.text = self.vList[0].Yr.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.txtMake.text = self.vList[0].Make.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.txtModel.text = self.vList[0].Model.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.txtColor.text = self.vList[0].VehColor.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.txtMileage.text = self.vList[0].Mileage.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.txtStockNumber.text = self.vList[0].StockNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    self.btnNEWSelectBody.setTitle(self.vList[0].Body.trimmingCharacters(in: .whitespacesAndNewlines), for: .normal)
                                    self.bodyTypes.append("\(self.vList[0].Body.trimmingCharacters(in: .whitespacesAndNewlines))")
                                    self.bodyTypes.append("Base")//Unknown
                                    self.tvBody.reloadData()
                                    
                                    self.lanelotID = self.vList[0].LaneLotID.trimmingCharacters(in: .whitespacesAndNewlines)
                                    print("The old LaneLotID is: \(self.lanelotID)")
                                    self.btnSelectLotLane.setTitle("\(self.vList[0].LaneID.trimmingCharacters(in: .whitespacesAndNewlines))-\(self.vList[0].LotID.trimmingCharacters(in: .whitespacesAndNewlines))", for: .normal)
                                    
                                    self.lblOldLaneLot.text = "Current Lot: \(self.vList[0].LaneID.trimmingCharacters(in: .whitespacesAndNewlines))-\(self.vList[0].LotID.trimmingCharacters(in: .whitespacesAndNewlines))"
                                    
                                    //MARK: GETS FULL VIN (DEPRECIATE SOON!)
                                    /*if self.vList[0].LOCATION.count == 17 {
                                        self.vin = self.vList[0].LOCATION
                                        let d = self.dealer!.DlrName
                                        let s = self.thisVehicleClass!.VehClassDesc
                                        self.navigationItem.title = "\(d)(\(s): \(self.vin))"
                                        
                                        print("THE NEW DEALERID IS \(d)")
                                    }*/
                                    
                                    self.btnCRPhoto.isHidden = false
                                    self.btnOLPhoto.isHidden = false
                                    
                                }
                                alert.addAction(okAction)
                                
                                let noAction  = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }
                                alert.addAction(noAction)
                                self.present(alert, animated: true, completion: nil)
                                
                                /*}else if self.vList[0].AucStat == "SLDPS" || self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines) == "ACT" || self.vList[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines) == "INV" {
                                 
                                 let alert = UIAlertController(title: "Error", message: "Cannot take with AucStat:\(self.vList[0].AucStat)", preferredStyle: .alert)
                                 //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                 let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                 self.dismiss(animated: true, completion: nil)
                                 
                                 self.navigationController!.popViewController(animated: true)
                                 
                                 
                                 }
                                 alert.addAction(okAction)
                                 self.present(alert, animated: true, completion: nil)*/
                                
                            }else if self.vList[0].Model.contains("Invalid VIN") || self.vList[0].Model.contains("VIN must be 17 characters"){
                                // self.isValid = false
                                print("\(self.vList[0].Model)")
                                let alert = UIAlertController(title: "Invaild VIN", message: "\(self.vList[0].Model)", preferredStyle: .alert)
                                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    self.navigationController!.popViewController(animated: true)
                                    
                                    
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                                
                            }else{//This is for new vehicles
                                
                                self.txtYear.text = self.vList[0].Yr
                                self.txtMake.text = self.vList[0].Make
                                self.txtModel.text = self.vList[0].Model
                                
                                //self.btnNEWSelectBody.setTitle(self.vList[0].Body, for: .normal)
                                
                                self.lanelotID = self.vList[0].LaneLotID
                                
                                self.btnSelectLotLane.setTitle("Select Lane", for: .normal)
                                
                                
                                //adds the different body types to the body table
                                //MARK: Adds Body Types HERE
                                for v in self.vList{
                                    self.bodyTypes.append(v.Series)
                                }
                                //adds these values to the end of the list
                                //self.bodyTypes.append("Enter Body Manually")
                                self.bodyTypes.append("Base")//Unknown
                                
                                if self.bodyTypes.count == 3 {
                                    //self.btnNEWSelectBody.titleLabel?.text = self.bodyTypes[1]
                                    //self.btnNEWSelectBody.setTitle(self.bodyTypes[1], for: .normal)
                                }
                                
                                self.tvBody.reloadData()
                            }
                        }
                        
                    //}
                    
                }//end dispatch
                
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
    
    //manages title
    override func viewDidAppear(_ animated: Bool) {
        let d = dealer!.DlrName
        
        let s = thisVehicleClass!.VehClassDesc
        self.navigationItem.title = "\(d)(\(s): \(vin))"
        if counter != 0 {
            //setBody()
        }
        counter = counter + 1
    }
    
    func editExistingBody(name: String){
        var txtEnterBody = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        
        txtEnterBody.placeholder = name
        txtEnterBody.delegate = self
        // txtEnterBody?.autocapitalizationType = .
        
        let alert = UIAlertController(title: "Input Body", message: "Enter the body manually", preferredStyle: .alert)
        
        alert.addTextField {
            text -> Void in
            txtEnterBody = text
            txtEnterBody.placeholder = "Enter Body Here"
        }
        
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (action)  in
            if txtEnterBody.text != "" {
                self.btnNEWSelectBody.setTitle(txtEnterBody.text, for: .normal)
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
    
    
    @IBAction func SelectBody(_ sender: Any) {
        print(scReconSelection.selectedSegmentIndex)
        if tvBody.isHidden{
            tvBody.isHidden = false
        }else{
            tvBody.isHidden = true
        }
    }
    @IBAction func doubleTap(_ sender: Any) {
        if btnNEWSelectBody.title(for: .normal) != "Select Body"{
            print("DOUBLE TAP!")
            tvLaneLot.isHidden = true
            print("This should be the name: <\(btnNEWSelectBody.title(for: .normal)!)>")
            editExistingBody(name: btnNEWSelectBody.title(for: .normal)!)
            
        }else{
            
        }
        
    }
    
    @IBAction func SelectLane(_ sender: Any) {
        if tvLaneLot.isHidden{
            //if laneLots.isEmpty{
            GetReservations(dealerID: dealer!.DlrID)
            //}
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
        
        //create the lable in ZPL http://labelary.com/viewer.html
        instanceOfCustomeObject.label = "^XA ^FWR ^FO250,20 ^GB550,1180,4^FS    ^FO500,400 ^A0,200,200^FD\(y!)^FS     ^FO300,250 ^A0,200,200^FD\(Int(m!)?.delimiter ?? m!) MI^FS ^FO100,300 ^BY3 ^BCR,100,N,N,N ^FD\(vin)^FS    ^FO35,400 ^A0R,0,50 ^FD\(vin)^FS  ^XZ"
        
        /*
         ^PQ2
         */
        
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
            //self.navigationItem.title = "Back"
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCCamera
            vc.vin = self.vin
            vc.dealer = self.dealer
            //Depreaciated!!!!!
        }else if segue.identifier == "getCode"{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCPrintBarcode
            vc.barcodeVIN = self.vin
            vc.vin = self.vin
            vc.year = "\(self.txtYear.text!)"
            vc.miles = "\(self.txtMileage.text!)"
        }else if segue.identifier == "SelectLane"{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
        }else if segue.identifier == "TakeDefaultOrMileagePic"{
            let vc = segue.destination as! VCTakeDefaultMileagePic
            vc.defaultOrMileage = defaultOrMileage
            vc.delegate = self
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }else if segue.identifier == "viewImage"{
            let vc = segue.destination as! VCViewImage
            if defaultOrMileage == "Default"{
                vc.image = UIIVDefault.image
            }else{
                vc.image = UIIVMileage.image
            }
        }else if segue.identifier == "toEquipment" {
            let vc = segue.destination as! VCEquipment
            vc.vin = vin
            vc.equipmentList = equipmentList
        }else if segue.identifier == "pullINVs"{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCGetInventoryNumbers
            vc.dealerID = dealer!.DlrID
        }else if segue.identifier == "OLandCRpics"{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCAdditionalPhoto
            vc.vin = self.vin
            vc.crORolPhoto = self.crORolPhoto
            //vc.isBanks = isBanks
        }else if segue.identifier == "toBankPhotos" {
            let backItem = UIBarButtonItem()
            backItem.title = "Finish"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCBankOnlineCamera
            vc.vin = self.vin
        }else if segue.identifier == "toSelectEquipment" {
            let vc = segue.destination as! VCEquipmentTypes
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            
            vc.delegate = self
            vc.equipment = self.equ
            vc.selectedEquipmentList = selectedList

            /*
             
             let backItem = UIBarButtonItem()
                        backItem.title = "Back"
                        navigationItem.backBarButtonItem = backItem
                        
                        vc.equipment = self.equ
                        vc.selectedEquipmentList = selectedList
                        vc.delegate = self
             
             */
        
        }
    }
    
    
    func manualBodyEntry() {
        var txtEnterBody: UITextField?
        
        txtEnterBody?.autocapitalizationType = .allCharacters
        // txtEnterBody?.autocapitalizationType = .
        
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
    
    
    
    @IBAction func takeOLPhoto(_ sender: Any) {
        crORolPhoto = "OL"
        performSegue(withIdentifier: "OLandCRpics", sender: nil)
    }
    @IBAction func takeCRPhoto(_ sender: Any) {
        crORolPhoto = "CR"
        performSegue(withIdentifier: "OLandCRpics", sender: nil)
    }
    
    
    func checkIfBankCars() -> Bool {
        if dealer?.DlrID == "524816" {
            print("Shit! its a bank car")
            crORolPhoto = "OL"
           
            return true
        }else{
            print("not a bank car")
            return false
        }
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
            cell.lblAvailabilty.text = avability[indexPath.row]
            cell.lblLaneLotID.text = laneLotIDs[indexPath.row]
            /*if indexPath.row != 0 {
             cell.lblAvailabilty.text = "< \(laneLotList[indexPath.row].vehicle) >"
             }*/
            selectedLane = laneLots[indexPath.row]
            return cell
        }else{
            let cell = tvLaneLot.dequeueReusableCell(withIdentifier: "lotlaneCell") as! TVCLaneLot
            cell.lblLaneLot.text = "UNKNOWN ERROR!"
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
        }else if tableView == self.tvLaneLot{
            if laneLots[indexPath.row] == "< ADD RESERVATION >"{
                //btnSelectLotLane.setTitle(laneLots[indexPath.row], for: .normal)
                performSegue(withIdentifier: "SelectLane", sender: nil)
                lanelotID = laneLotIDs[indexPath.row]
                print("ID for the Lane Lot is now: \(lanelotID)")
                tvLaneLot.isHidden = true
                lblOldLaneLot.isHidden = false
                
            }else{
                if avability[indexPath.row] != "" {
                    btnSelectLotLane.setTitle(laneLots[indexPath.row], for: .normal)
                    lanelotID = laneLotIDs[indexPath.row]
                    print("ID for the Lane Lot is now: \(lanelotID)")
                    tvLaneLot.isHidden = true
                    lblOldLaneLot.isHidden = false
                }else {
                    
                }
            }
        }
    }
    
    
    
    func uploadImage(DorOPhoto: UIImage, isDefault: Bool){
        print("In Upload function")
        let localImageName = "NotStoredLocally\(vin)"
        
        self.showSpinner(onView: self.view)
        
        //let v = String(vin) + String(isDefault) + "TEST"
        print("isDefault: \(isDefault)")
        let v = String(vin) + String(isDefault)
    
        let paramName = v
        let fileName = localImageName
        let image = DorOPhoto
        
        let url = URL(string: "https://mobile.aane.com/Auction.asmx/CheckInSendPicture")
        print(url!)
        // generate boundary string using a unique per-app string
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
        
        let imgResized =  image.resizeWithPercent(percentage: 0.3)
        
        let img = imgResized?.jpegData(compressionQuality: 0.4)
        
        let base64String = img?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        
        data.append(base64String!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            DispatchQueue.main.async {
                
                //print("In UploadTask")
                //print("<Error: \(String(describing: error))>\n")
                //print("<response: \(String(describing: response))\n>")
                //print("<responseData: \(String(describing: responseData))\n>")
                
                if error != nil {
                    self.removeSpinner()
                    
                    let alert = UIAlertController(title: "ERROR", message: "\(String(describing: error))", preferredStyle: .alert)
                    print("\(error!)")
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
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
                            if r == "Success"{
                                let id = json["imageid"] as? Int
                                
                                /*///////////////////////////////////////////////////////////
                                 let alert = UIAlertController(title: r, message: "Photo successfully uploaded\nImageID: \(id ?? 0000000000)", preferredStyle: .alert)
                                 //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                 
                                 let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                 UIAlertAction in
                                 self.dismiss(animated: true, completion: nil)
                                 if self.Odomcount == 0 {
                                 self.Odomcount = 1
                                 self.doOdom()
                                 }else{
                                 self.navigationController!.popToRootViewController(animated: true)
                                 }
                                 }
                                 alert.addAction(okAction)
                                 
                                 self.present(alert, animated: true, completion: nil)
                                 //////////////////////////////////////////////////////////////
                                 */
                                
                                
                                //MARK: Adding extra images, need to rework the upload process! 11/15/2019
                                if self.Odomcount == 0 {
                                    self.Odomcount = 1
                                    self.doOdom()
                                }else{
                                    if self.LRcount == 0 {
                                        self.LRcount = 1
                                        self.doLeftRear()
                                    }else {
                                        if self.RRcount == 0 {
                                            self.RRcount = 1
                                            self.doRightRear()
                                        }else{
                                            if self.RFcount == 0 {
                                                self.RFcount = 1
                                                self.doRightFront()
                                            }else{
                                                /* if self.checkIfBankCars() == true{
                                                    self.performSegue(withIdentifier: "toBankPhotos", sender: nil)
                                                }else{
                                                    self.navigationController!.popToRootViewController(animated: true)
                                                }*/
                                                self.navigationController!.popToRootViewController(animated: true)
                                            }
                                        }
                                    }
                                }
                                
                                
                            }else {
                                self.removeSpinner()
                                
                                let alert = UIAlertController(title: "ERROR", message: "Could not upload photo, make sure vehicle is registered on property", preferredStyle: .alert)
                                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    //MARK: Adding extra images, need to rework the upload process!
                                    if self.Odomcount == 0 {
                                        self.Odomcount = 1
                                        self.doOdom()
                                    }else{
                                        self.navigationController!.popToRootViewController(animated: true)
                                    }
                                    
                                }
                                
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                            
                        }else{
                            
                            let alert = UIAlertController(title: "ERROR", message: "\(json)", preferredStyle: .alert)
                            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                                self.navigationController!.popToRootViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        //}
                        self.removeSpinner()
                    }else{
                        let alert = UIAlertController(title: "ERROR", message: "That wasn't supposed to happen?", preferredStyle: .alert)
                        //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                    self.removeSpinner()
                    
                }
            }
        }).resume()
    }
    
    
    //MARK: LIVE EDITS BEGIN HERE 10/21/2019
    func sendImages(){
        
       /* if defaultImage != nil {
            self.uploadImage(DorOPhoto: self.defaultImage!, isDefault: true)
        }
        if mileageImage != nil {
            self.uploadImage(DorOPhoto: self.mileageImage!, isDefault: false)
        }
        if leftRearImage != nil{
            self.uploadImage(DorOPhoto: self.leftRearImage!, isDefault: false)
        }
        if rightRearImage != nil{
            self.uploadImage(DorOPhoto: self.rightRearImage!, isDefault: false)
        }
        if rightFrontImage != nil {
            self.uploadImage(DorOPhoto: self.rightFrontImage!, isDefault: false)
        }*/
        
        if defaultImage != nil { //UIIVDefault.image
            self.uploadImage(DorOPhoto: self.defaultImage!, isDefault: true)
        }else{
            /*if checkIfBankCars() == true{
                performSegue(withIdentifier: "toBankPhotos", sender: nil)
            }else{
                self.navigationController!.popToRootViewController(animated: true)
            }*/
            //self.navigationController!.popToRootViewController(animated: true)
            Odomcount = 1
            doOdom()
        }
    }
    
    
    func doOdom(){
        if mileageImage != nil { //UIIVMileage.image
            self.uploadImage(DorOPhoto: self.mileageImage!, isDefault: false)
        }else{
            /*if checkIfBankCars() == true{
                performSegue(withIdentifier: "toBankPhotos", sender: nil)
            }else{
                self.navigationController!.popToRootViewController(animated: true)
            }*/
            //self.navigationController!.popToRootViewController(animated: true)
            LRcount = 1
            doLeftRear()
        }
    }
    
    func doLeftRear(){
        if leftRearImage != nil{
            self.uploadImage(DorOPhoto: self.leftRearImage!, isDefault: false)
        }else{
            //self.navigationController!.popToRootViewController(animated: true)
            RRcount = 1
            doRightRear()
        }
    }
    func doRightRear(){
        if rightRearImage != nil{
            self.uploadImage(DorOPhoto: self.rightRearImage!, isDefault: false)
        }else{
            //self.navigationController!.popToRootViewController(animated: true)
            RFcount = 1
            doRightFront()
        }
    }
    func doRightFront(){
        if rightFrontImage != nil{
            self.uploadImage(DorOPhoto: self.rightFrontImage!, isDefault: false)
        }else{
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    

}



extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
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


/*func AlertMessage(title: String, message: String, pop: Bool){
 
 let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
 
 alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
 print("Attempting Default image Upload")
 }))
 alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
 
 }))
 
 }*/
