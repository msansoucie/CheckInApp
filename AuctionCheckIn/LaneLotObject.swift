//
//  LaneLotObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/27/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class LaneLotObject {
    var LaneLotID: String
    var LaneID: String
    var DlrID: String
    var LaneLot: String
    var AucID: String
    var saleDate: String
    var LotID: String
   // var vin: String
    //var make: String
    
    init(LaneLotID: String, LaneID: String, DlrID: String, LaneLot: String, AucID: String, saleDate: String, LotID: String){
        self.LaneLotID = LaneLotID
        self.LaneID = LaneID
        self.DlrID = DlrID
        self.LaneLot = LaneLot
        self.AucID = AucID
        self.saleDate = saleDate
        self.LotID = LotID
    }
}
