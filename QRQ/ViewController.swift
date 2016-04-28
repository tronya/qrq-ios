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

    

    @IBOutlet weak var Geo_label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        

        

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
                    
                    if let quest_points = json["quest_poi"] as? [[String: AnyObject]] {
                       
                        for q_poi in quest_points {
                            
                            if let name = q_poi["name"] as? String {
                                print(name)
                            }
                            if let poi = q_poi["location"] as? [[String: AnyObject]]{
                                print(poi)
                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            mapView.showsUserLocation = true
            
            let dod_1 = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 48.680757725957, longitude: 26.57858588604), radius: 20, identifier: "dod_1")
            locationManager.startMonitoringForRegion(dod_1)

            let dod_2 = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 48.68104239, longitude: 26.58391804), radius: 20, identifier: "dod_2")
            locationManager.startMonitoringForRegion(dod_2)
            
            let dod_3 = CLCircularRegion(center: CLLocationCoordinate2D(latitude:48.68109375, longitude: 26.58671021), radius: 20, identifier: "dod_3")
            locationManager.startMonitoringForRegion(dod_3)
        }
    }
    
    




    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Geo_label.text = "\(locValue.latitude) \(locValue.longitude)"

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
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Starting monitoring \(region.identifier)")
        Geo_label.text = "didStartMonitoringForRegion"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

