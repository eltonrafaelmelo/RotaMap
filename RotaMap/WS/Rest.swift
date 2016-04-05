//
//  Rest.swift
//  RotaMap
//
//  Created by Elton Melo on 4/4/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class Rest {
    
    class func getAuthentication(completionHandler: (authentication: TOAutenticacao?, error: ErrorType?) -> () ){
        let userMorePassword = "luizgabriel.info@gmail.com:bynd2015"
        let base64Encoded = userMorePassword.dataUsingEncoding(NSUTF8StringEncoding)
        let userCredentials = base64Encoded!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let credential = "basic \(userCredentials)"
        
        let header = [
            "Authorization": "\(credential)"
        ]
        
        let urlFinal = "http://bynd-urbbox.herokuapp.com/rest/auth"
        Alamofire.request(.GET, urlFinal, parameters: nil, headers: header)
            .responseObject { (response: TOAutenticacao?, error: ErrorType?) in
                completionHandler(authentication: response as TOAutenticacao?, error: error)
        }
    }
    
    class func postRoutes(user: User!,completionHandler: (routeSuggestions: RouteSuggestions?, error: ErrorType?) -> () ){
        let userMorePassword = "luizgabriel.info@gmail.com:bynd2015"
        let base64Encoded = userMorePassword.dataUsingEncoding(NSUTF8StringEncoding)
        let userCredentials = base64Encoded!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let credential = "basic \(userCredentials)"
        
        let header = [
            "Authorization": "\(credential)"
        ]
        
        let parameters: [String : AnyObject] =
            [
                "start_address": user.home_address.addressHome,
                "start_lat": user.home_address.homeLat,
                "start_lng": user.home_address.homeLng,
                "end_address": user.work_address.addressWork,
                "end_lat": user.work_address.workLat,
                "end_lng": user.work_address.workLng,
                "type": "1",
                "date": "01/04/2016"
        ]
        
        let urlFinal = "http://bynd-urbbox.herokuapp.com/rest/routes/generic/suggestions"
        Alamofire.request(.POST, urlFinal, parameters: parameters, headers: header, encoding: .JSON)
            .responseObject { (response: RouteSuggestions?, error: ErrorType?) in
                completionHandler(routeSuggestions: response as RouteSuggestions?, error: error)
        }
    }

}

