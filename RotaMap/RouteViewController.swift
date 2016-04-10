//
//  RouteViewController.swift
//  RotaMap
//
//  Created by Elton Melo on 4/8/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import GoogleMaps
import JLToast


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
    var util = Util.sharedInstance
    var routes = RouteSuggestions()
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelInfo2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rotas"
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if UtilNetwork.isNetworkAvailable() {
            getAutenticacao()
        } else {
            JLToast.makeText("No memento você está sem internet. Tente novamente quando tiver conexão.").show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - get user
    func getAutenticacao() {
        util.showActivityIndicator()
        Rest.getAuthentication() {authentication, error in
            self.util.hideActivityIndicator()
            if let _ = error {
                self.util.showMessage(self, message: "\(error)")
            } else {
                self.autenticacao = authentication!
                self.createRoute()
            }
        }
    }
    
    //MARK: - POST routes
    func postRoutes() {
        util.showActivityIndicator()
        Rest.postRoutes(autenticacao.data.user) {routeSuggestions, error in
            self.util.hideActivityIndicator()
            if let _ = error {
                self.util.showMessage(self, message: "\(error)")
            } else {
                self.routes = routeSuggestions!
                self.treatingRoute()
            }
        }
    }
    
    //MARK: - Create route
    func clearRoutes() {
        self.clearRoute()
        self.waypointsArray.removeAll(keepCapacity: false)
        util.hideActivityIndicator()
        createRoute()
    }
    
    func createRoute() {
        
        if  (self.routePolyline != nil) {
            self.clearRoute()
            self.waypointsArray.removeAll(keepCapacity: false)
        }
        
        let positionStringOrigin = String(format: "%f", autenticacao.data.user.home_address.homeLat) + "," + String(format: "%f", autenticacao.data.user.home_address.homeLng)
        let positionStringDestino = String(format: "%f", autenticacao.data.user.work_address.workLat) + "," + String(format: "%f", autenticacao.data.user.work_address.workLng)
        waypointsArray.append(positionStringOrigin)
        waypointsArray.append(positionStringDestino)
        
        let origem = CLLocationCoordinate2D(latitude: autenticacao.data.user.home_address.homeLat, longitude: autenticacao.data.user.home_address.homeLng)
        let destino = CLLocationCoordinate2D(latitude: autenticacao.data.user.work_address.workLat, longitude: autenticacao.data.user.work_address.workLng)
        
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(GMSCoordinateBounds(coordinate: origem, coordinate: destino)))
        
        self.mapRoute.getDirections(positionStringOrigin, destination: positionStringDestino, waypoints: waypointsArray, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
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
        if originMarker != nil && destinationMarker != nil {
            originMarker.map = nil
            destinationMarker.map = nil
            routePolyline.map = nil
            
            originMarker = nil
            destinationMarker = nil
            routePolyline = nil
        }
        
        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            
            markersArray.removeAll(keepCapacity: false)
        }
    }
    
    func configureMapAndMarkersForRoute() {
        
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
        labelInfo.text = mapRoute.totalDuration
        labelInfo2.text = mapRoute.totalDistance
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
    
    @IBAction func touchButtonAlert(sender: AnyObject) {
        util.showMessage(self, message: "Escolha a opção", actionList: actionAlert())
    }
    
    func actionAlert() -> [UIAlertAction] {
        var listAlerts = [UIAlertAction]()
        let SolicitarRotasAction = UIAlertAction(title: "Solicitar sugestões de rotas", style: .Default) { (action) in
            if UtilNetwork.isNetworkAvailable() {
                self.postRoutes()
            } else {
                JLToast.makeText("No memento você está sem internet. Tente novamente quando tiver conexão.").show()
            }
        }
        
        let liparRotasAction = UIAlertAction(title: "Limpar rotas", style: .Default) { (action) in
            self.util.showActivityIndicator()
            self.clearRoutes()
        }
        listAlerts.append(SolicitarRotasAction)
        listAlerts.append(liparRotasAction)
        return listAlerts
    }
    
    //MARK: - treating route
    func treatingRoute() {
        var conta = 1
        for route in routes.data {
            
            let positionStringOrigin = String(format: "%f", route.start_lat) + "," + String(format: "%f", route.start_lng)
            let positionStringDestino = String(format: "%f", route.end_lat) + "," + String(format: "%f", route.end_lng)
            
            if  conta <= 3 {
                waypointsArray.append(positionStringOrigin)
                waypointsArray.append(positionStringDestino)
                conta = conta + 1
            }
        }
        
        recreateRoute()
    }
}
