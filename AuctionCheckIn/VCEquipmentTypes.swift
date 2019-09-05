//
//  VCEquipmentTypes.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 8/26/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

protocol getEquipmentTypeAndName {
    func getData(name: String, buttonName: String, code: String)
}

class VCEquipmentTypes: UIViewController {
    
    var equipment:String = ""
    var selectedEquipmentList=[EquipmentCodes]()
    
    
    var delegate: getEquipmentTypeAndName?
    
    @IBOutlet weak var tvEquipmentTypes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if equipment == "Trans"{
            self.navigationItem.title = "Transmission"
        }else{
            self.navigationItem.title = equipment
        }
        
        selectedEquipmentList.insert(EquipmentCodes(EQGroup: "", EQDesc: "<N/A>", id: "0"), at: 0)
        
    }
    
}

extension VCEquipmentTypes: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedEquipmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EQCell") as! TVCEquipmentTypes
        cell.lblEquipmentTypes.text = selectedEquipmentList[indexPath.row].EQDesc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n:String = selectedEquipmentList[indexPath.row].EQDesc
        let c: String = selectedEquipmentList[indexPath.row].id
        delegate?.getData(name: n, buttonName: equipment, code: c)
        navigationController?.popViewController(animated: true)
    }
    
    
}
