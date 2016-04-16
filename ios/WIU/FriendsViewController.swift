//
//  FriendsViewController.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 16/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableData: [String] = ["lconder","siulpolb","spacem3n","jcastrejona","jpoblano"]
    var cel: [String] = ["2221026541","2221773973","2226116731","2226065152","2223522409"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "usrTbCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell: UsrTbCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! UsrTbCell
        
        cell.number = cel[indexPath.row]
        cell.name?.text = self.tableData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            print("Row \(indexPath.row) selected")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    


}
