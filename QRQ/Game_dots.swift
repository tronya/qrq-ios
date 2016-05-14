//
//  Game_dots.swift
//  QRQ
//
//  Created by Yura Tronyak on 5/13/16.
//  Copyright © 2016 Yura Tronyak. All rights reserved.
//

import UIKit
import Foundation


class Game_dots {
    
    var point_id: Int?
    var point_name:String?
    var point_lat:Double?
    var point_lng:Double?
    
    init(point: NSDictionary) {
        
        self.point_id = point.hash
        self.point_name = point["point"]!["address"] as? String
        
        if let q_point_lat = Double((point["point"]!["lat"] as? String)!) {
            self.point_lat = q_point_lat
        }
        if let q_point_lon = Double((point["point"]!["lng"] as? String)!) {
            self.point_lng = q_point_lon
        }
    }
}