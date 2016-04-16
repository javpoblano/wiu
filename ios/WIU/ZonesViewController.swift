//
//  ZonesViewController.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 15/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit

class ZonesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    var tableData: [String] = []
    var radio: [String] = []
    
    var server: String = "http://wiu-siulpolb.rhcloud.com/api/zona/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Zonas")
        
        var nib = UINib(nibName: "zoneTbCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        
        self.getZoneData(server)
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:ZoneTbCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! ZoneTbCell
        
        cell.name.text = tableData[indexPath.row]
        cell.radio.text = radio[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row) selected")
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getZoneData(urlString: String){
        
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data, response, error) in
        dispatch_async(dispatch_get_main_queue(), {
        self.setLabels(data!)
        })
        }
        task.resume()
        
        
    }//end get zones


    func setLabels(alertsData: NSData){
        
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(alertsData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            var array1: [String] = []
            var array2: [String] = []
            for i in json{
                print(i["nombre"]!)
                let lat = i["nombre"]!
                let lt = i["radio"]!
                array1.append("\(lat!)")
                array2.append("\(lt!) m")
            }//for
            
            self.tableData = array1
            self.radio = array2
            reload()
            
        }catch{
            print(error)
        }
    }//end set Labels
    
    func reload(){
        self.tableView.reloadData()
    }

}
