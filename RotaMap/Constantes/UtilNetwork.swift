//
//  UtilNetwork.swift
//  RotaMap
//
//  Created by Elton Melo on 4/10/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import ReachabilitySwift

class UtilNetwork: NSObject {
    
    class func isNetworkAvailable() -> Bool {
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            return reachability.isReachable()
        } catch {
        }
        
        return false
    }
}
