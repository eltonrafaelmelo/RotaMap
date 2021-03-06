//
//  RouteMap.swift
//  RotaMap
//
//  Created by Elton Melo on 4/8/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import CoreLocation

class RouteMap: NSObject {
    
    let baseURLGeocode = Constant.URL_GEOCODE
    
    var lookupAddressResults: Dictionary<NSObject, AnyObject>!
    
    var fetchedFormattedAddress: String!
    
    var fetchedAddressLongitude: Double!
    
    var fetchedAddressLatitude: Double!
    
    let baseURLDirections = Constant.URL_DIRECTIONS
    
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var originAddress: String!
    
    var destinationAddress: String!
    
    var totalDistanceInMeters: UInt = 0
    
    var totalDistance: String!
    
    var totalDurationInSeconds: UInt = 0
    
    var totalDuration: String!
    
    override init() {
        super.init()
    }
    
    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: TravelModes!, completionHandler: ((status: String, success: Bool) -> Void)) {
        
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                
                if let routeWaypoints = waypoints {
                    directionsURLString += "&waypoints=optimize:true"
                    
                    for waypoint in routeWaypoints {
                        directionsURLString += "|" + waypoint
                    }
                }
                
                if  (travelMode != nil) {
                    var travelModeString = ""
                    
                    switch travelMode.rawValue {
                    case TravelModes.walking.rawValue:
                        travelModeString = "walking"
                        
                    case TravelModes.bicycling.rawValue:
                        travelModeString = "bicycling"
                        
                    default:
                        travelModeString = "driving"
                    }
                    
                    directionsURLString += "&mode=" + travelModeString
                }
                
                directionsURLString = directionsURLString.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                let directionsURL = NSURL(string: directionsURLString)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let directionsData = NSData(contentsOfURL: directionsURL!)
                    
                    do {
                        
                        if directionsData != nil {
                            
                            let dictionary = try NSJSONSerialization.JSONObjectWithData(directionsData!, options: [])
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<NSObject, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<NSObject, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<NSObject, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                self.originAddress = legs[0]["start_address"] as! String
                                self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                
                                self.calculateTotalDistanceAndDuration()
                                
                                completionHandler(status: status, success: true)
                            }
                            else {
                                completionHandler(status: status, success: false)
                            }
                            
                        }
                        
                    } catch let error as NSError {
                        // failure
                        print("Fetch failed: \(error.localizedDescription)")
                    }
                })
            }
            else {
                completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            completionHandler(status: "Origin is nil", success: false)
        }
    }
    
    func calculateTotalDistanceAndDuration() {
        let legs = self.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
        }
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distância: \(distanceInKilometers) Km"
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        let hora = hours > 1 ? "horas" : "hora"
        let dia = days > 1 ? "dias" : "dia"
        let segundo = remainingSecs > 1 ? "segundos" : "segundo"

        
        totalDuration = "Duração: \(days) \(dia), \(remainingHours) \(hora), \(remainingMins) minutos, \(remainingSecs) \(segundo)"
    }
}
