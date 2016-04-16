//
//  StatsViewController.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 15/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class StatsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var openMap: UIButton!
    
    
    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    
    var latitudes: [String] = []
    var longitudes: [String] = []
    var tipos: [String] = []
    
    var server: String = "http://wiu-siulpolb.rhcloud.com/api/alerta/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        self.map.showsUserLocation = true
        
        self.getAlertsData(server)
        

        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.map.setRegion(region, animated: true)
        
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getAlertsData(urlString: String){
        
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data!)
            })
        }
        task.resume()
        
        
    }//end get alerts

    
    func setLabels(alertsData: NSData){
        
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(alertsData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            var array1: [String] = []
            var array2 : [String] = []
            var array3: [String] = []
            for i in json{
                let lat = i["latitud"]!
                let lon = i["longitud"]!
                let tipo = i["tipo"]!
                //print("\(lat!)")
                //print("\(lon!)")
                //print("\(tipo!)")
                array1.append("\(lat!)")
                array2.append("\(lon!)")
                array3.append("\(tipo!)")
            }//for
            
            self.latitudes = array1
            self.longitudes = array2
            self.tipos = array3
            self.markers()
        
            
        }catch{
            print(error)
        }
    }//end set Labels
    
    
    func markers(){
        
        var index = 1
        while index < latitudes.count{
            
            let latitud = (latitudes[index] as NSString).doubleValue
            let longitud = (longitudes[index] as NSString).doubleValue
            let location = CLLocationCoordinate2D(latitude: (latitud), longitude: longitud)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Alerta"
            
            if(tipos[index]=="1"){
                annotation.subtitle = "Plug"
            }
            if(tipos[index]=="2"){
                annotation.subtitle = "Shake"
            }
            if(tipos[index]=="3"){
                annotation.subtitle = "Botón"
            }
            self.map.addAnnotation(annotation)
            index++
        }
    }
}


 