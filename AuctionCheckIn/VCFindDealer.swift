//
//  ViewController.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/7/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCFindDealer: UIViewController { //, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvSearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
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
    }
    
    
    var dealerArray = [DealerInfoObject]()
    var searchArray = [DealerInfoObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //self.hideKeyboardWhenTappedAround()
        
        getDealers()
        myTableView.reloadData()
    }

    
    
    
    //Will be used to grab a list of all the active dealers once the webservice exist
    func getDealers(){
            showSpinner(onView: self.view)
            let todoEndpoint: String = "https://mobiletest.aane.com/auction.asmx/getReservationList?requestStr=0"
            
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
                                let del = DealerInfoObject(DlrID: p.DlrID, DlrName: p.DlrName, DlrLocation: p.DlrLocation, ResCount: p.ResCount, InSale: p.InSale, InInv:  p.InInv)
                                self.dealerArray.append(del)
                                //print("\(count): \(del.DlrName)\t\t ResCount: \(del.ResCount) \t\tInSale: \(del.InSale) \t\tInInv: \(del.InInv)")
                                count = count + 1
                            }
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
            item.DlrName.lowercased().starts(with: searchText.lowercased())
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
        cell.lblDealerName.text = searchArray[indexPath.row].DlrName
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        performSegue(withIdentifier: "toVCScanner", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVCScanner"{
            let vc = segue.destination as! VCScanner
            vc.dealer = searchArray[selectedIndex]
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
