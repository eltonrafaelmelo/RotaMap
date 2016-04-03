//
//  Ride.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class Ride: Mappable {
    
    var schedule    = ""
    var route_id    = 0
    var user_id     = 0
    var routine_id  = 0
    var spaces      = 0
    var way         = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        schedule     <- map["schedule"]
        route_id     <- map["route_id"]
        user_id      <- map["user_id"]
        routine_id   <- map["routine_id"]
        spaces       <- map["spaces"]
        way          <- map["way"]
    }
}
