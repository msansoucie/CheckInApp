//
//  CheckInObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/26/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class CheckInObject {
    
    var Dealer: DealerInfoObject
    var laneLot: String
    var vin: String
    var vData: DecodedVINObject
    var vType: VehicleClass
    
    init(Dealer: DealerInfoObject, laneLot: String, vin: String, vData: DecodedVINObject, vType: VehicleClass) {
        self.Dealer = Dealer
        self.laneLot = laneLot
        self.vin = vin
        self.vData = vData
        self.vType = vType
    }
    
    
    
}
