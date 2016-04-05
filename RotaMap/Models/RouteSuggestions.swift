//
//  RouteSuggestions.swift
//  RotaMap
//
//  Created by Elton Melo on 4/4/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class RouteSuggestions: Mappable {
    
    var data   = [Routes]()
    var size   = 0
    var params = Params()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data   <- map["data"]
        size   <- map["size"]
        params <- map["params"]
    }
}
