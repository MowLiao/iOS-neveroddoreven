//
//  ViewController.swift
//  NotYourBusiness
//
//  Created by Martin Tsenov [sc14mtt] on 09/03/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var camera = GMSCameraPosition()
    var marker = GMSMarker()
    

    override func loadView() {
        //let camera = GMSCameraPosition.camera(withLatitude: 53.805114, longitude: -1.555301, zoom: 18.7)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.setAllGesturesEnabled(true)
        
        view = mapView
        print("loadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        print("didload")
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:18.7)
        mapView.animate(to: camera)
//        print(isMarkerWithinScreen(marker: location!))
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // WIP
    func isMarkerWithinScreen(marker: CLLocation) -> Bool {
        let region = self.mapView.projection.point(for: marker.coordinate)
//        let bounds = GMSCoordinateBounds(region: region)
        print(region)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    @IBAction func changeMapType(sender: AnyObject) {
//        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.default) { (alertAction) -> Void in
//            self.mapView.mapType = GMSMapViewType.normal
//        }
//        
//        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.default) { (alertAction) -> Void in
//            self.mapView.mapType = GMSMapViewType.terrain
//        }
//        
//        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.default) { (alertAction) -> Void in
//            self.mapView.mapType = GMSMapViewType.hybrid
//        }
//        
//        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
//            
//        }
//        
//        actionSheet.addAction(normalMapTypeAction)
//        actionSheet.addAction(terrainMapTypeAction)
//        actionSheet.addAction(hybridMapTypeAction)
//        actionSheet.addAction(cancelAction)
//        
//        present(actionSheet, animated: true, completion: nil)
//    }
}

