//
//  ViewController.swift
//  NotYourBusiness
//
//  Created by Martin Tsenov [sc14mtt] on 09/03/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit
import GoogleMaps


class MapController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
   
    @IBOutlet var mapView: GMSMapView!
    
    // VARIABLE SET BY MINIGAME (increments if success)
    var currentFilter: Int = 1
    
    
    var locationManager = CLLocationManager()
    var camera = GMSCameraPosition()
    var marker = GMSMarker()
    var circ = GMSCircle()
    var hackButton = UIButton()
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withTarget: (locationManager.location?.coordinate)!, zoom: 18.7)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = false
        
        view = mapView
        print("loadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //Add hack button to subview
        addButton()
        
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
        
            mapView.animate(toLocation: location.coordinate)
            
            if (isUserWithinMarkerArea(marker: location, circle: circ.position)){
                showButton()
            } else {
                hideButton()
            }
        }
    }
    

    
    func addButton() {
        hackButton = UIButton(type: UIButtonType.roundedRect)
        
        hackButton.layer.cornerRadius = 10
        hackButton.clipsToBounds = true
        
        let bgColor = UIColor(red: 59.0/255.0, green: 138.0/255.0, blue: 212.0/255.0, alpha: 1.0)
//        let textColor = UIColor(red: 100.0/255.0, green: 44.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        
        hackButton.setTitleColor(UIColor.white, for: .normal)
        hackButton.backgroundColor = bgColor
        
        
        hackButton.setTitle("Hack!", for: UIControlState.normal)
        
        mapView.addSubview(hackButton)
        hackButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        hackButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hackButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hackButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        hackButton.addTarget(self, action: #selector(hackAction), for: .touchUpInside)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        let vc = segue.destination as! HackController
        vc.filterToSet = self.currentFilter
    }
    
    //Reference the battle screen with its controller. NOTE - add a Storyboard ID - "BattleController" "
    func hackAction(sender: UIButton!) {
        
        print("Starting Hack sequence")
        performSegue(withIdentifier: "HackSegue", sender: nil)
    }
    
    // Function to get back from hacking screen
    @IBAction func unwindFromHack(segue: UIStoryboardSegue)  { }
    
    func showButton(){
        hackButton.isHidden = false
    }
    
    func hideButton(){
        hackButton.isHidden = true
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
        circ = GMSCircle(position: circleCenter.coordinate, radius: 30)
        
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

