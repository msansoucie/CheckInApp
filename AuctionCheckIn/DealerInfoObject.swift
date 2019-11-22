//
//  DealerInfoObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/12/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class DealerInfoObject {
    var DlrID: String
    var DlrName: String
    var DlrLocation: String
    var ResCount: String
    var InSale: String
    var InInv: String
    var dlrReconFlag: String
    
    init(DlrID: String, DlrName: String, DlrLocation: String, ResCount: String, InSale: String, InInv: String, dlrReconFlag: String){
        self.DlrID = DlrID
        self.DlrName = DlrName
        self.DlrLocation = ResCount
        self.ResCount = ResCount
        self.InSale = InSale
        self.InInv = InInv
        self.dlrReconFlag = dlrReconFlag
    }


}
