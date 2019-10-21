//
//  VCGetInventoryNumbers.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 9/20/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit
import Foundation

class VCGetInventoryNumbers: UIViewController {

    @IBOutlet weak var tvOpenInventoryList: UITableView!
    @IBOutlet weak var SCinvTypes: UISegmentedControl!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var lblColor: UILabel!
    
    var laneType: String = "99"
    var dealerID: String = ""
    var saleDate: String = ""
    var saleDateLaneLot: String = ""
    
    
   // var NEWsaleDate: String = ""
   // var NEWsaleDateLaneLot: String = ""
    
    var invArray = [inventoryObject]()
    var invBeforeSaleArray = [inventoryObject]()
    var invAfterSaleArray = [inventoryObject]()
    
    var invArraySEARCH = [inventoryObject]()
    var invBeforeSaleArraySEARCH = [inventoryObject]()
    var invAfterSaleArraySEARCH = [inventoryObject]()
    
    var reservedInvArray = [inventoryObject]()
    var sortedInvArray = [inventoryObject]()
    
    
    struct InventoryNumbers: Decodable{
        var vl:[Ilanes]
    }
    struct Ilanes: Decodable {
        var LaneID: String
        var LotID: String
        var LaneLot: String
        
        var vin: String
        var yr: String
        var make: String
        var model: String
        var DLrID: String
    }
    
    struct dateList: Decodable{
        var vl:[SaleDay]
    }
    struct SaleDay: Decodable {
        var SaleDate: String
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        /*let printButton = UIBarButtonItem(title: "Reload", style: .done, target: self, action: #selector(reloadData))
        self.navigationItem.rightBarButtonItem = printButton
        navigationItem.rightBarButtonItem?.isEnabled = true*/
        
        self.navigationItem.title = "Select Inventory Lane and Lot to Locate"
        
        getLanes()
        getDate()
        
