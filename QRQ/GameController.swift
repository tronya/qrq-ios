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
    @IBOutlet weak var action_button: UIButton!
    
    var detail_quest_id_indifer = Int()
    var game_quest_points:NSArray?
    
    
    var active_point:Int = 0
    let locationManager = CLLocationManager()
   
    var point_el:[Game_dots] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Debugger.text = "Start\n"
        
        
        if CLLocationManager.locationServicesEnabled() {
            

            
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            
            
            
            if(game_quest_points != nil){
               addOnMapDots(game_quest_points!)
            }
        }
        
 
    }
    
    func addOnMapDots(elemento: AnyObject){
        print(elemento.count)
        poi_count.text = String("Race have \(elemento.count) points")
        removeRegions()

        if let quest_points = elemento as? [[String: AnyObject]] {
            for q_poi in quest_points {
                self.point_el.append(Game_dots(point: q_poi as NSDictionary))
                }
            if(active_point == 0){
                addRegions(0);
            }
        }
    }
    @IBAction func buttonTapped(sender: AnyObject) {
        get_next_point()
    }
    func removeRegions(){
        var regions = locationManager.monitoredRegions
        regions.removeAll()
        for reg in regions{
            locationManager.stopMonitoringForRegion(reg)
        }
        print("regions.count",locationManager.monitoredRegions.count)
    }
    func get_next_point(){
        removeRegions()
        if(active_point < self.point_el.count){
            active_point = active_point + 1
            
            
            addRegions(active_point);
        }else{
            print("Stop edding dots")
            action_button.hidden = true
            
        }
    }

    
    func addRegions(add_point: Int){
        
        if(add_point < self.point_el.count){
            
            print("\(add_point)   county \(self.point_el.count)")
            poi_count.text = String("now \(add_point)/\(self.point_el.count)")
            
            let q_adress = self.point_el[add_point].point_name!
            let q_lat = self.point_el[add_point].point_lat!
            let q_lng = self.point_el[add_point].point_lng!
            self.mapView.addOverlay(MKCircle(centerCoordinate: CLLocationCoordinate2D(latitude: q_lat, longitude: q_lng), radius: 20))
            
            

            /// monitoring region
            let center_monitor_region = CLLocationCoordinate2D(latitude: q_lat, longitude:  q_lng)
            
            let region:CLCircularRegion = CLCircularRegion(center: center_monitor_region, radius: 20, identifier: q_adress)
            
            locationManager.startMonitoringForRegion(region)
        
            
        }else{
            print("all regions shown")
            poi_count.text = String("Race Finished")
            poi_count.textColor = UIColor.greenColor()
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        Geo_label.text = "\(locValue.latitude) \(locValue.longitude)"
        
        speed.text = String(format: "%.1f m/s", (manager.location?.speed)!)
        //altitude.text = String(format: "%.0f m", (manager.location?.altitude)!)
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.showsUserLocation = true
        mapView.delegate = self

        mapView.setRegion(region, animated: true)
        
     
        if(active_point < point_el.count){
            let q_lat = self.point_el[active_point].point_lat!
            let q_lng = self.point_el[active_point].point_lng!
        
            let cmr = CLLocation(latitude: q_lat, longitude: q_lng)
            let disti = locationManager.location?.distanceFromLocation(cmr)
            altitude.text = String(format: "%.0f m", (disti)!)
            
            
            let int_disti = Int(disti!)
            switch(int_disti){
            case(300...1000):
                altitude.textColor = UIColor.redColor()
                break;
            case(100...300):
                altitude.textColor = UIColor.grayColor()
                break;
            case(50...100):
                altitude.textColor = UIColor.blueColor()
                break;
            case(0...50):
                altitude.textColor = UIColor.greenColor()
                break;
            default:
                altitude.textColor = UIColor.blackColor()
                break;
            }
        }

    }
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        
        // show alert
        let alertController = UIAlertController(title: "In Region", message: "Your in \(region.identifier)", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        print("Entering region \(region.identifier)")
        
        // get next dot
        
        
        get_next_point()
        
        
        Debugger.text.appendContentsOf("Entering region \(region.identifier) \n")
        
        
        // delaem notificacii
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = "Entering region \(region.identifier)"
        notification.alertAction = "Go next"
        notification.soundName = UILocalNotificationDefaultSoundName
        //notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
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

