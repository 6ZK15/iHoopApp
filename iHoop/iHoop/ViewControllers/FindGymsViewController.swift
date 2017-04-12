//
//  FindGymsViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/29/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class FindGymsViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentlongitude = UserDefaults.standard.double(forKey: "currentlongitude")
        let currentlatitude = UserDefaults.standard.double(forKey: "currentlatitude")
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate current location at zoom level 12.
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(currentlatitude), longitude: CLLocationDegrees(currentlongitude), zoom: 12.0)
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
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Me"
//        marker.map = mapView
        
        menuBtn.bringSubview(toFront: mapView)

        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
