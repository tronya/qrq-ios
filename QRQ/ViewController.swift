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

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    

    @IBOutlet weak var Geo_label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var poi_count: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    
    
    
    let locationManager = CLLocationManager()
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        

        


        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
            self.mapView.delegate = self
            
            
            
            let requestURL: NSURL = NSURL(string: "http://yourday.esy.es/quest.json")!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        
                        
                        /*
                            if let post = json["post"] as? [[String: AnyObject]] {
                                print("post",post)
                            }
                        */
                        
                        
                        if let quest_points = json["quest_poi"] as? [[String: AnyObject]] {
                            
                            self.poi_count.text = String(quest_points.count)
                            for q_poi in quest_points {
                                
                                if let q_massive = q_poi as? Dictionary{
                                    
                                    let q_name = String(q_massive["name"])
                                    let q_lat = q_massive["location"]!["lat"] as! Double
                                    let q_lng = q_massive["location"]!["lng"] as! Double
                                    let q_id = q_massive["id"] as! Int
                                    
                                    print("\(q_lat)    \(q_lng)")
                                    //self.addOnMapDots(q_massive)

                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.mapView.addOverlay(MKCircle(centerCoordinate: CLLocationCoordinate2D(latitude: q_lat, longitude:  q_lng), radius: 20))
                                        
                                        
                                        let geoRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: q_lat, longitude:  q_lng), radius: 20, identifier: q_name)
                                        self.locationManager.startMonitoringForRegion(geoRegion)
                                    })
                                }
                            }
                            
                        }
                        
                    }catch {
                        print("Error with Json: \(error)")
                        
                    }
                    
                }
                
            }
            
            task.resume()


            /*
            let dod_2 = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 48.68307007 , longitude: 26.53616667), radius: 10, identifier: "vyizd na dorogy")
            locationManager.startMonitoringForRegion(dod_2)
            
            let dod_3 = CLCircularRegion(center: CLLocationCoordinate2D(latitude:48.6756638 , longitude: 26.55316651), radius: 10, identifier: "Olga")
            locationManager.startMonitoringForRegion(dod_3)
            */
        
        }
        
 
    }
    
    func addOnMapDots(elemento: AnyObject){
        print(elemento)


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
        
    }
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        let alertController = UIAlertController(title: "Exit Region", message: "Your exit \(region.identifier)", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        print("Exiting region \(region.identifier)")
        
    }
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Starting monitoring \(region.identifier)")
        Geo_label.text = "didStartMonitoringForRegion"
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

