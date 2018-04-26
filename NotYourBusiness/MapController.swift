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
    var currentFilter: Int = 1 {
        didSet {
            loadMapStyle(level: currentFilter)
        }
    }
    
    static var level = Int()
    static var circleToDraw = ["\(level)","location1","location2"]
    var currentCircle = GMSCircle()
    var circleID = ""
    var firstLoad = true
    
    var previousFilter = Int()
    var locationManager = CLLocationManager()
    var camera = GMSCameraPosition()
    var marker = GMSMarker()
    var location1 = GMSCircle()
    var location2 = GMSCircle()
    var hackButton = UIButton()
    var finishButton = UIButton()
    
    
    override func loadView() {
        previousFilter = currentFilter
//        let camera = GMSCameraPosition.camera(withTarget: (locationManager.location?.coordinate)!, zoom: 18.7)
        
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
        
      
        loadLevelFromFile()
        
        loadMapStyle(level: currentFilter)
        
        //create points of interest 
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        print("didload")
        firstLoad = false
        
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location {
        
            mapView.animate(toLocation: location.coordinate)
            
            if (isUserWithinMarkerArea(locationName: location1, marker: location, circle: location1.position) ||
                isUserWithinMarkerArea(locationName: location2, marker: location, circle: location2.position))
            {
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
        
        let bgColor = UIColor.green
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
    
    func addFinishButton() {
        finishButton = UIButton(type: UIButtonType.roundedRect)
        
        finishButton.layer.cornerRadius = 10
        finishButton.clipsToBounds = true
        
        let bgColor = UIColor(red: 59.0/255.0, green: 138.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        //        let textColor = UIColor(red: 100.0/255.0, green: 44.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        
        finishButton.setTitleColor(UIColor.white, for: .normal)
        finishButton.backgroundColor = bgColor
        
        
        finishButton.setTitle("Finish!", for: UIControlState.normal)
        
        mapView.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        finishButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        finishButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        finishButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        finishButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        finishButton.addTarget(self, action: #selector(finalAction), for: .touchUpInside)
        
    }
    
    /// Load level data from file
    func loadLevelFromFile(){
        let file = "levelState.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let level = try String(contentsOf: fileURL, encoding: .utf8)
                
                let data = level.characters.split(separator: ",")
                print("DATA READ --------------- \(data.index(after: 1))")
                currentFilter = data.index(after: 1)
                if level.contains("location1") {
                    print("DRAWING LOCATION 1")
                    createPointOfInterest(circle: &location1, lat: 37.330606,long: -122.030021)
                }
                if level.contains("location2") {
                    print("DRAWING LOCATION 2")
                    createPointOfInterest(circle: &location2, lat: 37.331205,long: -122.030763)
                }
                
                print("LOADED LEVEL - \(currentFilter)")
            }
            catch {
                print("FILE NOT FOUND - RESETTING")
                currentFilter = 1
                
                createPointOfInterest(circle: &location1, lat: 37.330606,long: -122.030021)
                createPointOfInterest(circle: &location2, lat: 37.331205,long: -122.030763)
            }
        }
    }
    
    /// Load the map styles based on level
    ///
    /// - Parameter level: level value
    func loadMapStyle(level: Int) {
        MapController.level = level
        switch level {
        case 1:
            setStyle(jsonStyle: "startMap")
        case 2:
            setStyle(jsonStyle: "midMap")
            if (firstLoad == false){
                removePointOfInterest(circle: currentCircle, ID: circleID)
            }
        case 3:
            setStyle(jsonStyle: "endMap")
            if (firstLoad == false){
                removePointOfInterest(circle: currentCircle, ID: circleID)
            }
        default:
            print("def")
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "HackSegue"{
            let vc = segue.destination as! HackController
            vc.filterToSet = currentFilter
        }
    }
    
    
    // Segue to Hack screen
    func hackAction(sender: UIButton!) {
        
        print("Starting Hack sequence")
        performSegue(withIdentifier: "HackSegue", sender: nil)
    }
    
    // Segue to Final screen
    func finalAction(sender: UIButton!) {
        
        print("Finishing")
        performSegue(withIdentifier: "FinishSegue", sender: nil)
    }
    
    // Function to get back from hacking screen
    @IBAction func unwindFromHack(segue: UIStoryboardSegue)  {
        if currentFilter == 3 {
            addFinishButton()
        }
    }
    
    // Function to get back from hacking screen
    @IBAction func unwindFromFinish(segue: UIStoryboardSegue)  {
        if currentFilter == 3 {
            //addFinishButton()
        }
    }
    
    func showButton(){
        hackButton.isHidden = false
    }
    
    func hideButton(){
        hackButton.isHidden = true
    }
    
    /// Checks whether the user has entered one of the created circles
    ///
    /// - Parameters:
    ///   - locationName: circle name
    ///   - marker: current position of the user
    ///   - circle: circle coordinates
    /// - Returns: <#return value description#>
    func isUserWithinMarkerArea(locationName: GMSCircle, marker: CLLocation, circle: CLLocationCoordinate2D) -> Bool {
        currentCircle = locationName
        if (circle.latitude == 37.330606 && circle.longitude == -122.030021){
            circleID = "location1"
        } else {
            circleID = "location2"
        }
        
        let pointOfInterest = CLLocation(latitude: circle.latitude, longitude: circle.longitude)
        var bool = false
        let distanceInMeters = marker.distance(from: pointOfInterest)
        
        if (distanceInMeters > locationName.radius) {
             bool = false
        }
            else if (distanceInMeters < locationName.radius) {
             bool = true
        }
        return bool
    }
    
    
    /// Creates a circle at the given coordinates
    ///
    /// - Parameters:
    ///   - location: specifies the GMSCircle object
    ///   - lat: latitude
    ///   - long: longitude
    func createPointOfInterest(circle: inout GMSCircle, lat: Double, long: Double) {
        let circleCenter = CLLocation(latitude: lat, longitude: long)
        circle = GMSCircle(position: circleCenter.coordinate, radius: 30)
        
        circle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circle.strokeColor = .red
        circle.strokeWidth = 1
        circle.map = mapView
    }
    
    func removePointOfInterest(circle: GMSCircle, ID: String) {
        let indexOfArr = MapController.circleToDraw.index(of: ID)
//        print("INDEX IS -------- \(indexOfArr)")
        
        MapController.circleToDraw.remove(at: indexOfArr!)
        
        circle.radius = 0
        circle.strokeWidth = 0
        hideButton()
    }
    
    /// Sets style for the google maps map based on the current level
    ///
    /// - Parameter jsonStyle: name of the jSON style file.
    func setStyle(jsonStyle: String) -> Void {
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "\(jsonStyle)", withExtension: "json") {
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

