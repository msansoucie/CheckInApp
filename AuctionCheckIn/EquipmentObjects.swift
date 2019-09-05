//
//  EquipmentType.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 8/26/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation


class vehicleEquipment{
    
    var aucid: String
    var lTrans: String
    var lEngine: String
    var lRoof: String
    var lRadio: String
    var lAirbag: String
    var lBreaks: String
    var lInherior: String
    var lSeats: String
    var IntColor: String
    var sEngineSize: String
    var lExtColor: String
    var MileageTypeCode: String
    var seatCount: String
    var OdometerDigits: String
    var TireRating: String
    var siWheels: String
    var si4x4: String
    
    init(aucid: String, lTrans: String, lEngine: String, lRoof: String, lRadio: String, lAirbag: String, lBreaks: String, lInherior: String, lSeats: String, IntColor: String, sEngineSize: String, lExtColor: String, MileageTypeCode: String, seatCount: String, OdometerDigits: String, TireRating: String, siWheels: String, si4x4: String) {
        self.aucid = aucid
        self.lTrans = lTrans
        self.lEngine = lEngine
        self.lRoof = lRoof
        self.lRadio = lRadio
        self.lAirbag = lAirbag
        self.lBreaks = lBreaks
        self.lInherior = lInherior
        self.lSeats = lSeats
        self.IntColor = IntColor
        self.sEngineSize = sEngineSize
        self.lExtColor = lExtColor
        self.MileageTypeCode = MileageTypeCode
        self.seatCount = seatCount
        self.OdometerDigits = OdometerDigits
        self.TireRating = TireRating
        self.siWheels = siWheels
        self.si4x4 = si4x4
    }
    
}


class EquipmentCodes {
    var EQGroup: String
    var EQDesc: String
    var id: String
    
    init(EQGroup: String, EQDesc: String, id: String) {
        self.EQGroup = EQGroup
        self.EQDesc = EQDesc
        self.id = id
    }
    
}

class myScrewedUpCode {
    var EQGroup: String
    var EQDesc: String
    var EQCode: String
    
    init(EQGroup: String, EQDesc: String, EQCode: String) {
        self.EQGroup = EQGroup
        self.EQDesc = EQDesc
        self.EQCode = EQCode
    }
    
}

