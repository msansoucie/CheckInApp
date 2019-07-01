//
//  DecodedVINObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/19/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class DecodedVINObject {
    
    var ID: String
    var VID: String
    var Make: String
    var Model: String
    var Series: String
    var Yr: String
    var UVC: String
    
    init(ID: String, VID: String, Make: String, Model: String, Series: String, Yr: String, UVC: String){
        self.ID = ID
        self.VID = VID
        self.Make = Make
        self.Model = Model
        self.Series = Series
        self.Yr = Yr
        self.UVC = UVC
    }
    
}
