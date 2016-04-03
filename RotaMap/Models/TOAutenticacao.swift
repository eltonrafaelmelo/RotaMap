//
//  TOAutenticacao.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class TOAutenticacao: Mappable {

    var data      = Autenticacao()
    var size      = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data      <- map["data"]
        size      <- map["size"]
    }
}
