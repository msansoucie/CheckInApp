//
//  VCSelectLane.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 7/18/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCSelectLane: UIViewController {

    
    var laneToNumTracker = false
    
    @IBOutlet weak var TVLanes: UITableView!
    
    var lane = ["Lane A", "Lane B", "Lane C", "Lane D", "Lane E", "Lane F", "Lane G", "Lane H", "Lane I"]
    var num = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Select Lane"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func determineLane(lane: String) -> String {
        var laneValue = ""
        
        switch lane {
        case "Lane A":
            laneValue = "1"
        case "Lane B":
            laneValue = "2"
        case "Lane C":
            laneValue = "3"
        case "Lane D":
            laneValue = "4"
        case "Lane E":
            laneValue = "5"
        case "Lane F":
            laneValue = "6"
        default:
            laneValue = "???"
        }
    
        return laneValue
    }
    
}

extension VCSelectLane: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if laneToNumTracker {
            return num.count
        }else{
            return lane.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TVLanes.dequeueReusableCell(withIdentifier: "SelectLaneCell") as! TVCSelectLane
        
        if laneToNumTracker {
            cell.lblLane.text = num[indexPath.row]
        }else{
            cell.lblLane.text = lane[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if laneToNumTracker == false {
            self.navigationItem.title = lane[indexPath.row]
            laneToNumTracker = true
            TVLanes.reloadData()
        }
    }
    
}
