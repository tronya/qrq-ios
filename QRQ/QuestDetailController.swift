//
//  QuestDetailController.swift
//  QRQ
//
//  Created by Yura Tronyak on 5/6/16.
//  Copyright © 2016 Yura Tronyak. All rights reserved.
//

import UIKit

class QuestDetailController: UIViewController {
    
    var detail_quest_id = Int()
    var quest_detail:[Quests_elem_scope] = []
    
    @IBOutlet weak var detail_image_view: UIImageView!
    @IBOutlet weak var detail_title_of_quest: UILabel!
    @IBOutlet weak var detail_description_of_quest: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(detail_quest_id)
        
        

        
        let requestURL: NSURL = NSURL(string: "http://yourday.esy.es/wp-json/wp/v2/posts/\(detail_quest_id)")!
        print(requestURL)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    self.quest_detail.append(Quests_elem_scope(json: json as! NSDictionary))
                    self.get_info()
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
        

    
    }
    
    
    @IBAction func buttonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("gameSegue", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "gameSegue" {
            let Destination = (segue.destinationViewController as! GameController)
            Destination.detail_quest_id_indifer = self.quest_detail[0].quest_id!
            Destination.game_quest_points = self.quest_detail[0].quest_points!
        }
    }
    func get_info(){
        dispatch_async(dispatch_get_main_queue(), {
            self.detail_title_of_quest?.text = self.quest_detail[0].quest_title
            self.detail_description_of_quest?.text = self.quest_detail[0].quest_description
            self.detail_image_view?.setImageWithUrl(NSURL(string: (self.quest_detail[0].quest_photo)!)!,placeHolderImage: UIImage(named:"placeholder"))
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
