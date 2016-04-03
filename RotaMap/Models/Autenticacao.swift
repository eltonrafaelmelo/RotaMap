//
//  Autenticacao.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class Autenticacao: Mappable {

    var user      = User()
    var token     = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        user       <- map["user"]
        token      <- map["token"]
    }
}