        //shortenList()
        sortList(id: laneType)
    }
    

    
    func getDate(){
        //showSpinner(onView: self.view)
               
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/CheckInGetDate?requestSTR=0"
               
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
            
            guard error == nil else {
                print("ERROR: calling GET: \(error!)")
                self.removeSpinner()
                return
            }
                    
            guard let data = data else { print("DATA ERROR!!!"); return }
            
            do {
                let myDate = try JSONDecoder().decode(dateList.self, from: data)
                
                DispatchQueue.main.async {
                    //print(myDate.vl[0].SaleDate.replacingOccurrences(of: " AM", with: ""))
                    //self.NEWsaleDate = myDate.vl[0].SaleDate.replacingOccurrences(of: " AM", with: "")
                    print("SaleDate before: <\(self.saleDate)>")
                    self.saleDate = myDate.vl[0].SaleDate + " 00:00:00"
                    print("SaleDate after: <\(self.saleDate)>")
                    
                    //    var saleDateLaneLot: String = "2019-06-06_1_"
                    print("SaleDateLanelot before: <\(self.saleDateLaneLot)>")
                    self.saleDateLaneLot = "\(myDate.vl[0].SaleDate)_1_"
                    print("SaleDateLanelot after: <\(self.saleDateLaneLot)>")

                    
                    self.removeSpinner()
                }
                self.removeSpinner()
                
            }catch let jsonErr {
                self.removeSpinner()
                              
                let alert = UIAlertController(title: "JSON Error:", message: "\(jsonErr)", preferredStyle: .alert)
                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.removeSpinner()
        }
        task.resume()
        self.removeSpinner()

    }
    
    
    @IBAction func selectInventoryLane(_ sender: Any) {
        switch SCinvTypes.selectedSegmentIndex {
        case 0: //Inventory
            print("Inventory")
            laneType = "99"
        case 1: //Inventory Before Sale
            print("Inventory Before Sale")
            laneType = "97"
        case 2: //Inventory After Sale
            print("Inventory After Sale")
            laneType = "98"
        default:
            let alert = UIAlertController(title: "Error!", message: "Unkown Value In Segment Controller: \(SCinvTypes.selectedSegmentIndex)", preferredStyle: .alert)
            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        //SearchBar.text = ""
        sortList(id: laneType)
    }
    
    
   func sortList(id: String){
        tvOpenInventoryList.reloadData()
    }
    
    
    func getLanes(){
        for i in 1...450{
            invBeforeSaleArray.append(inventoryObject(laneID: "97", lotID: "\(i)", available: true, vehicleData: "", dealerName: "", lanelot: ""))
        }
        for i in 1...2000{
            invAfterSaleArray.append(inventoryObject(laneID: "98", lotID: "\(i)", available: true, vehicleData: "", dealerName: "", lanelot: ""))
        }
        for i in 1...900{
            invArray.append(inventoryObject(laneID: "99", lotID: "\(i)", available: true, vehicleData: "", dealerName: "", lanelot: ""))
        }
        invBeforeSaleArraySEARCH = invBeforeSaleArray
        invAfterSaleArraySEARCH = invAfterSaleArray
        invArraySEARCH = invArray
        
        SearchBar.text = ""
        getReservedINVS()
    }
    
    func getReservedINVS(){
        showSpinner(onView: self.view)
        
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/GetLaneLots?requestSTR=0"
        
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
            guard error == nil else {
                print("ERROR: calling GET: \(error!)")
                self.removeSpinner()
                return
            }
            
            guard let data = data else { print("DATA ERROR!!!"); return }
            
            do{
                
                let lotlanes = try JSONDecoder().decode(InventoryNumbers.self, from: data)
                
                DispatchQueue.main.async {
              
                    for i in lotlanes.vl {
                        self.reservedInvArray.append(inventoryObject(laneID: i.LaneID, lotID: i.LotID, available: false, vehicleData: "VIN: \(String(i.vin.suffix(6))), Yr: \(i.yr.trimmingCharacters(in: .whitespaces)), Make: \(i.make.trimmingCharacters(in: .whitespaces)), Model: \(i.model.trimmingCharacters(in: .whitespaces))", dealerName: i.DLrID, lanelot: i.LaneLot))
                        //print(i.LaneID + "-" + i.LotID)
                        //print(i.LaneLot)
                    }
                
                    print("Reserved lots: \(self.reservedInvArray.count)")
                    self.tvOpenInventoryList.reloadData()
                    self.removeSpinner()

                    //self.filterLanes()
                }
                
            }catch let jsonErr{
                print("-------------\(jsonErr) --------------")
                self.removeSpinner()
                
                let alert = UIAlertController(title: "JSON Error:", message: "\(jsonErr)", preferredStyle: .alert)
                //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                    self.removeSpinner()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.removeSpinner()
            }
            self.removeSpinner()
            
        }
        task.resume()
        
    }
    
    
}

