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
    var SaleDate: String
    var LotID: String
    var vin: String
    var make: String
    var model: String
    var yr: String
    var lotmemo: String
    
    //trimmingCharacters(in: .whitespaces)
    
    init(LaneLotID: String, LaneID: String, DlrID: String, LaneLot: String, AucID: String, SaleDate: String, LotID: String, vin: String, make: String, model: String, yr: String, lotmemo: String){
        self.LaneLotID = LaneLotID
        self.LaneID = LaneID
        self.DlrID = DlrID
        self.LaneLot = LaneLot
        self.AucID = AucID
        self.SaleDate = SaleDate
        self.LotID = LotID
        
        self.vin = vin
        self.make = make.trimmingCharacters(in: .whitespaces)
        self.model = model.trimmingCharacters(in: .whitespaces)
        self.yr = yr
        self.lotmemo = lotmemo
    }
}
