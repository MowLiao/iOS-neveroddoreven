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
    var circ = GMSCircle()
    
    @IBOutlet weak var hackButton: UIButton!

    override func loadView() {
        //let camera = GMSCameraPosition.camera(withLatitude: 53.805114, longitude: -1.555301, zoom: 18.7)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        //Set this to false to disable gestures
        mapView.settings.setAllGesturesEnabled(true)
        
        mapView.settings.myLocationButton = true
        
        view = mapView
        print("loadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        print(mapView.subviews)

        //WIP
        //let btn: UIButton = UIButton(type: UIButtonType.roundedRect)
        //hackButton.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        //hackButton.setTitle("MyButton", for: UIControlState.normal)
        
        
        //create points of interest 
        createPointOfInterest()
        
        //Set style of map
//        setStyle()
        
        //Location Manager code to fetch current location
//        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        print("didload")
    }
    
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location {
        
            let camera = GMSCameraPosition.camera(withLatitude:  location.coordinate.latitude , longitude: location.coordinate.longitude, zoom:18.7)
            mapView.animate(to: camera)
            

            
            if (isUserWithinMarkerArea(marker: location, circle: circ.position)){
                
            }
        }
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
        
    }
    

    func isUserWithinMarkerArea(marker: CLLocation, circle: CLLocationCoordinate2D) -> Bool {
        let pointOfInterest = CLLocation(latitude: circle.latitude, longitude: circle.longitude)
        var bool = false
        let distanceInMeters = marker.distance(from: pointOfInterest)
        
        if (distanceInMeters > circ.radius) {
            //Do what you need
             bool = false
            
        }
            else if (distanceInMeters < circ.radius) {
             bool = true
        }
        return bool
    }
    
    
    func createPointOfInterest() {
        //simulator city run demo - 37.331205, -122.030763
        let circleCenter = CLLocation(latitude: 37.331205, longitude: -122.030763)
        circ = GMSCircle(position: circleCenter.coordinate, radius: 10)
        
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = .red
        circ.strokeWidth = 1
        circ.map = mapView
        
    }
    
    func setStyle() -> Void {
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

