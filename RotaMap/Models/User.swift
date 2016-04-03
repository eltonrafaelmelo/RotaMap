//
//  User.swift
//  RotaMap
//
//  Created by Elton Melo on 4/3/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

    var id                       = 0
    var name                     = ""
    var photo                    = Photo()
    var status                   = 0
    var job                      = ""
    var tel                      = ""
    var email                    = ""
    var address                  = ""
    var car                      = false
    var departure_time           = ""
    var arrival_time             = ""
    var main_way                 = ""
    var company_id               = 0
    var deleted_at               = ""
    var created_at               = ""
    var updated_at               = ""
    var address_lat              = 0.0
    var address_lng              = 0.0
    var first_steps              = 0
    var invisible                = false
    var alt_email                = ""
    var sent_feedback            = false
    var last_login               = ""
    var first_name               = ""
    var photo_url                = ""
    var channel                  = ""
    var home_address             = HomeAddress()
    var work_address             = WorkAddress()
    var home_to_work_recurrence  = HomeToWorkRecurrence()
    var work_to_home_recurrence  = WorkToHomeRecurrence()
    var scores                   = 0
    var spared_co2               = 0
    var points                   = 0
    var ride                     = Ride()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id                       <- map["id"]
        name                     <- map["name"]
        photo                    <- map["photo"]
        status                   <- map["status"]
        job                      <- map["job"]
        tel                      <- map["tel"]
        email                    <- map["email"]
        address                  <- map["address"]
        car                      <- map["car"]
        departure_time           <- map["departure_time"]
        arrival_time             <- map["arrival_time"]
        main_way                 <- map["main_way"]
        company_id               <- map["company_id"]
        deleted_at               <- map["deleted_at"]
        created_at               <- map["created_at"]
        updated_at               <- map["updated_at"]
        address_lat              <- map["address_lat"]
        address_lng              <- map["address_lng"]
        first_steps              <- map["first_steps"]
        invisible                <- map["invisible"]
        alt_email                <- map["alt_email"]
        sent_feedback            <- map["sent_feedback"]
        last_login               <- map["last_login"]
        first_name               <- map["first_name"]
        photo_url                <- map["photo_url"]
        channel                  <- map["channel"]
        home_address             <- map["home_address"]
        work_address             <- map["work_address"]
        home_to_work_recurrence  <- map["home_to_work_recurrence"]
        work_to_home_recurrence  <- map["work_to_home_recurrence"]
        scores                   <- map["scores"]
        spared_co2               <- map["spared_co2"]
        points                   <- map["points"]
        ride                     <- map["ride"]

    }
}
