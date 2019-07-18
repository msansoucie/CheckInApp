//
//  VCSelectLane.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 7/18/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCSelectLane: UIViewController {

    
    @IBOutlet weak var TVLanes: UITableView!
    
    var l = ["Lane A", "Lane B", "Lane C", "Lane D", "lane E", "Lane F", "Lane G", "Lane H", "Lane I"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VCSelectLane: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = TVLanes.dequeueReusableCell(withIdentifier: "SelectLaneCell") as! TVCSelectLane
        
        cell.lblLane.text = l[indexPath.row]
        
        return cell
        
    }
    
    
    
    
    
}
