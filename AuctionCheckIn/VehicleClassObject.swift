//
//  VehicleClassObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/21/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class VehicleClass{
    var VehClassID: String
    var VehClassDesc: String
    var VehicleClassID: String
    var aascsortid: String
    
    init(VehClassID: String, VehClassDesc: String, VehicleClassID: String, aascsortid: String) {
        self.VehClassID = VehClassID
        self.VehClassDesc = VehClassDesc
        self.VehicleClassID = VehicleClassID
        self.aascsortid = aascsortid
    }
    
    
}
