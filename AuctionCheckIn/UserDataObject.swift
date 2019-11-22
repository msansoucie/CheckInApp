//
//  UserDataObject.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 11/20/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import Foundation

class UserDataObject {

    var SecID: String
    var FullName: String
    
    init(secID: String, FullName: String) {
        self.SecID = secID
        self.FullName = FullName
    }
    
}
