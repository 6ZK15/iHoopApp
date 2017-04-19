//
//  FindGymsViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/29/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import Firebase
import FirebaseDatabase

class FindGymsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var menuBtn: UIButton!
    var locationManager: CLLocationManager!
    var geocoder = CLGeocoder()
    var findGymOperations = FindGymsOperations()
    var gyms = [Gyms]()
    var names: [String] = []
    var addresses: [String] = []
    var latitudes: [CLLocationDegrees] = []
    var longitudes: [CLLocationDegrees] = []
    
    let databaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gymURLRequest()
        displayGoogleMapView()
        
        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        gymURLRequest()
        viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func displayGoogleMapView() {
        let currentlongitude = UserDefaults.standard.double(forKey: "currentlongitude")
        let currentlatitude = UserDefaults.standard.double(forKey: "currentlatitude")
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate current location at zoom level 10.
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(currentlatitude), longitude: CLLocationDegrees(currentlongitude), zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0,
                                                            y: 72,
                                                            width: view.frame.size.width,
                                                            height: view.frame.size.height - 72),
                                     camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
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
        view.addSubview(mapView)
        
        setMarkers(mapView)
        
    }
    
    func setMarkers(_ mapView: GMSMapView ) {
        let latitudes = UserDefaults.standard.value(forKey: "latitudes") as! Array<Any>
        let longitudes = UserDefaults.standard.value(forKey: "longitudes") as! Array<Any>
        let gymNames = UserDefaults.standard.value(forKey: "gymNames") as! Array<Any>
        let addresses = UserDefaults.standard.value(forKey: "addresses") as! Array<Any>
        
        var markers = [GMSMarker]()
        for i in 0...latitudes.count-1 {
            print("gym names: ", self.names)
            markers.append(GMSMarker.init())
            markers[i].position = CLLocationCoordinate2DMake(latitudes[i] as! CLLocationDegrees, longitudes[i] as! CLLocationDegrees)
            markers[i].title = gymNames[i] as? String
            markers[i].snippet = addresses[i] as? String
            markers[i].map = mapView
        }
    }
    
    func gymURLRequest() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let currentlongitude = UserDefaults.standard.string(forKey: "currentlongitude")!
        let currentlatitude = UserDefaults.standard.string(forKey: "currentlatitude")!
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + currentlatitude + "," + currentlongitude +  "&radius=66000&type=gym&keyword=basketball+recreation+centers&key=AIzaSyC4cyENm7AyJFVyV6GZwgrFbg4d1epEOoo")
        print(url as Any)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String, AnyObject>
            print("Gym Response Dictionary: ", json!)
            
            self.databaseReference.child("users").child(userID as! String).child("nearby").setValue(json)
            
            self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").observe(FIRDataEventType.value, with: {
                (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if let gymDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let gym = Gyms.init(key: key, dictionary: gymDictionary)
                            self.gyms.insert(gym, at: 0)
                            
                            self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").child(key).child("name").observeSingleEvent(of: FIRDataEventType.value, with: {
                                (snapshot) in
                                if let name = snapshot.value {
                                    self.names.append(name as! String)
                                }
                                UserDefaults.standard.set(self.names, forKey: "gymNames")
                            })
                            
                            self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").child(key).child("vicinity").observeSingleEvent(of: FIRDataEventType.value, with: {
                                (snapshot) in
                                if let address = snapshot.value {
                                    self.addresses.append(address as! String)
                                }
                                UserDefaults.standard.set(self.addresses, forKey: "addresses")
                            })
                            
                            let locationRef = self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").child(key).child("geometry").child("location")
                            
                            locationRef.child("lat").observeSingleEvent(of: FIRDataEventType.value, with: {
                                (snapshot) in
                                if let latitude = snapshot.value {
                                    self.latitudes.append(latitude as! CLLocationDegrees)
                                }
                                UserDefaults.standard.set(self.latitudes, forKey: "latitudes")
                            })
                            
                            locationRef.child("lng").observeSingleEvent(of: FIRDataEventType.value, with: {
                                (snapshot) in
                                if let longitude = snapshot.value {
                                    self.longitudes.append(longitude as! CLLocationDegrees)
                                }
                                UserDefaults.standard.set(self.longitudes, forKey: "longitudes")
                            })
                        }
                    }
                }
                print("gymList: ", self.gyms)
                print("gymNames: ", self.names)
            })
            
        }
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateToLocation", locations)
        let currentlongitude = locationManager.location?.coordinate.longitude
        let currentlatitude = locationManager.location?.coordinate.latitude
        
        UserDefaults.standard.set(currentlongitude, forKey: "currentlongitude")
        UserDefaults.standard.set(currentlatitude, forKey: "currentlatitude")
    }

}
