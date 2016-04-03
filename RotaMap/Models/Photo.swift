//
//  Photo.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo: Mappable {
    
    var public_id           = ""
    var version             = 0
    var signature           = ""
    var width               = 0
    var height              = 0
    var format              = ""
    var resource_type       = ""
    var created_at          = ""
    //    var tags                = 0
    var bytes               = 0
    var type                = ""
    var etag                = ""
    var url                 = ""
    var secure_url          = ""
    var original_filename   = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        public_id            <- map["public_id"]
        version              <- map["version"]
        signature            <- map["signature"]
        width                <- map["width"]
        height               <- map["height"]
        format               <- map["format"]
        resource_type        <- map["resource_type"]
        created_at           <- map["created_at"]
//        tags                 <- map["tags"]
        bytes                <- map["bytes"]
        type                 <- map["type"]
        etag                 <- map["etag"]
        url                  <- map["url"]
        secure_url           <- map["secure_url"]
        original_filename    <- map["original_filename"]
    }
}
