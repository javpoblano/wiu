//
//  ViewController.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 15/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation
import UIKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var map: MKMapView!
    var manager: CLLocationManager!
    
    @IBOutlet weak var buttonRoute: UIButton!
    
    @IBOutlet weak var buttonEmergency: UIButton!
    
    @IBOutlet weak var buttonFollow: UIButton!
    
    var myLocations: [CLLocation] = []
    
    var start: Bool = false
    
    var startEmergency: Bool = false
    
    var startFollow: Bool = false
    
    var plug: Bool = false
    
    var speedType: Int = 0
    
    var lat1: String = ""
    
    var lon1: String = ""
    
    var server:String = "http://wiu-siulpolb.rhcloud.com/"
    
    var street:String = ""
    
    let currentRoute = AVAudioSession.sharedInstance().currentRoute
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        
        map.delegate = self
        map.mapType = MKMapType.Standard
        map.showsUserLocation = true
        
        //self.plug()
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    plug = true
                    print("headphone plugged in")
                } else {
                    plug = false
                    print("headphone pulled out")
                }
            }
        } else {
            
            print("requires connection to device")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "audioRouteChangeListener:",
            name: AVAudioSessionRouteChangeNotification,
            object: nil)
        
        navigationItem.title = "Zona Neutra"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColorFromHex(0x6687F3)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        buttonRoute.setTitle("", forState: .Normal)
        var image = UIImage(named: "ruta_inactivo") as UIImage?
        buttonRoute.setImage(image, forState: .Normal)
        
        buttonEmergency.setTitle("", forState: .Normal)
        image = UIImage(named: "alerta_inactivo") as UIImage?
        buttonEmergency.setImage(image, forState: .Normal)
        
        buttonFollow.setTitle("", forState: .Normal)
        image = UIImage(named: "seguir_inactivo") as UIImage?
        buttonFollow.setImage(image, forState: .Normal)
        
        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 19.019647, longitude: -98.244867), radius: 10, identifier: "Job")
        self.manager?.startMonitoringForRegion(currRegion)
        
        
    }
    
    
    @IBAction func actionRoute(sender: AnyObject) {
        
        if start == false{
            let image = UIImage(named: "ruta_activo") as UIImage?
            buttonRoute.setImage(image, forState: .Normal)
            print("Datos de Inicio: \(lat1), \(lon1), \(street)")
            start = true
        }else{
            let image = UIImage(named: "ruta_inactivo") as UIImage?
            buttonRoute.setImage(image, forState: .Normal)
            print("Datos de Fin: \(lat1), \(lon1), \(street)")
            start = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lat = "\(locations[0].coordinate.latitude)"
        let lon = "\(locations[0].coordinate.longitude)"
        
        lat1 = lat
        lon1 = lon
        
        
        
        if(start==true){
        
            var speed: CLLocationSpeed = CLLocationSpeed()
            
            speed = manager.location!.speed
            
            
            if((speed * 3.6 ) >= 40.0)
            {
                speedType = 3
            }else if((speed * 3.6) < 40.0 && (speed * 3.6) >= 15.00){
                speedType = 2
            }else if((speed * 3.6) <= 15.00)
            {
                speedType = 1
            }
            
            myLocations.append(locations[0] as CLLocation)
            
            let spanX = 0.007
            let spanY = 0.007
            
            let newRegion = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            map.setRegion(newRegion, animated: true)
            
            if(myLocations.count > 1)
            {
                let sourceIndex = myLocations.count-1
                let destinationIndex = myLocations.count-2
                
                let c1 = myLocations[sourceIndex].coordinate
                let c2 = myLocations[destinationIndex].coordinate
                
                /*kmTotal = kmTotal + Double(myLocations[sourceIndex].distanceFromLocation(myLocations[destinationIndex]))
                kmtemp = kmTotal/1000
                kmLabel.text = String(format: "%.2f", kmtemp)*/
                
                var a = [c1,c2]
                
                let polyline = MKPolyline(coordinates: &a, count: a.count)
                map.addOverlay(polyline)
            }
            
            
            
        }else{
            print("Stop location")
            /*CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil)
                {
                    print("Error: " + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0
                {
                    let pm = placemarks![0]
                    self.displayLocationInfo(pm)
                }
                else
                {
                    print("Error with the data.")
                }
            })*/
        }
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
    {
        if (start == true){
            if overlay is MKPolyline {
                let polylineRenderer = MKPolylineRenderer(overlay: overlay)
                if(speedType == 1){
                    polylineRenderer.strokeColor = UIColor.greenColor()
                }else if(speedType == 2){
                    polylineRenderer.strokeColor = UIColor.orangeColor()
                }else if(speedType == 3){
                    polylineRenderer.strokeColor = UIColor.redColor()
                }
                
                polylineRenderer.lineWidth = 4
                return polylineRenderer
            }
            return nil
        }else{
            print("Stop on MapView")
            return nil
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func actionEmergency(sender: AnyObject) {
        
        
        if(startEmergency==false)
        {
            let image = UIImage(named: "alerta_activo") as UIImage?
            buttonEmergency.setImage(image, forState: .Normal)
            startEmergency = true
            self.postAlert(lat1, lon: lon1, tipo: 3)
            self.showAlert("Has activado una alerta", subtitulo: "Se notificará a tus contactos")
            
        }else{
            let image = UIImage(named: "alerta_inactivo") as UIImage?
            buttonEmergency.setImage(image, forState: .Normal)
            startEmergency = false
        }
        
    }
    
    
    
    @IBAction func actionFollow(sender: AnyObject) {
        
        if startFollow == false{
            let image = UIImage(named: "seguir_activo") as UIImage?
            buttonFollow.setImage(image, forState: .Normal)
            startFollow = true
            if(plug == false){
                let alertController = UIAlertController(title: "Conecta tus Audífonos", message:
                    "Para empezar a seguirte.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }else{
            let image = UIImage(named: "seguir_inactivo") as UIImage?
            buttonFollow.setImage(image, forState: .Normal)

            startFollow = false
        }
    }
    
    
    dynamic private func audioRouteChangeListener(notification:NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        if(startFollow == true)
        {
            switch audioRouteChangeReason {
            case AVAudioSessionRouteChangeReason.NewDeviceAvailable.rawValue:
                print("headphone plugged in")
                plug = true
            case AVAudioSessionRouteChangeReason.OldDeviceUnavailable.rawValue:
                print("headphone pulled out")
                self.postAlert(lat1, lon: lon1, tipo: 1)
                //self.showAlert("Plug desconectado", subtitulo: "Se enviará una alerta")
                plug = false
            default:
                break
            }
            
            
        }
        
    }
    

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(startFollow==true){
            if motion == .MotionShake{
                self.showAlert("Shake Detectado", subtitulo: "Se enviará una alerta")
                self.postAlert(lat1, lon: lon1, tipo: 2)
            }
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func showAlert(titulo: String, subtitulo: String)
    {
        let alertController = UIAlertController(title: titulo, message:
            subtitulo, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    
    func postAlert(lat: String, lon: String, tipo: Int){
        print("New Alert with the following data: \(lat), \(lon), \(tipo)")
        let request: Request = Request()
        
        let url: NSURL = NSURL(string: server+"api/alerta/")!
        
        let body: NSMutableDictionary = NSMutableDictionary()
        
        body.setValue(lat, forKey: "latitud")
        body.setValue(lon, forKey: "longitud")
        body.setValue(tipo, forKey: "tipo")
        
        request.post(url, body: body, completionHandler: { data, response, error in
            if (error != nil){
                print("Error:")
                print(error)
            }else
            {
                print("Success Post Alert")
            }
        })
    }//End postAlert
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        self.manager.stopUpdatingLocation()
        street = placemark.subLocality!+", "+placemark.postalCode!
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("Entering region")
        navigationItem.title = "Zona Segura"
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exit region")
        navigationItem.title = "Zona Insegura"
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("\(error)")
    }
    
    
    
}

