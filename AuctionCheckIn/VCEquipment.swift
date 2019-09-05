//
//  VCEquipment.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 8/26/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCEquipment: UIViewController, getEquipmentTypeAndName {

    @IBOutlet weak var lblEngine: UILabel!
    @IBOutlet weak var lblTransmission: UILabel!
    @IBOutlet weak var lblInterior: UILabel!
    @IBOutlet weak var lblRoof: UILabel!
    @IBOutlet weak var lblRadio: UILabel!
    @IBOutlet weak var lblBreaks: UILabel!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblAirbag: UILabel!
    @IBOutlet weak var lblDriveType: UILabel!
    @IBOutlet weak var lblExteriorColor: UILabel!
    @IBOutlet weak var lblInteriorColor: UILabel!
    @IBOutlet weak var lblMileageType: UILabel!
    @IBOutlet weak var lblTireRating: UILabel!
    @IBOutlet weak var lblWheels: UILabel!
    
    @IBOutlet weak var btnEngine: UIButton!
    @IBOutlet weak var btnTrans: UIButton!
    @IBOutlet weak var btnInterior: UIButton!
    @IBOutlet weak var btnRoof: UIButton!
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var btnBreaks: UIButton!
    @IBOutlet weak var btnSeats: UIButton!
    @IBOutlet weak var btnAirbag: UIButton!
    @IBOutlet weak var btnDriveType: UIButton!
    @IBOutlet weak var btnExteriorColor: UIButton!
    @IBOutlet weak var btnInteriorColor: UIButton!
    @IBOutlet weak var btnMileageType: UIButton!
    @IBOutlet weak var btnTireRating: UIButton!
    @IBOutlet weak var btnWheels: UIButton!
    
    @IBOutlet weak var txtEngineSize: UITextField!
    @IBOutlet weak var txtSeatCount: UITextField!
    @IBOutlet weak var txtOdomDigitCount: UITextField!
    
    var engineCode: String = "0"
    var transCode: String = "0"
    var interiorCode: String = "0"
    var roofCode: String = "0"
    var radioCode: String = "0"
    var breaksCode: String = "0"
    var seatsCode: String = "0"
    var airBagCode: String = "0"
    var driveTypeCode: String = "0"
    var extColorCode: String = "0"
    var intColorCode: String = "0"
    var mileTypeCode: String = "0"
    var tireRatingCode: String = "0"
    var wheelsCode: String = "0"
    
    /*struct EquipmentList:Decodable {
     let vl: [vcl]
     }
     struct vcl: Decodable{
     var EQGroup: String
     var EQCode: String
     var EQDesc: String
     }*/
    
    struct response:Decodable{
        var Status: String
    }
    
    struct vehiclEquipList:Decodable{
        let vl: [vlE]
    }
    struct vlE:Decodable {
        var aucid: String
        var lTrans: String
        var lEngine: String
        var lRoof: String
        var lRadio: String
        var lAirBag: String
        var lBrakes: String
        var lInterior: String
        var lSeats: String
        var IntColor: String
        var sEngineSize: String
        var lExtColor: String
        var MileageTypeCode: String
        var seatcount: String
        var OdometerDigits: String
        var TireRating: String
        var siWheels: String
        var si4x4: String
    }
    
    struct myResponse: Decodable {
        var retValue: String
    }
    
    
    var vin: String = ""
    var equ: String = ""
    var aucid: String = ""
    
    //var screwedUpCode=[myScrewedUpCode]()
    //Entire Equipment List
    var equipmentList=[EquipmentCodes]()
    
    //Equipment List of Dropdown user selects
    var selectedList=[EquipmentCodes]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVehicleEquipment()
        
        self.navigationItem.title = "Equipment"

    }
    

    func getVehicleEquipment(){
        showSpinner(onView: self.view)
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/getVehicleEquipment?requestStr=\(vin)"
        
        
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
                
                let t = try JSONDecoder().decode(vehiclEquipList.self, from: data)
                DispatchQueue.main.async {
                    print(t.vl)
                    
                    if t.vl.isEmpty {
                        
                        print("There is no vehicle!")
                        
                        let alert = UIAlertController(title: "No Vehicle Found", message: "Make sure the vin has been entered correctly and is in AuctionX", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.disableButtons()
                        self.present(alert, animated: true, completion: nil)
                        
                    }else {
                        
                        for i in t.vl{
                            //  print("\(i.aucid), \(i.IntColor), \(i.lAirBag), \(i.lBrakes), \(i.lExtColor), \(i.lInterior), \(i.lRadio), \(i.lRoof), \(i.lSeats), \(i.lTrans)\n")
                            // print("Engine: <\(i.lEngine)>")
                            
                            //  print("Interior Color \(i.IntColor)")
                            self.txtSeatCount.text = i.seatcount.trimmingCharacters(in: .whitespaces)
                            self.txtEngineSize.text = i.sEngineSize.trimmingCharacters(in: .whitespaces)
                            self.txtOdomDigitCount.text = i.OdometerDigits.trimmingCharacters(in: .whitespaces)
                            self.aucid = i.aucid
                            
                            for eq in self.equipmentList {
                                if eq.id == i.lEngine.trimmingCharacters(in: .whitespaces){
                                    print(eq.EQGroup)
                                    self.btnEngine.setTitle(eq.EQDesc, for: .normal)
                                    self.engineCode = eq.id
                                }else if eq.id == i.lTrans.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnTrans.setTitle(eq.EQDesc, for: .normal)
                                    self.transCode = eq.id
                                }else if eq.id == i.lInterior.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnInterior.setTitle(eq.EQDesc, for: .normal)
                                    self.interiorCode = eq.id
                                }else if eq.id == i.lRoof.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnRoof.setTitle(eq.EQDesc, for: .normal)
                                    self.roofCode = eq.id
                                }else if eq.id == i.lRadio.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnRadio.setTitle(eq.EQDesc, for: .normal)
                                    self.radioCode = eq.id
                                }else if eq.id == i.lBrakes.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnBreaks.setTitle(eq.EQDesc, for: .normal)
                                    self.breaksCode = eq.id
                                }else if eq.id == i.lSeats.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnSeats.setTitle(eq.EQDesc, for: .normal)
                                    self.seatsCode = eq.id
                                }else if eq.id == i.lAirBag.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnAirbag.setTitle(eq.EQDesc, for: .normal)
                                    self.airBagCode = eq.id
                                }else if eq.id == i.lExtColor.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnExteriorColor.setTitle(eq.EQDesc, for: .normal)
                                    self.extColorCode = eq.id
                                }else if eq.id.trimmingCharacters(in: .whitespaces) == i.IntColor.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnInteriorColor.setTitle(eq.EQDesc, for: .normal)
                                    self.intColorCode = eq.id
                                }else if eq.id == i.MileageTypeCode.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnMileageType.setTitle(eq.EQDesc, for: .normal)
                                    self.mileTypeCode = eq.id
                                }else if eq.id == i.TireRating.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnTireRating.setTitle(eq.EQDesc, for: .normal)
                                    self.tireRatingCode = eq.id
                                }else if eq.id == i.siWheels.trimmingCharacters(in: .whitespaces) {
                                    print(eq.EQGroup)
                                    self.btnWheels.setTitle(eq.EQDesc, for: .normal)
                                    self.wheelsCode = eq.id
                                }else if eq.id == i.si4x4.trimmingCharacters(in: .whitespaces){
                                    self.btnDriveType.setTitle(eq.EQDesc, for: .normal)
                                    self.driveTypeCode = eq.id
                                }
                            }
                        }
                    }
                    
                    self.removeSpinner()
                }
                
            }catch {
                print("\(error)")
                self.removeSpinner()
            }
            self.removeSpinner()
        }
        task.resume()
        
    }
    
    
    
    @IBAction func SaveEquipment(_ sender: Any) {
        
        print("Engine: \(self.engineCode)")
        print("Trans: \(self.transCode)")
        print("Roof: \(self.roofCode)")
        print("Radio: \(self.radioCode)")
        print("Airbag: \(self.airBagCode)")
        print("breaks: \(self.breaksCode)")
        print("Interior: \(self.interiorCode)")
        print("Seats: \(self.seatsCode)")
        print("IntColor: \(self.intColorCode)")
        print("EngineSize: \(self.txtEngineSize.text!)")
        print("ExtColor: \(self.extColorCode)")
        print("MileTypeCode: \(self.mileTypeCode)")
        print("seatCount: \(self.txtSeatCount.text!)")
        print("odometerDigitCount: \(self.txtOdomDigitCount.text!)")
        print("TireRating: \(self.tireRatingCode)")
        print("wheels: \(self.wheelsCode)")
        print("drivetype: \(self.driveTypeCode)")
        
        
        var engineSizeCode: String = "0"
        var seatCountCode: String = "0"
        var OdomDigitCode: String = "0"
        
        if txtEngineSize.text == ""{
            engineSizeCode = "0"
        }else{
            engineSizeCode = txtEngineSize.text!
        }
        if txtSeatCount.text == "" {
            seatCountCode = "0"
        }else{
            seatCountCode = txtSeatCount.text!
        }
        if txtOdomDigitCount.text == "" {
            OdomDigitCode = "0"
        }else{
            OdomDigitCode = txtSeatCount.text!
        }
        
        let alert = UIAlertController(title: "Upload Equipment", message: "Are you sure you want to upload the equipment?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            
            let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/EquipmentUpdate?aucid=\(self.aucid)&lTrans=\(self.transCode)&lEngine=\(self.engineCode)&lRoof=\(self.roofCode)&lRadio=\(self.radioCode)&lAirbag=\(self.airBagCode)&lBrakes=\(self.breaksCode)&lInterior=\(self.interiorCode)&lSeats=\(self.seatsCode)&IntColor=\(self.intColorCode)&sEngineSize=\(engineSizeCode)&lExtColor=\(self.extColorCode)&MileageTypeCode=\(self.mileTypeCode)&seatcount=\(seatCountCode)&OdometerDigits=\(OdomDigitCode)&TireRating=\(self.tireRatingCode)&siWheels=\(self.wheelsCode)&si4x4=\(self.driveTypeCode)"
            print(todoEndpoint)
            
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
                print(data)
                
                do {
                    
                    //let t = try JSONDecoder().decode(myResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Success", message: "Vehicle equipment was successfully updated", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        /*if t.retValue == "Success"{
                         let alert = UIAlertController(title: t.retValue, message: "Vehicle equipment was successfully updated", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                         }))
                         self.present(alert, animated: true, completion: nil)
                         }else{
                         let alert = UIAlertController(title: t.retValue, message: "Vehicle equipment was unsuccessful in update", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
                         }))
                         self.present(alert, animated: true, completion: nil)
                         }*/
                    }
                    
                }catch{
                    print(error)
                }
            }
            task.resume()
            
        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func disableButtons(){
        self.btnEngine.isEnabled = false
        self.btnTrans.isEnabled = false
        self.btnInterior.isEnabled = false
        self.btnRoof.isEnabled = false
        self.btnRadio.isEnabled = false
        self.btnBreaks.isEnabled = false
        self.btnSeats.isEnabled = false
        self.btnAirbag.isEnabled = false
        self.btnDriveType.isEnabled = false
        self.btnExteriorColor.isEnabled = false
        self.btnInteriorColor.isEnabled = false
        self.btnMileageType.isEnabled = false
        self.btnTireRating.isEnabled = false
        self.btnWheels.isEnabled = false
        self.txtSeatCount.isEnabled = false
        self.txtEngineSize.isEnabled = false
        self.txtOdomDigitCount.isEnabled = false
    }
    
    //MARK Handle the Equipment drop downs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectType"{
            let vc = segue.destination as! VCEquipmentTypes
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            vc.equipment = self.equ
            vc.selectedEquipmentList = selectedList
            vc.delegate = self
        }
    }
    
    @IBAction func EngineTypes(_ sender: Any) {
        equ = lblEngine.text!
        getList(group: "ENGINE")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func TransType(_ sender: Any) {
        equ = lblTransmission.text!
        getList(group: "TRANSMISSION")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func InteriorType(_ sender: Any) {
        equ = lblInterior.text!
        getList(group: "INTERIORTYPE")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func RoofType(_ sender: Any) {
        equ = lblRoof.text!
        getList(group: "ROOF")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func RadioType(_ sender: Any) {
        equ = lblRadio.text!
        getList(group: "RADIO")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func BreaksType(_ sender: Any) {
        equ = lblBreaks.text!
        getList(group: "BRAKES")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func SeatsType(_ sender: Any) {
        equ = lblSeats.text!
        getList(group: "SEATS")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func AirbagTypes(_ sender: Any) {
        equ = lblAirbag.text!
        getList(group: "AIRBAG")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func DriveTypes(_ sender: Any) {
        equ = lblDriveType.text!
        getList(group: "DRIVETYPE")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func ExteriorColorTypes(_ sender: Any) {
        equ = lblExteriorColor.text!
        getList(group: "EXTCOLOR")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func InteriorColorTypes(_ sender: Any) {
        equ = lblInteriorColor.text!
        getList(group: "COLOR")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func MileageType(_ sender: Any) {
        equ = lblMileageType.text!
        getList(group: "MILEAGETYPE")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func TireRatingTypes(_ sender: Any) {
        equ = lblTireRating.text!
        getList(group: "TIRE_RATING")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    @IBAction func WheelsTypes(_ sender: Any) {
        equ = lblWheels.text!
        getList(group: "WHEELS")
        performSegue(withIdentifier: "selectType", sender: nil)
    }
    
    func getList(group: String) {
        selectedList.removeAll()
        for e in equipmentList {
            if e.EQGroup == group {
                selectedList.append(e)
            }
        }
    }
    
    //magages the codeID and button description form the other page
    func getData(name: String, buttonName: String, code: String) {
        switch buttonName {
        case "Engine":
            btnEngine.setTitle(name, for: .normal)
            engineCode = code
        case "Trans":
            btnTrans.setTitle(name, for: .normal)
            transCode = code
        case "Interior":
            btnInterior.setTitle(name, for: .normal)
            interiorCode = code
        case "Roof":
            btnRoof.setTitle(name, for: .normal)
            roofCode = code
        case "Radio":
            btnRadio.setTitle(name, for: .normal)
            radioCode = code
        case "Brakes":
            btnBreaks.setTitle(name, for: .normal)
            breaksCode = code
        case "Seats":
            btnSeats.setTitle(name, for: .normal)
            seatsCode = code
        case "Airbag":
            btnAirbag.setTitle(name, for: .normal)
            airBagCode = code
        case "Drive Type":
            btnDriveType.setTitle(name, for: .normal)
            driveTypeCode = code
        case "Exterior Color":
            btnExteriorColor.setTitle(name, for: .normal)
            extColorCode = code
        case "Interior Color":
            btnInteriorColor.setTitle(name, for: .normal)
            intColorCode = code
        case "Mileage Type":
            btnMileageType.setTitle(name, for: .normal)
            mileTypeCode = code
        case "Tire Rating":
            btnTireRating.setTitle(name, for: .normal)
            tireRatingCode = code
        case "Wheels":
            btnWheels.setTitle(name, for: .normal)
            wheelsCode = code
        default:
            print("!!!!!!!!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!!!!!!!!")
        }
    }
    
}


