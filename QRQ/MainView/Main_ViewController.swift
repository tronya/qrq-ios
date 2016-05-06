//
//  Main_ViewController.swift
//  QRQ
//
//  Created by Yura Tronyak on 5/5/16.
//  Copyright © 2016 Yura Tronyak. All rights reserved.
//

import UIKit

class Main_ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var quest_el_posts:[Quests_elem_scope] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let requestURL: NSURL = NSURL(string: "http://yourday.esy.es/wp-json/wp/v2/posts?categories=4")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    
                    if let quest_points = json as? [[String: AnyObject]] {
                        print("count",quest_points.count)
                        for quest in quest_points {
                            self.quest_el_posts.append(Quests_elem_scope(json: quest))
                        }
                        self.do_table_refresh()
                    }
                }catch {
                        print("Error with Json: \(error)")
                        
                    }
                    
                }
                
            }
            
            task.resume()
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quest_el_posts.count
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
         forRowAtIndexPath indexPath: NSIndexPath) {
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! QuestTableViewCell
        cell.short_quest_title?.text = quest_el_posts[indexPath.row].quest_title
        cell.short_quest_description?.text = quest_el_posts[indexPath.row].quest_description

        
        cell.short_quest_image?.setImageWithUrl(NSURL(string: (self.quest_el_posts[indexPath.row].quest_photo)!)!,placeHolderImage: UIImage(named:"placeholder"))
        cell.short_quest_bg_image?.setImageWithUrl(NSURL(string: (self.quest_el_posts[indexPath.row].quest_photo)!)!,placeHolderImage: UIImage(named:"placeholder"))
        return cell
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            
            return
        })
    }
}
