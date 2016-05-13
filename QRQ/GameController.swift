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

class GameController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    

    @IBOutlet weak var Geo_label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var poi_count: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var Debugger: UITextView!
    
    var detail_quest_id_indifer = Int()
    var game_quest_points:NSArray?
    
    
    
    let locationManager = CLLocationManager()
   
    
    var game_quest:[Quests_elem_scope] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Debugger.text = "Start\n"
        
        if CLLocationManager.locationServicesEnabled() {
            

            
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            
            mapView.showsUserLocation = true
            
            mapView.delegate = self
            
            
            if(game_quest_points != nil){
                addOnMapDots(game_quest_points!)
            }
        }
        
 
    }
    
    func addOnMapDots(elemento: AnyObject){
        print(elemento.count)
        
        if let quest_points = elemento as? [[String: AnyObject]] {
            for q_poi in quest_points {
                
                var q_lat:Double = 0
                var q_lng:Double = 0
                let q_adress = q_poi["point"]!["address"] as? String
                
                if let q_point_lat = Double((q_poi["point"]!["lat"] as? String)!) {
                    print(q_point_lat)
                    q_lat = q_point_lat
                }else{
                    print("error")
                }
                if let q_point_lon = Double((q_poi["point"]!["lng"] as? String)!){
                    print(q_point_lon)
                    q_lng = q_point_lon
                }else{
                    print("error")
                }
                self.mapView.addOverlay(MKCircle(centerCoordinate: CLLocationCoordinate2D(latitude: q_lat, longitude: q_lng), radius: 20))
                
                
                let geoRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: q_lat, longitude:  q_lng), radius: 20, identifier: q_adress!)
               
                locationManager.startMonitoringForRegion(geoRegion)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        Geo_label.text = "\(locValue.latitude) \(locValue.longitude)"
        
        speed.text = String(format: "%.1f m/s", (manager.location?.speed)!)
        altitude.text = String(format: "%.0f m", (manager.location?.altitude)!)
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        
        mapView.setRegion(region, animated: true)

    }
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let alertController = UIAlertController(title: "In Region", message: "Your in \(region.identifier)", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        print("Entering region \(region.identifier)")

        Debugger.text.appendContentsOf("Entering region \(region.identifier) \n")
    }
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        let alertController = UIAlertController(title: "Exit Region", message: "Your exit \(region.identifier)", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        print("Exiting region \(region.identifier)")
        
        Debugger.text.appendContentsOf("Exiting region \(region.identifier) \n")
        
    }
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Starting monitoring \(region.identifier)")
        Debugger.text.appendContentsOf("Starting monitoring \(region.identifier) \n")
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        myCircleView.fillColor = UIColor.blueColor()
        myCircleView.alpha = 0.5
        myCircleView.lineWidth = 1
        
        return myCircleView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

