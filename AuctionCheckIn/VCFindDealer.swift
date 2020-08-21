//
//  ViewController.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/7/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

protocol getUserDataProtocol {
    func getUD(u: UserDataObject)
}

class VCFindDealer: UIViewController, getUserDataProtocol {
    func getUD(u: UserDataObject) {
        self.user = u
    }
    //, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvSearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    var txtVIN6: UITextField?
    
    var selectedIndex: Int = 0
    
    struct dealerList: Decodable {
        let vl:[d]
    }
    struct d: Decodable {
        var DlrID: String
        var DlrName: String
        var DlrLocation: String
        var ResCount: String
        var InSale: String
        var InInv: String
        var dlrReconFlag: String
    }
    
    var dealerArray = [DealerInfoObject]()
    var searchArray = [DealerInfoObject]()
    
    var myVin6: String = ""
    
    var user: UserDataObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
       //MARK: Add To avoid dealer selection
       /* let last6 = UIBarButtonItem(title: "VIN6", style: .done, target: self, action: #selector(enterExistingVin))
        self.navigationItem.rightBarButtonItem = last6
        navigationItem.rightBarButtonItem?.isEnabled = true*/
        getDealers()
        myTableView.reloadData()
        
        getUserName()
    }
    
    
    func getUserName() {
        performSegue(withIdentifier: "toGetUser", sender: nil)
    }
    
    @objc func enterExistingVin(){
        let alert = UIAlertController(title: "VIN", message: "Enter Last 6 of Existing VIN", preferredStyle: .alert)
        
        alert.addTextField { text -> Void in
            self.txtVIN6 = text
            self.txtVIN6?.placeholder = "vin"
            self.txtVIN6?.keyboardType = .numberPad
        }
        
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (action) in
            let vin6 = self.txtVIN6!.text
            
            if vin6 == "" {
                print("Empty")
            }else if vin6!.count != 6 {
                print("must be 6 digits")
            }else{
                print(vin6!)
                self.myVin6 = vin6!
                self.performSegue(withIdentifier: "existingVIN", sender: nil)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action)  in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(enterAction)
        present(alert, animated: true, completion: nil)

    }
    
    
   
    
    //Will be used to grab a list of all the active dealers once the webservice exist
    func getDealers(){
        showSpinner(onView: self.view)
        let todoEndpoint: String = "https://mobile.aane.com/auction.asmx/getReservationList?requestStr=0"
        dealerArray.removeAll()
            
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
            
            do {
                    
                print(data)
                    
                let t = try JSONDecoder().decode(dealerList.self, from: data)
                    
                DispatchQueue.main.async {
                    if t.vl.isEmpty{
                        print("No Dealers Found")
                    }else{
                        var count = 0
                        
                        for p in t.vl{
                            let del = DealerInfoObject(DlrID: p.DlrID, DlrName: p.DlrName, DlrLocation: p.DlrLocation, ResCount: p.ResCount, InSale: p.InSale, InInv:  p.InInv, dlrReconFlag: p.dlrReconFlag)
                            self.dealerArray.append(del)
                                //print("\(count): \(del.DlrName)\t\t ResCount: \(del.ResCount) \t\tInSale: \(del.InSale) \t\tInInv: \(del.InInv)")
                            count = count + 1
                        }
                        
                        print(self.dealerArray.count)
                        
                        self.searchArray = self.dealerArray
                        self.myTableView.reloadData()
                    }
                        
                }
                self.removeSpinner()
                    
                } catch _{
                    print("Error")
                    self.removeSpinner()
                }
        }
        task.resume()
            
    }
}




extension VCFindDealer: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchArray = dealerArray
            myTableView.reloadData()
            return
        }
        searchArray = dealerArray.filter({(item: DealerInfoObject) -> Bool in 
            item.DlrName.lowercased().starts(with: searchText.lowercased()) || item.DlrID.lowercased().starts(with: searchText.lowercased())
        })
        myTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}

extension VCFindDealer: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return searchArray.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell") as! TVCDealer
        cell.lblDealerName.text = "<\(searchArray[indexPath.row].DlrID)> " + searchArray[indexPath.row].DlrName
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if user == nil {
            performSegue(withIdentifier: "toGetUser", sender: nil)
        }else{
            selectedIndex = indexPath.row
            print(self.dealerArray[indexPath.row].DlrID)
            
            performSegue(withIdentifier: "toVCScanner", sender: nil)
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVCScanner" {
            let vc = segue.destination as! VCScanner
            vc.dealer = searchArray[selectedIndex]
            vc.user = self.user
        }else if segue.identifier == "existingVIN" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            let vc = segue.destination as! VCEditVIN6
            vc.vin6 = myVin6
        }else if segue.identifier == "toGetUser"{
            let vc = segue.destination as! VCUser
            vc.delegate = self
        }
    }

}


//Handels the spinner animation
var vSpinner : UIView?

var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

extension UIViewController{
    func showSpinner(onView : UIView) {
        let SpinnerView = UIView.init(frame: onView.bounds)
        SpinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        DispatchQueue.main.async {
            let ai = UIActivityIndicatorView.init(style: .whiteLarge)
            ai.startAnimating()
            ai.center = SpinnerView.center
            SpinnerView.addSubview(ai)
            onView.addSubview(SpinnerView)
        }
        
        vSpinner = SpinnerView
        vSpinner?.bringSubviewToFront(onView)
        vSpinner?.isHidden = false
       
    }
    func removeSpinner(){
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
            vSpinner?.isHidden = true
        }
    }
}


extension VCFindDealer: UITextFieldDelegate, UITextViewDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtVIN6 {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        
        return true
        
    }
    
}
