//
//  HomeToWorkRecurrence.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeToWorkRecurrence: Mappable {

    var homeToWorkId   = 0
    var monday         = ""
    var tuesday        = ""
    var wednesday      = ""
    var thursday       = ""
    var friday         = ""
    var saturday       = ""
    var sunday         = ""
    var monday_way     = ""
    var tuesday_way    = ""
    var wednesday_way  = ""
    var thursday_way   = ""
    var friday_way     = ""
    var saturday_way   = ""
    var sunday_way     = ""
    var deleted_at     = ""
    var created_at     = ""
    var updated_at     = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        homeToWorkId   <- map["id"]
        monday         <- map["monday"]
        tuesday        <- map["tuesday"]
        wednesday      <- map["wednesday"]
        thursday       <- map["thursday"]
        friday         <- map["friday"]
        saturday       <- map["saturday"]
        sunday         <- map["sunday"]
        monday_way     <- map["monday_way"]
        tuesday_way    <- map["tuesday_way"]
        wednesday_way  <- map["wednesday_way"]
        thursday_way   <- map["thursday_way"]
        friday_way     <- map["friday_way"]
        saturday_way   <- map["saturday_way"]
        sunday_way     <- map["sunday_way"]
        deleted_at     <- map["deleted_at"]
        created_at     <- map["created_at"]
        updated_at     <- map["updated_at"]
    }
}
