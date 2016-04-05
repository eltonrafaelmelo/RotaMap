//
//  Routes.swift
//  RotaMap
//
//  Created by Elton Melo on 4/4/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class Routes: Mappable {

    var id                = 0
    var name              = ""
    var start_address     = ""
    var end_address       = ""
    var start_lat         = 0.0
    var start_lng         = 0.0
    var end_lat           = 0.0
    var end_lng           = 0.0
    var near_routes_count = 0
    var user_id           = 0
    var processed         = false
    var deleted_at        = ""
    var created_at        = ""
    var updated_at        = ""
    var path_id           = ""
    var type              = 0
    var distance          = ""
    var start_name        = ""
    var end_name          = ""
    var user              = User()

    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id                <- map["id"]
        name              <- map["name"]
        start_address     <- map["start_address"]
        end_address       <- map["end_address"]
        start_lat         <- map["start_lat"]
        start_lng         <- map["start_lng"]
        end_lat           <- map["end_lat"]
        end_lng           <- map["end_lng"]
        near_routes_count <- map["near_routes_count"]
        user_id           <- map["user_id"]
        processed         <- map["processed"]
        deleted_at        <- map["deleted_at"]
        created_at        <- map["created_at"]
        updated_at        <- map["updated_at"]
        path_id           <- map["path_id"]
        type              <- map["type"]
        distance          <- map["distance"]
        start_name        <- map["start_name"]
        end_name          <- map["end_name"]
        user              <- map["user"]
    }
}