extension VCGetInventoryNumbers: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if laneType == "99"{//inventory
            return invArraySEARCH.count
        }else if laneType == "98" {//after sale
            return invAfterSaleArraySEARCH.count
        }else if laneType == "97" {//before sale
            return invBeforeSaleArraySEARCH.count
        }else{//UNKNOWN!
            return 1
        }
 
        //return sortedInvArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let grayColor = UIView()//used to fix the issue with assigning cell color
        grayColor.backgroundColor = UIColor.lightGray
        
        let RES = UIView()//used to fix the issue with assigning cell color
        RES.backgroundColor = UIColor.red
        
        let cell = tvOpenInventoryList.dequeueReusableCell(withIdentifier: "invCell") as! TVCInventoryLanesLots
        
        if laneType == "99"{//inventory
            cell.lblInventoryNumberLaneLotHolder.text = "I-\(invArraySEARCH[indexPath.row].lotID)"
        }else if laneType == "98" {
            cell.lblInventoryNumberLaneLotHolder.text = "J-\(invAfterSaleArraySEARCH[indexPath.row].lotID)"
        }else if laneType == "97" {
            cell.lblInventoryNumberLaneLotHolder.text = "K-\(invBeforeSaleArraySEARCH[indexPath.row].lotID)"
        }else {
             cell.lblInventoryNumberLaneLotHolder.text = "Unknown laneID Error, LaneID: \(laneType)"
        }
    
 
       /* if (indexPath.row % 2 == 0) {
            cell.backgroundColor = grayColor.backgroundColor//lblColor.backgroundColor
        }else {
             cell.backgroundColor = UIColor.white
        }*/
        
        cell.backgroundColor = UIColor.white
        if laneType == "99" {
            for r in reservedInvArray {
                if invArraySEARCH[indexPath.row].laneID == r.laneID && invArraySEARCH[indexPath.row].lotID == r.lotID {
                    invArraySEARCH[indexPath.row].available = false
                    //cell.lblVehicleData.text = r.vehicleData
                    cell.backgroundColor = RES.backgroundColor
                    cell.isHidden = true
                }
            }
        }else if laneType == "98" {
            for r in reservedInvArray {
                if invAfterSaleArraySEARCH[indexPath.row].laneID == r.laneID && invAfterSaleArraySEARCH[indexPath.row].lotID == r.lotID {
                    invAfterSaleArraySEARCH[indexPath.row].available = false
                    cell.backgroundColor = RES.backgroundColor
                    //cell.lblVehicleData.text = r.vehicleData
                }
            }
        }else if laneType == "97" {
            for r in reservedInvArray {
                if invBeforeSaleArraySEARCH[indexPath.row].laneID == r.laneID && invBeforeSaleArraySEARCH[indexPath.row].lotID == r.lotID {
                    invBeforeSaleArraySEARCH[indexPath.row].available = false
                    cell.backgroundColor = RES.backgroundColor
                    //cell.lblVehicleData.text = r.vehicleData
                    //cell.isEditing = false
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reservedHeight:CGFloat = 0.0
        let returnHeight:CGFloat = 45.0
        
        if laneType == "99" {
            for r in reservedInvArray {
                if invArraySEARCH[indexPath.row].laneID == r.laneID && invArraySEARCH[indexPath.row].lotID == r.lotID {
                    return reservedHeight
                }
            }
        }else if laneType == "98" {
            for r in reservedInvArray {
                if invAfterSaleArraySEARCH[indexPath.row].laneID == r.laneID && invAfterSaleArraySEARCH[indexPath.row].lotID == r.lotID {
                    return reservedHeight
                }
            }
        }else if laneType == "97" {
            for r in reservedInvArray {
                if invBeforeSaleArraySEARCH[indexPath.row].laneID == r.laneID && invBeforeSaleArraySEARCH[indexPath.row].lotID == r.lotID {
                    return reservedHeight
                }
            }
            
        }else{
            print("ERROR")
        }
        
        return returnHeight
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var myInvObject: inventoryObject?
        
        if laneType == "99"{//inventory
            //print("\(invArraySEARCH[indexPath.row].laneID)-\(invArraySEARCH[indexPath.row].lotID)")
            myInvObject = invArraySEARCH[indexPath.row]
        }else if laneType == "98" {//after sale
            //print("\(invAfterSaleArraySEARCH[indexPath.row].laneID)-\(invAfterSaleArraySEARCH[indexPath.row].lotID)")
            myInvObject = invAfterSaleArraySEARCH[indexPath.row]
        }else if laneType == "97" {//before sale
           // print("\(invBeforeSaleArraySEARCH[indexPath.row].laneID)-\(invBeforeSaleArraySEARCH[indexPath.row].lotID)")
              myInvObject = invBeforeSaleArraySEARCH[indexPath.row]
        }else{//UNKNOWN!
            print("Error")
        }
        if myInvObject?.available != false {
            let alert = UIAlertController(title: "Reservation: \(myInvObject!.laneID)-\(myInvObject!.lotID)", message: "Are you sure you want to add this spot for Dealer: \(dealerID)", preferredStyle: .alert)
                            //alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
                 let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { UIAlertAction in
                     self.dismiss(animated: true, completion: nil)
                     self.addReservation(lanelot: myInvObject!)
                 }
                 let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { UIAlertAction in
                         self.dismiss(animated: true, completion: nil)
                 }
                 alert.addAction(okAction)
                 alert.addAction(noAction)
                 self.present(alert, animated: true, completion: nil)
        }else{
            var vData: String = ""
            for r in reservedInvArray {
                if laneType == r.laneID && String(indexPath.row) == r.lotID {
                    vData = "\(r.dealerName)\n\(r.vehicleData)"
                }
            }
            if vData == "" || vData.contains("VIN: , Yr: , Make: , Model: "){
                vData = "Already Reserved"
            }
            
            let alert = UIAlertController(title: "\(laneType)-\(indexPath.row + 1) is unavailable", message: "\(vData)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Add Reservation
    func addReservation(lanelot: inventoryObject){
        print(lanelot.laneID + "-" + lanelot.lotID)
        
        let lLaneid: String = "\(lanelot.laneID)"
        let lLotid: String = "\(lanelot.lotID)"
        let ldlrid: String = "\(self.dealerID)"
        let slanelot: String = "\(saleDateLaneLot)\(lLaneid)_\(lLotid)"
        let dSaleDate: String = "\(saleDate)"
        let lauclocid: String = "1"
        let lSecID: String = "0"
        let lDeleteYN: String = "0"
        
        showSpinner(onView: self.view)
        
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/CheckInWriteReservation?lLaneid=\(lLaneid)&lLotid=\(lLotid)&ldlrid=\(ldlrid)&slanelot=\(slanelot)&dSaleDate=\(forURLs(s: dSaleDate))&lauclocid=\(lauclocid)&lSecID=\(lSecID)&lDeleteYN=\(lDeleteYN)"

        print(todoEndpoint)
        
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
            guard error == nil else {
                print("ERROR: calling GET: \(error!)")
                self.removeSpinner()
                return
            }
            guard let data = data else { print("DATA ERROR!!!"); return }
            do{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "\(lLaneid)-\(lLotid) has been resserved", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                        self.getReservedINVS()
                        self.removeSpinner()
                        self.dismiss(animated: true, completion: nil)
                        //self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    self.removeSpinner()
                }
            }
            
        }
        task.resume()
    }
    
}

func forURLs(s: String) -> String {
      let newString = s.trimmingCharacters(in: .whitespacesAndNewlines)
      
      return newString.replacingOccurrences(of: " ", with: "%20")
  }
  

extension VCGetInventoryNumbers: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //handels how the lots are displayed with the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            invArraySEARCH = invArray
            invAfterSaleArraySEARCH = invAfterSaleArray
            invBeforeSaleArraySEARCH = invBeforeSaleArray
            tvOpenInventoryList.reloadData()
            return
        }
        if laneType == "99" {
            invArraySEARCH = invArray.filter({(item: inventoryObject) -> Bool in
                String(item.lotID).starts(with: String(searchText))
            })
        }else if laneType == "98" {
            invAfterSaleArraySEARCH = invAfterSaleArray.filter({(item: inventoryObject) -> Bool in
                String(item.lotID).starts(with: String(searchText))
            })
        }else if laneType == "97" {
            invBeforeSaleArraySEARCH = invBeforeSaleArray.filter({(item: inventoryObject) -> Bool in
                String(item.lotID).starts(with: String(searchText))
            })
        }else {
            print("?????????????????????")
        }
        tvOpenInventoryList.reloadData()
    }
}

class inventoryObject {
    internal init(laneID: String, lotID: String, available: Bool, vehicleData: String, dealerName: String, lanelot: String) {
        self.laneID = laneID
        self.lotID = lotID
        self.available = available
        self.vehicleData = vehicleData
        self.dealerName = dealerName
        self.lanelot = lanelot
    }
    var laneID: String
    var lotID: String
    var available: Bool
    var vehicleData: String
    var dealerName: String
    var lanelot: String
}


