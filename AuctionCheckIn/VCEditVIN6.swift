//
//  VCEditVIN6.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 10/16/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCEditVIN6: UIViewController {
    
    var vin6: String = ""
    var vin: String = ""
    var dealerID: String = "514253"

    var lanelotID: String = "0"
    var laneLots = [String]()
    var laneLotIDs = [String]()
    var avability = [String]()
    var selectedLane: String = ""
    
    var crORolPhoto: String = "CR"


    
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
        var LOCATION: String
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
    
    
    
    @IBOutlet weak var lblAucStat: UILabel!
    @IBOutlet weak var lblYrError: UILabel!
    @IBOutlet weak var lblMakeError: UILabel!
    @IBOutlet weak var lblModelError: UILabel!
    @IBOutlet weak var lblColorError: UILabel!
    @IBOutlet weak var lblMileageError: UILabel!
    @IBOutlet weak var lblBodyError: UILabel!
    
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtMileage: UITextField!
    @IBOutlet weak var txtStockNumber: UITextField!
    
    @IBOutlet weak var btnChangeDealer: UIButton!
    @IBOutlet weak var btnSelectBody: UIButton!
    @IBOutlet weak var btnSelectLaneLot: UIButton!
    
    @IBOutlet weak var tvLaneLot: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyLast6()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OLandCRpicsLAST6" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCAdditionalPhoto
            vc.vin = self.vin
            vc.crORolPhoto = self.crORolPhoto
        }else if segue.identifier == "pullINVsLast6" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCGetInventoryNumbers
            vc.dealerID = dealerID
        }else if segue.identifier == "changeDealer" {

        }
    }
    
    func verifyLast6() {
        showSpinner(onView: self.view)
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/VINDecode?requestSTR=\(vin6)"
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
        let task = session.dataTask(with:   urlRequest){ data, response, error in
            guard error == nil else{
                print("ERROR: calling GET: \(error!)")
                self.removeSpinner()
                return
            }
            guard let data = data else { print("DATA ERROR!!!"); return}
            do{
                let vehicle = try JSONDecoder().decode(vinVehicles.self, from: data)
                DispatchQueue.main.async {
                    if vehicle.vl.isEmpty {
                        self.ErrorMessage(tit: "No VIN Found", msg: "Make sure the vin was entered properly", popView: true)
                    }else if vehicle.vl.count > 1 {
                        self.ErrorMessage(tit: "Multiple VINS Found", msg: "There Should not be more then one VIN in the system", popView: true)
                    }else{
                        self.txtYear.text = vehicle.vl[0].Yr.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.txtMake.text = vehicle.vl[0].Make.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.txtModel.text = vehicle.vl[0].Model.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.txtColor.text = vehicle.vl[0].VehColor.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.txtMileage.text = vehicle.vl[0].Mileage.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.txtStockNumber.text = vehicle.vl[0].StockNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.lblAucStat.text = "AucStat: \(vehicle.vl[0].AucStat.trimmingCharacters(in: .whitespacesAndNewlines))"
                        
                        self.btnSelectBody.setTitle("\(vehicle.vl[0].Body.trimmingCharacters(in: .whitespacesAndNewlines))", for: .normal)
                        self.btnSelectLaneLot.setTitle("\(vehicle.vl[0].LaneID.trimmingCharacters(in: .whitespacesAndNewlines))-\(vehicle.vl[0].LotID.trimmingCharacters(in: .whitespacesAndNewlines))", for: .normal)
                        self.lanelotID = vehicle.vl[0].LaneLotID.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        self.vin = vehicle.vl[0].LOCATION
                        self.navigationItem.title = vehicle.vl[0].LOCATION
                    }
                    self.removeSpinner()
                }
            }catch let jsonError{
                self.removeSpinner()
                self.ErrorMessage(tit: "JSON ERROR", msg: "\(jsonError)", popView: true)
            }
        }
        task.resume()
    }
    
    @IBAction func changeDealer(_ sender: Any) {
        performSegue(withIdentifier: "changeDealer", sender: nil)
    }
    
    @IBAction func takeOLPhoto(_ sender: Any) {
        crORolPhoto = "OL"
        performSegue(withIdentifier: "OLandCRpicsLAST6", sender: nil)
    }
    @IBAction func takeCRPhoto(_ sender: Any) {
        crORolPhoto = "CR"
        performSegue(withIdentifier: "OLandCRpicsLAST6", sender: nil)
    }
    
    @IBAction func pullInventoryNumbers(_ sender: Any) {
        /*
        tvLaneLot.isHidden = true
        laneLots.removeAll()
        */
        
        performSegue(withIdentifier: "pullINVsLast6", sender: nil)
    }
    
    
    @IBAction func SelectLaneLot(_ sender: Any) {
        if tvLaneLot.isHidden {
            if laneLots.isEmpty{
                GetReservations(dlrID: "")
            }
            tvLaneLot.isHidden = false
        }else{
            tvLaneLot.isHidden = true
        }
    }
    
    func GetReservations(dlrID: String){
        
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
                                   self.avability.append("< reserved >")
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
    
    
    @IBAction func changeBody(_ sender: Any) {
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
                 self.btnSelectBody.setTitle(txtEnterBody?.text, for: .normal)
             }
            // self.tvBody.isHidden = true
         }
         let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action)  in
             self.dismiss(animated: true, completion: nil)
         }
         alert.addAction(cancelAction)
         alert.addAction(enterAction)
         present(alert, animated: true, completion: nil)
    }
    
    
    
    func ErrorMessage(tit: String, msg: String, popView: Bool){
        let alert = UIAlertController(title:  tit, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        
            if popView == true {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Update Vehicle
    @IBAction func saveData(_ sender: Any) {
        
    }

}

extension VCEditVIN6: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laneLots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvLaneLot.dequeueReusableCell(withIdentifier: "lotlaneCell") as! TVCLaneLot
        cell.lblLaneLot.text = laneLots[indexPath.row]
        cell.lblAvailabilty.text = avability[indexPath.row]
        cell.lblLaneLotID.text = laneLotIDs[indexPath.row]
        selectedLane = laneLots[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if laneLots[indexPath.row] == "< ADD RESERVATION >"{
                       //btnSelectLotLane.setTitle(laneLots[indexPath.row], for: .normal)
            performSegue(withIdentifier: "SelectLane", sender: nil)
            lanelotID = laneLotIDs[indexPath.row]
            print("ID for the Lane Lot is now: \(lanelotID)")
            tvLaneLot.isHidden = true
            }else{
            btnSelectLaneLot.setTitle(laneLots[indexPath.row], for: .normal)
            lanelotID = laneLotIDs[indexPath.row]
            print("ID for the Lane Lot is now: \(lanelotID)")
            tvLaneLot.isHidden = true
        }
    }
    
    
}
