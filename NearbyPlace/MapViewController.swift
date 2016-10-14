//
//  MapViewController.swift
//  NearbyPlace
//
//  Created by Thabu on 10/4/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import AddressBookUI
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate ,CLLocationManagerDelegate{
    
    var urlString:NSMutableString!
    var Locr:CLLocationCoordinate2D!
    
    var latstr:NSNumber!
    var longstr:NSNumber!
    var titlename:NSString!
    var subtitlestr:NSString!
    
    var latarray:NSArray!
    var longarray:NSArray!
    var namearray:NSArray!
    var imagearray:NSArray!
    var addressarray:NSArray!
    var coord2: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var lat:String! = ""
    var long:String! = ""
    var Locationmanager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
     var locValue:CLLocationCoordinate2D!
    
    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var mapviews: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlelab.text = titlename as String
        self.mapviews.delegate = self
        self.mapviews.showsUserLocation = true
        self.mapviews.mapType = MKMapType(rawValue: 0)!
        self.mapviews.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        if(authorizationStatus == .AuthorizedWhenInUse || authorizationStatus == .AuthorizedAlways) {
            Locationmanager.startUpdatingLocation()
        }
        else
        {
            Locationmanager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            Locationmanager.delegate = self
            Locationmanager.desiredAccuracy = kCLLocationAccuracyBest
             Locationmanager.requestAlwaysAuthorization()
            Locationmanager.requestWhenInUseAuthorization()
        }
        Locationmanager.startUpdatingHeading()
        self.makeAnnotation()
        }
    func makeAnnotation()
    {
        self.coord2.latitude = CLLocationDegrees(latstr.doubleValue)
        self.coord2.longitude = CLLocationDegrees(longstr.doubleValue)
        let Location = CLLocationCoordinate2DMake(self.coord2.latitude, self.coord2.longitude)
        let region = MKCoordinateRegionMakeWithDistance(Location, 800, 800)
        let Point:MKPointAnnotation = MKPointAnnotation()
        self.mapviews.setRegion(self.mapviews.regionThatFits(region), animated: true)
        Point.coordinate = Location
        Point.title = String(format: "%@",titlename)
        Point.subtitle = String(format: "%@",subtitlestr)
        self.mapviews.addAnnotation(Point)
    }
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        locValue = manager.location!.coordinate
//        let region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.mapviews.setRegion(region, animated: true)
       Locr = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
    }
    
    
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let source = "\(locValue.latitude),\(locValue.longitude)"
            let dest = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
            urlString = NSMutableString.init()
            urlString.setString("http://maps.google.com/maps?f=d&hl=en")
            urlString.appendString("&saddr=")
            urlString.appendString("\(source)")
            urlString.appendString("&daddr=")
            urlString.appendString("\(dest)")
            urlString.appendString("&ie=UTF8&0&om=0&output=kml")
            UIApplication.sharedApplication().openURL(NSURL(string: urlString as String)!)
            
            
//            let request = MKDirectionsRequest()
//            request.source = MKMapItem.mapItemForCurrentLocation()
//            request.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude), addressDictionary: nil))
//            request.transportType = MKDirectionsTransportType.Any
//            request.requestsAlternateRoutes = false
//            let directions = MKDirections(request: request)
//            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
//                guard let unwrappedResponse = response else { return }
//                
//                if (unwrappedResponse.routes.count > 0) {
//                    self.showrout(response!)
//                }
////            directions.calculateDirectionsWithCompletionHandler{
////                response, error in
////                if error == nil {
////                    self.showrout(response!)
////                }else{
////                    print(error)
////                }
////            }
//            }
        }
    }
    func showrout(response:MKDirectionsResponse){
        for route in response.routes {
            mapviews.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
        let userLocation = mapviews.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        mapviews.setRegion(region, animated: true)
    }
    
            
            
//            let newLocation = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
//            print("Your annotation title: \(annotation.coordinate.latitude),\(annotation.coordinate.longitude)");
//            
//            let oldCoordinates = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
//                let newCoordinates = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
//                var area = [oldCoordinates, newCoordinates]
//                let polyline = MKPolyline(coordinates: &area, count: area.count)
//                mapviews.addOverlay(polyline)
//        }
//    }
    
//    let renderer = MKPolylineRenderer(overlay: overlay)
//    
//    renderer.strokeColor = UIColor.blueColor()
//    renderer.lineWidth = 5.0
//    return renderer
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer.init(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        return renderer
        
//        guard let polyline = overlay as? MKPolyline else {
//            return MKOverlayRenderer()
//        }
//        
//        let renderer = MKPolylineRenderer(polyline: polyline)
//        renderer.lineWidth = 3.0
//        renderer.alpha = 0.5
//        renderer.strokeColor = UIColor.blueColor()
//        
//        return renderer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func addAnnotationsOnMap(locationToPoint : CLLocation){
//        
//        var annotation = MKPointAnnotation()
//        annotation.coordinate = locationToPoint.coordinate
//        var geoCoder = CLGeocoder ()
//        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
//            if let placemarks = placemarks as? [CLPlacemark] where placemarks.count > 0 {
//                var placemark = placemarks[0]
//                var addressDictionary = placemark.addressDictionary;
//                annotation.title = addressDictionary["Name"] as? String
//                self.mapviews.addAnnotation(annotation)
//            }
//        })
//    }
    
    @IBAction func Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
