//
//  WorkAddress.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class WorkAddress: Mappable {

    var addressWork = ""
    var workLat     = 0.0
    var workLng     = 0.0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        addressWork <- map["address"]
        workLat     <- map["lat"]
        workLng     <- map["lng"]
    }
}
