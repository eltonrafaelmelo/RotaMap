//
//  RouteViewController.swift
//  RotaMap
//
//  Created by Elton Melo on 4/8/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import GoogleMaps

enum TravelModes: Int {
    case driving
    case walking
    case bicycling
}

class RouteViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var autenticacao = TOAutenticacao()
    var mapRoute = RouteMap()
    var travelMode = TravelModes.walking
    var routePolyline: GMSPolyline!
    var waypointsArray: Array<String> = []
    var markersArray: Array<GMSMarker> = []
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rotas"
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        getAutenticacao()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - get user
    func getAutenticacao() {
        Rest.getAuthentication() {authentication, error in
            //            self.util.hideActivityIndicator()
            if let _ = error {
                //                self.util.showMessage(self, message: "\(error)")
            } else {
                self.autenticacao = authentication!
                self.createRoute()
            }
        }
    }
    
    //MARK: - Create route
    func createRoute() {
        
            if  (self.routePolyline != nil) {
                self.clearRoute()
                self.waypointsArray.removeAll(keepCapacity: false)
            }
            
            let origin = "Fortaleza"
            let destination = "Fortaleza"
        
        let positionStringOrigin = String(format: "%f", autenticacao.data.user.home_address.homeLat) + "," + String(format: "%f", autenticacao.data.user.home_address.homeLng)
        let positionStringDestino = String(format: "%f", autenticacao.data.user.work_address.workLat) + "," + String(format: "%f", autenticacao.data.user.work_address.workLng)
        waypointsArray.append(positionStringOrigin)
        waypointsArray.append(positionStringDestino)
        
        let origem = CLLocationCoordinate2D(latitude: autenticacao.data.user.home_address.homeLat, longitude: autenticacao.data.user.home_address.homeLng)
        let destino = CLLocationCoordinate2D(latitude: autenticacao.data.user.work_address.workLat, longitude: autenticacao.data.user.work_address.workLng)

        let bounds = GMSCoordinateBounds(coordinate: origem, coordinate: destino)
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 50.0))
        
//        let bounds = GMSCoordinateBounds(coordinate: origem, coordinate: destino)
//        let camera = mapView.cameraForBounds(bounds, insets:UIEdgeInsetsZero)
//        mapView.camera = camera!
//        
            self.mapRoute.getDirections(origin, destination: destination, waypoints: waypointsArray, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
                if success {
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                }
                else {
                    print(status)
                }
            })
    }
    
    func clearRoute() {
        originMarker.map = nil
        destinationMarker.map = nil
        routePolyline.map = nil
        
        originMarker = nil
        destinationMarker = nil
        routePolyline = nil
        
        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            
            markersArray.removeAll(keepCapacity: false)
        }
    }
    
    func configureMapAndMarkersForRoute() {
        mapView.camera = GMSCameraPosition.cameraWithTarget(mapRoute.originCoordinate, zoom: 9.0)
        
        originMarker = GMSMarker(position: self.mapRoute.originCoordinate)
        originMarker.map = self.mapView
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        originMarker.title = "Origem"
        
        destinationMarker = GMSMarker(position: self.mapRoute.destinationCoordinate)
        destinationMarker.map = self.mapView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = "Destino"
        
        
        if waypointsArray.count > 0 {
            for waypoint in waypointsArray {
                let lat: Double = (waypoint.componentsSeparatedByString(",")[0] as NSString).doubleValue
                let lng: Double = (waypoint.componentsSeparatedByString(",")[1] as NSString).doubleValue
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
                marker.map = mapView
                marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
                
                markersArray.append(marker)
            }
        }
    }
    
    
    func drawRoute() {
        let route = mapRoute.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = mapView
    }
    
    func recreateRoute() {
        if  (routePolyline != nil) {
            clearRoute()
            
            mapRoute.getDirections(mapRoute.originAddress, destination: mapRoute.destinationAddress, waypoints: waypointsArray, travelMode: travelMode, completionHandler: { (status, success) -> Void in
                
                if success {
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                }
                else {
                    print(status)
                }
            })
        }
    }
    
    // MARK: GMSMapViewDelegate method implementation
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        if (routePolyline != nil) {
            let positionString = String(format: "%f", coordinate.latitude) + "," + String(format: "%f", coordinate.longitude)
            waypointsArray.append(positionString)
            
            recreateRoute()
        }
    }
    
}
