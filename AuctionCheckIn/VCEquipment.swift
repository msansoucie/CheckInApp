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
    
    @IBOutlet weak var txtPlate: UITextField!
    
    @IBOutlet weak var sCC: UISwitch!
    @IBOutlet weak var sAC: UISwitch!
    @IBOutlet weak var sPS: UISwitch!
    @IBOutlet weak var sPL: UISwitch!
    @IBOutlet weak var sPW: UISwitch!
    @IBOutlet weak var sTS: UISwitch!
    @IBOutlet weak var sRD: UISwitch!
    @IBOutlet weak var sRAC: UISwitch!
    @IBOutlet weak var sHS: UISwitch!
    @IBOutlet weak var s3rdRS: UISwitch!
    @IBOutlet weak var sNAV: UISwitch!
    @IBOutlet weak var sDVD: UISwitch!
    @IBOutlet weak var sINOP: UISwitch!
    
    //MARK: Variables
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
    
    var inopCode: String = "0"
    var cruiseControlCode: String = "0"
    var airConCode: String = "0"
    var powSteerCode: String = "0"
    var powLocksCode: String = "0"
    var powWindowCode: String = "0"
    var tiltSteerCode: String = "0"
    var rearDefrostCode: String = "0"
    var rearACCode: String = "0"
    var heatedSeatCode: String = "0"
    var RS3Code: String = "0"
    var navCode: String = "0"
    var dvdCode: String = "0"
    
    
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
        
        var siINOP: String
        var siCC: String
        var siAC: String
        var siPS: String
        var siPL: String
        var siPW: String
        var siTilt: String
        var siRD: String
        var siRAC: String
        var siHS: String
        var si3S: String
        var siNAV: String
        var siDVD: String
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
    
    var Platedata: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        getVehicleEquipment()
        
        self.navigationItem.title = "Equipment: \(vin)"

    }
    
    /*@objc func doRO(){
         //waitaSec()
         performSegue(withIdentifier: "toRO", sender: nil)
     }
     
     func waitaSec(){
         DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
             //self.navigationItem.rightBarButtonItem?.isEnabled = true
         })
     }*/
    
       func getVehicleEquipment(){
           
           //showSpinner(onView: self.view)
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
                            self.navigationController?.popToRootViewController(animated: true)
                               //self.navigationController?.popViewController(animated: true)
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
                                       //print(eq.EQGroup)
                                       self.btnEngine.setTitle(eq.EQDesc, for: .normal)
                                       self.engineCode = eq.id
                                   }else if eq.id == "248"{
                                       self.s3rdRS.tag = Int("248")!
                                       //print("3rd Row Seating: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                       if i.si3S != "0" && i.si3S != "" {
                                           print("3rd Row Seating: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                           self.RS3Code = "248"
                                           self.s3rdRS.isOn = true
                                       }else{
                                           print("3rd Row Seating: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                       }
                                   }else if eq.id == i.lTrans.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnTrans.setTitle(eq.EQDesc, for: .normal)
                                       self.transCode = eq.id
                                   }else if eq.id == i.lInterior.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnInterior.setTitle(eq.EQDesc, for: .normal)
                                       self.interiorCode = eq.id
                                   }else if eq.id == i.lRoof.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnRoof.setTitle(eq.EQDesc, for: .normal)
                                       self.roofCode = eq.id
                                   }else if eq.id == i.lRadio.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnRadio.setTitle(eq.EQDesc, for: .normal)
                                       self.radioCode = eq.id
                                   }else if eq.id == i.lBrakes.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnBreaks.setTitle(eq.EQDesc, for: .normal)
                                       self.breaksCode = eq.id
                                   }else if eq.id == i.lSeats.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnSeats.setTitle(eq.EQDesc, for: .normal)
                                       self.seatsCode = eq.id
                                   }else if eq.id == i.lAirBag.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnAirbag.setTitle(eq.EQDesc, for: .normal)
                                       self.airBagCode = eq.id
                                   }else if eq.id == i.lExtColor.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnExteriorColor.setTitle(eq.EQDesc, for: .normal)
                                       self.extColorCode = eq.id
                                   }else if eq.id.trimmingCharacters(in: .whitespaces) == i.IntColor.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnInteriorColor.setTitle(eq.EQDesc, for: .normal)
                                       self.intColorCode = eq.id
                                   }else if eq.id == i.MileageTypeCode.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnMileageType.setTitle(eq.EQDesc, for: .normal)
                                       self.mileTypeCode = eq.id
                                   }else if eq.id == i.TireRating.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnTireRating.setTitle(eq.EQDesc, for: .normal)
                                       self.tireRatingCode = eq.id
                                   }else if eq.id == i.siWheels.trimmingCharacters(in: .whitespaces) {
                                       //print(eq.EQGroup)
                                       self.btnWheels.setTitle(eq.EQDesc, for: .normal)
                                       self.wheelsCode = eq.id
                                   }else if eq.id == i.si4x4.trimmingCharacters(in: .whitespaces){
                                       self.btnDriveType.setTitle(eq.EQDesc, for: .normal)
                                       self.driveTypeCode = eq.id
                                   }else if eq.EQGroup == "CRUISE" {
                                       //Cruise Control
                                       print("Cruise Control: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                       self.sCC.tag = Int(eq.id)!
                                       
                                       if i.siCC != "0" && i.siCC != "" {
                                           self.cruiseControlCode = i.siCC
                                           self.sCC.isOn = true
                                       }
                   
                                   }else if eq.EQGroup == "AIR"{ //i.
                                       //AIR CONDITIONING
                                       print("Air Conditioning: code should be <\(eq.id)>, they have <\(i.siAC)>")
                                       self.sAC.tag = Int(eq.id)!
                                       
                                       if i.siAC != "0" && i.siAC != ""{
                                           self.airConCode = i.siAC
                                           self.sAC.isOn = true
                                       }
                                       
                                   }else if eq.EQGroup == "STEERING" {
                                       //Power Steering
                                       print("Power Steering: code should be <\(eq.id)>, they have <\(i.siPS)>")
                                       self.sPS.tag = Int(eq.id)!
                                       
                                       if i.siPS != "0" && i.siPS != ""{
                                           self.powSteerCode = i.siPS
                                           self.sPS.isOn = true
                                       }
                                       
                                   }else if eq.EQGroup == "LOCKS"{
                                       //Power Locks
                                       print("Power Locks: code should be <\(eq.id)>, they have <\(i.siPL)>")
                                       self.sPL.tag = Int(eq.id)!
                                       
                                       if i.siPL != "0" && i.siPL != ""{
                                           self.powLocksCode = i.siPL
                                           self.sPL.isOn = true
                                       }
                                       
                                   }else if eq.EQGroup == "WINDOWS" {
                                       //POWER WINDOWS
                                       print("Power Windows: code should be <\(eq.id)>, they have <\(i.siPW)>")
                                       self.sPW.tag = Int(eq.id)!

                                       if i.siPW != "0" && i.siPW != "" {
                                           self.powWindowCode = i.siPW
                                           self.sPW.isOn = true
                                       }
                                   
                                   }else if eq.EQGroup == "TILT" {
                                       //TILT STEERING
                                       print("Tilt Steering: code should be <\(eq.id)>, they have <\(i.siTilt)>")
                                       self.sTS.tag = Int(eq.id)!

                                       if i.siTilt != "0" && i.siTilt != "" {
                                           self.tiltSteerCode = i.siTilt
                                           self.sTS.isOn = true
                                       }
                                       
                                   }else if eq.EQGroup == "REAR_DEFROST" {
                                       //Rear Defroster
                                       print("Rear Defroster: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                       self.sRD.tag = Int(eq.id)!

                                       if i.siRD != "0" && i.siRD != "" {
                                           self.rearDefrostCode = i.siRD
                                           self.sRD.isOn = true
                                       }
                                       
                                       
                                   }else if eq.EQGroup == "RSA_Area_Code" {
                                       if eq.EQDesc == "Rear AC"{
                                           //Rear AC
                                           print("Rear AC: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                           self.sRAC.tag = Int(eq.id)!
                                          
                                           if i.siRAC != "0" && i.siRAC != "" {
                                               self.rearACCode = i.siRAC
                                               self.sRAC.isOn = true
                                           }
                                           
                                       }else if eq.EQDesc == "Heated Seats"{
                                           //Heated Seats
                                           print("Heated Seats: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                           self.sHS.tag = Int(eq.id)!

                                           if i.siHS != "0" && i.siHS != "" {
                                               self.heatedSeatCode = i.siHS
                                               self.sHS.isOn = true
                                           }
                                           
                                       }else if eq.EQDesc == "NAV"{
                                           //NAV
                                           print("NAV: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                           self.sNAV.tag = Int(eq.id)!
                                           
                                           if i.siNAV != "0" && i.siNAV != "" {
                                               self.navCode = i.siNAV
                                               self.sNAV.isOn = true
                                           }
                                          
                                           
                                       }else if eq.EQDesc == "DVD"{
                                           //DVD
                                           print("DVD: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                           self.sDVD.tag = Int(eq.id)!

                                           if i.siDVD != "0" && i.siDVD != ""{
                                               self.dvdCode = i.siDVD
                                               self.sDVD.isOn = true
                                           }
                                           
                                       }else if eq.EQDesc == "INOP"{
                                           //INOP
                                           print("INOP: code should be <\(eq.id)>, they have <\(i.siCC)>")
                                           self.sINOP.tag = Int(eq.id)!
                                           
                                           if i.siINOP != "0" && i.siINOP != ""{
                                               self.inopCode = i.siINOP
                                               self.sINOP.isOn = true
                                           }
                                           
                                       }
                                   }
                               }
                           }
                       }
                       print("Its ok if the have a <0> but not <>")

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
       
    
    func forURLs(s: String) -> String {
        let newStr = s.replacingOccurrences(of: " ", with: "%20")
        return newStr
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
        
        var plateComment: String = ""
        
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
            OdomDigitCode = txtOdomDigitCount.text!
        }
        
        if txtPlate.text!.isEmpty {
            plateComment = "0"
        }else{
            plateComment = txtPlate.text!
        }
        
        let alert = UIAlertController(title: "Upload Equipment", message: "Are you sure you want to upload the equipment?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            
        var todoEndpoint: String = "https://mobile.aane.com/auction.asmx/EquipmentUpdate?aucid=\(self.aucid)&lTrans=\(self.transCode)&lEngine=\(self.engineCode)&lRoof=\(self.roofCode)&lRadio=\(self.radioCode)&lAirbag=\(self.airBagCode)&lBrakes=\(self.breaksCode)&lInterior=\(self.interiorCode)&lSeats=\(self.seatsCode)&IntColor=\(self.intColorCode)&sEngineSize=\(engineSizeCode)&lExtColor=\(self.extColorCode)&MileageTypeCode=\(self.mileTypeCode)&seatcount=\(seatCountCode)&OdometerDigits=\(OdomDigitCode)&TireRating=\(self.tireRatingCode)&siWheels=\(self.wheelsCode)&si4x4=\(self.driveTypeCode)&CC=\(self.cruiseControlCode)&AC=\(self.airConCode)&PS=\(self.powSteerCode)&PL=\(self.powLocksCode)&PW=\(self.powWindowCode)&TS=\(self.tiltSteerCode)&RD=\(self.rearDefrostCode)&RAC=\(self.rearACCode)&HS=\(self.heatedSeatCode)&RS3=\(self.RS3Code)&NAV=\(self.navCode)&DVD=\(self.dvdCode)&INOP=\(self.inopCode)&plate=\(plateComment))"
            
        todoEndpoint = self.forURLs(s: todoEndpoint)

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
    
    @IBAction func CCchange(_ sender: Any) {
        print("CC Code was: \(cruiseControlCode)")
        print("tag is: \(sCC.tag)")
        if sCC.isOn{
            sCC.tag = Int("123")!
            cruiseControlCode = String(sCC.tag)
        }else{
            cruiseControlCode = "0"
        }
        print("CC Code is now: \(cruiseControlCode)")
    }
    
    @IBAction func ACchange(_ sender: Any) {
        print("AC Code was: \(airConCode)")
        print("tag is: \(sAC.tag)")
        if sAC.isOn{
            airConCode = String(sAC.tag)
        }else{
            airConCode = "0"
        }
        print("AC Code is now: \(airConCode)")
    }
    
    @IBAction func PSchange(_ sender: Any) {
        print("PS Code was: \(powSteerCode)")
        print("tag is: \(sPS.tag)")
        if sPS.isOn{
            powSteerCode = String(sPS.tag)
        }else{
            powSteerCode = "0"
        }
        print("PS Code is now: \(powSteerCode)")
    }
    
    @IBAction func PWchange(_ sender: Any) {
        print("PW Code was: \(powWindowCode)")
        print("tag is: \(sPW.tag)")
        if sPW.isOn{
            powWindowCode = String(sPW.tag)
        }else{
            powWindowCode = "0"
        }
        print("PW Code is now: \(powWindowCode)")
    }
    
    @IBAction func PLchange(_ sender: Any) {
        print("PL Code was: \(powLocksCode)")
        print("tag is: \(sPW.tag)")
        if sPL.isOn{
            powLocksCode = String(sPL.tag)
        }else{
            powLocksCode = "0"
        }
        print("PW Code is now: \(powLocksCode)")
    }
    
    
    @IBAction func TSchange(_ sender: Any) {
        print("TS Code was: \(tiltSteerCode)")
        print("tag is: \(sTS.tag)")
        if sTS.isOn{
            tiltSteerCode = String(sTS.tag)
        }else{
            tiltSteerCode = "0"
        }
        print("TS Code is now: \(tiltSteerCode)")
    }
    
    @IBAction func RDchange(_ sender: Any) {
        print("RD Code was: \(rearDefrostCode)")
        print("tag is: \(sRD.tag)")
        if sRD.isOn{
            rearDefrostCode = String(sRD.tag)
        }else{
            rearDefrostCode = "0"
        }
        print("RD Code is now: \(rearDefrostCode)")
    }
    
    @IBAction func RAC(_ sender: Any) {
        print("RAC Code was: \(rearACCode)")
        print("tag is: \(sRAC.tag)")
        if sRAC.isOn{
            rearACCode = String(sRAC.tag)
        }else{
            rearACCode = "0"
        }
        print("RAC Code is now: \(rearACCode)")
    }
    
    @IBAction func HSchange(_ sender: Any) {
        print("HS Code was: \(heatedSeatCode)")
        print("tag is: \(sHS.tag)")
        if sHS.isOn{
            heatedSeatCode = String(sHS.tag)
        }else{
            heatedSeatCode = "0"
        }
        print("HS Code is now: \(heatedSeatCode)")
    }
    
    @IBAction func RS3change(_ sender: Any) {
        print("RS3 Code was: \(RS3Code)")
        print("tag is: \(s3rdRS.tag)")
        if s3rdRS.isOn{
            RS3Code = String(s3rdRS.tag)
        }else{
            RS3Code = "0"
        }
        print("RS3 Code is now: \(RS3Code)")
    }
    
    @IBAction func NAVchange(_ sender: Any) {
        print("NAV Code was: \(navCode)")
        print("tag is: \(sNAV.tag)")
        if sNAV.isOn{
            navCode = String(sNAV.tag)
        }else{
            navCode = "0"
        }
        print("NAV Code is now: \(navCode)")
    }
    
    @IBAction func DVDchange(_ sender: Any) {
        print("DVD Code was: \(dvdCode)")
        print("tag is: \(sDVD.tag)")
        if sDVD.isOn{
            dvdCode = String(sDVD.tag)
        }else{
            dvdCode = "0"
        }
        print("DVD Code is now: \(dvdCode)")
    }
    
    @IBAction func INOPchange(_ sender: Any) {
        print("INOP Code was: \(inopCode)")
        print("tag is: \(sINOP.tag)")
        if sINOP.isOn{
            inopCode = String(sINOP.tag)
        }else{
            inopCode = "0"
        }
        print("INOP Code is now: \(inopCode)")
    }
    
    
}


