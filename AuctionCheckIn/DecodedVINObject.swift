//
//  DecodedVINObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/19/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class DecodedVINObject {
    init(ID: String, VID: String, Make: String, Model: String, Series: String, Yr: String, UVC: String, AucStat: String, Mileage: String, VehColor: String, Body: String, LaneLotID: String, LaneID: String, LotID: String, StockNumber: String) {  //LOCATION: String) {
        self.ID = ID
        self.VID = VID
        self.Make = Make
        self.Model = Model
        self.Series = Series
        self.Yr = Yr
        self.UVC = UVC
        
        self.AucStat = AucStat
        self.Mileage = Mileage
        self.VehColor = VehColor
        self.Body = Body
        self.LaneLotID = LaneLotID
        self.LaneID = LaneID
        self.LotID = LotID
        self.StockNumber = StockNumber
       // self.LOCATION = LOCATION
    }
    
    
    var ID: String
    var VID: String
    var Make: String
    var Model: String
    var Series: String
    var Yr: String
    var UVC: String
    
    var AucStat: String
    var Mileage: String
    var VehColor: String
    var Body: String
    var LaneLotID: String
    var LaneID: String
    var LotID: String
    var StockNumber: String
   // var LOCATION: String
    
    

    
}
