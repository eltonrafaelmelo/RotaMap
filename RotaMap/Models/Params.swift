//
//  Params.swift
//  RotaMap
//
//  Created by Elton Melo on 4/4/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class Params: Mappable {

    var generic_route_id = 0

    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        generic_route_id <- map["generic_route_id"]
    }
}
