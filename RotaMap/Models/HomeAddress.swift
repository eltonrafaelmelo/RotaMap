//
//  HomeAddress.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeAddress: Mappable {
    
    var addressHome = ""
    var homeLat = 0.0
    var homeLng = 0.0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        addressHome <- map["address"]
        homeLat     <- map["lat"]
        homeLng     <- map["lng"]
    }
}
