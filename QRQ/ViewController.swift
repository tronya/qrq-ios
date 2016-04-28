//
//  ViewController.swift
//  QRQ
//
//  Created by Yura Tronyak on 4/27/16.
//  Copyright © 2016 Yura Tronyak. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

    

    
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    @IBOutlet weak var Geo_label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            let startLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50998, longitude: +26.5838873007047)
            let monitoredRegion = CLCircularRegion(center: startLocation, radius: 100, identifier: "Region Test")
            locationManager.startMonitoringForRegion(monitoredRegion)
            
            mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Geo_label.text = "\(locValue.latitude) \(locValue.longitude)"



        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let newCircle = MKCircle(centerCoordinate: center, radius: 200 as CLLocationDistance)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(newCircle)
    }
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Starting monitoring \(region.identifier)")
        Geo_label.text = "didStartMonitoringForRegion"
    }
    func locationManager(manager: CLLocationManager, didEnterRegion region:CLRegion) {
        print("boo")
        Geo_label.text = "didEnterRegion"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

