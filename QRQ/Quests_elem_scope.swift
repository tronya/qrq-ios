//
//  Quests_elem_scope.swift
//  QRQ
//
//  Created by Yura Tronyak on 5/5/16.
//  Copyright © 2016 Yura Tronyak. All rights reserved.
//

import UIKit
import Foundation


class Quests_elem_scope {
    
    var quest_id: Int?
    var quest_type:String?
    var quest_title:String?
    var quest_points:NSArray?
    var quest_description:String?
    var quest_photo:String?
    
    init(json: NSDictionary) {
        
        self.quest_id = json["id"] as? Int
        self.quest_type = json["type"] as? String
        self.quest_title = json["title"]!["rendered"] as? String
        self.quest_points = json["acf"]!["points_coords"] as? NSArray
        self.quest_description = json["acf"]!["description_quest"] as? String
        self.quest_photo = json["acf"]!["quest_photo"] as? String
        
        
    }
}