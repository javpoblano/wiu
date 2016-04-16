//
//  MenuViewController.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 15/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableData: [String] = ["Zonas", "Recorridos", "Compañeros", "Configuración", "Stats"]
    var imgData: [String] = ["location", "road", "social", "gear", "arrow"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TbCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColorFromHex(0x6687F3)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        
        
        
        let cell: TbCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! TbCell
        
        cell.title.text = tableData[indexPath.row]
        cell.img.image = UIImage(named: imgData[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row == 0
        {
            print("Segue1")
            self.performSegueWithIdentifier("segue1", sender: self)
        }else if indexPath.row == 1{
            print("Segue2")
            self.performSegueWithIdentifier("segue2", sender: self)
        }else if indexPath.row == 2{
            print("Segue3")
            self.performSegueWithIdentifier("segue3", sender: self)
        }else if indexPath.row == 3{
            print("segue 4")
            self.performSegueWithIdentifier("segue4", sender: self)
        }else if indexPath.row == 4{
            print("segue 5")
            self.performSegueWithIdentifier("segue5", sender: self)
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    

}
