//
//  ViewController.swift
//  RotaMap
//
//  Created by Elton Melo on 4/1/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapRota: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var tdcLocation = CLLocationCoordinate2D()
    let origemRota = MKPointAnnotation()
    let destinoRota = MKPointAnnotation()
    
    @IBOutlet weak var search: UISearchBar!
    
    var autenticacao = TOAutenticacao()
    var routes = RouteSuggestions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        //        creates a map region around TDC coordinates
        tdcLocation  = CLLocationCoordinate2DMake(-3.781969,-38.573005)
        origemRota.coordinate = tdcLocation
        origemRota.title = "Minha casa"
        self.mapRota.region = MKCoordinateRegionMakeWithDistance(tdcLocation, 8000, 8000)
        self.mapRota.showsUserLocation = true
        self.mapRota.delegate = self
        
        //Setting Ibirapuera Park annotation
        destinoRota.coordinate = CLLocationCoordinate2DMake(-3.746402, -38.532683)
        destinoRota.title = "Praça da liberdade"
        
        
        self.mapRota.addAnnotations([destinoRota])
        
        
//        routeMap()
        
        mapRota.showAnnotations([origemRota ,destinoRota], animated: true)
        
        getAutenticacao()
        
    }
    
    func routeMap() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -3.781969, longitude: -38.573005), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -3.746402, longitude: -38.532683), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .Automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if error != nil {
                print("ERRO AO TRAÇAR A ROTA")
            } else {
                
                for route in unwrappedResponse.routes {
                    self.mapRota.addOverlay(route.polyline)
                    self.mapRota.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    
                    for step in route.steps {
                        print(step.instructions)
                    }
                }
            }
            
            self.mapRota.showAnnotations(self.mapRota.annotations, animated:true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.randomColor()
        renderer.lineWidth = 2
        
        return renderer
    }
    
    //MARK: Delegate pesquisa
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        pesquisaLocaisProximos(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        pesquisaLocaisProximos(searchBar)
    }
    
    func pesquisaLocaisProximos(searchBar: UISearchBar) {
        //sets a request with the text typed on the search bar and with current map region
        let request:MKLocalSearchRequest = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = self.mapRota.region
        
        //inits a local search with the request
        let pesquisar = MKLocalSearch(request: request)
        
        //sets an activity indicator
        let loading:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loading.center = self.view.center
        self.view.addSubview(loading)
        loading.startAnimating()
        
        pesquisar.startWithCompletionHandler{ [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            //            creates an array to keep the annotations created with the items returned
            var placemarks = [MKAnnotation]()
            for item in unwrappedResponse.mapItems {
                
                //creates a new point annotation per item returned
                let place:MKPointAnnotation = MKPointAnnotation()
                place.coordinate = (item as MKMapItem).placemark.coordinate
                place.title = (item as MKMapItem).name
                placemarks.append(place)
            }
            
            //clean and add the annotations in the placemarks array
            self.cleanAnnotations()
            placemarks.append(self.origemRota)
            placemarks.append(self.destinoRota)
            
            self.mapRota.addAnnotations(placemarks)
            loading.stopAnimating()
            
        }
    }
    
    func cleanAnnotations(){
        
        //clean all the map annotations except fo the user and TDC Logo
        let anToremove = NSMutableArray(array: self.mapRota.annotations)
        anToremove.removeObject(self.mapRota.userLocation)
        //        anToremove.removeObject(self.tdcAnnotation)
        
        self.mapRota.removeAnnotations(self.mapRota.annotations)
        
    }
    
    func getAutenticacao() {
        Rest.getAuthentication() {authentication, error in
            
//            self.util.hideActivityIndicator()
            
            if let _ = error {
                
//                self.util.showMessage(self, message: "\(error)")
                
            } else {
                
                self.autenticacao = authentication!
                
                let listT = self.autenticacao
                
                self.postRoutes()
            
            }
        }
    }
    
    func postRoutes() {
        Rest.postRoutes(autenticacao.data.user) {routeSuggestions, error in
            
            //            self.util.hideActivityIndicator()
            
            if let _ = error {
                
                //                self.util.showMessage(self, message: "\(error)")
                
            } else {
                
                 self.routes = routeSuggestions!
                
                let listT = self.routes
                
            }
        }
    }
    
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat.random()
        let g = CGFloat.random()
        let b = CGFloat.random()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

