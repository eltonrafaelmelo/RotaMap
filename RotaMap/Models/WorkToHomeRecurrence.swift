//
//  WorkToHomeRecurrence.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class WorkToHomeRecurrence: Mappable {

    var workToHomeId       = 0
    var workMonday         = ""
    var workTuesday        = ""
    var workWednesday      = ""
    var workThursday       = ""
    var workFriday         = ""
    var workSaturday       = ""
    var workSunday         = ""
    var workMonday_way     = ""
    var workTuesday_way    = ""
    var workWednesday_way  = ""
    var workThursday_way   = ""
    var workFriday_way     = ""
    var workSaturday_way   = ""
    var workSunday_way     = ""
    var workDeleted_at     = ""
    var workCreated_at     = ""
    var workUpdated_at     = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        workToHomeId       <- map["id"]
        workMonday         <- map["monday"]
        workTuesday        <- map["tuesday"]
        workWednesday      <- map["wednesday"]
        workThursday       <- map["thursday"]
        workFriday         <- map["friday"]
        workSaturday       <- map["saturday"]
        workSunday         <- map["sunday"]
        workMonday_way     <- map["monday_way"]
        workTuesday_way    <- map["tuesday_way"]
        workWednesday_way  <- map["wednesday_way"]
        workThursday_way   <- map["thursday_way"]
        workFriday_way     <- map["friday_way"]
        workSaturday_way   <- map["saturday_way"]
        workSunday_way     <- map["sunday_way"]
        workDeleted_at     <- map["deleted_at"]
        workCreated_at     <- map["created_at"]
        workUpdated_at     <- map["updated_at"]
    }
}
