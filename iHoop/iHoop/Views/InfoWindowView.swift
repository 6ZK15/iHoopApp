//
//  InfoWindowView.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/21/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import Firebase
import FirebaseDatabase

class InfoWindowView: UIView {
    
    var infoWindowView = UIView()
    var directionsBtn = UIButton()
    var directionsLabel = UILabel()
    var distanceLabel = UILabel()
    var durationLabel = UILabel()
    var summaryLabel = UILabel()

    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    let userID = UserDefaults.standard.value(forKey: "currentUserUID")

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func createInfoWindowView(_ mapView: GMSMapView) {
        infoWindowView.frame = CGRect.init(x: 20,
                                           y: mapView.frame.size.height,
                                           width: mapView.frame.size.width - 40,
                                           height: 251)
        infoWindowView.backgroundColor = UIColor.black
        infoWindowView.alpha = 0.85
        infoWindowView.layer.cornerRadius = 16.0
        infoWindowView.layer.borderWidth = 4.0
        infoWindowView.layer.borderColor = orangeColor.cgColor
        infoWindowView.clipsToBounds = true
        
        mapView.addSubview(infoWindowView)
        addInfoLabels(infoWindowView)
        addDirectionsBtn(infoWindowView)
    }
    
    func showHideInfoWindoView() {
        if infoWindowView.transform == .identity {
            UIView.animate(withDuration: 1.0, animations: {
                self.infoWindowView.transform = CGAffineTransform.init(translationX: 0.0, y: -320)
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.infoWindowView.transform = .identity
            })
        }
    }
    
    func addDirectionsBtn(_ infoWindowView: UIView) {
        directionsBtn.frame = CGRect.init(x: infoWindowView.frame.size.width - 60,
                                          y: 20,
                                          width: 40,
                                          height: 44)
        directionsBtn.setImage(UIImage.init(named: "directionsBtn.png"), for: UIControlState.normal)
        directionsBtn.addTarget(self, action: #selector(getDirections(_:)), for: UIControlEvents.touchUpInside)
        
        directionsLabel.frame = CGRect.init(x: directionsBtn.frame.origin.x - 10,
                                            y: directionsBtn.frame.origin.y + 44,
                                            width: directionsBtn.frame.size.width + 20,
                                            height: 18)
        directionsLabel.text = "Directions"
        directionsLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 18)
        directionsLabel.textColor = UIColor.white
        directionsLabel.adjustsFontSizeToFitWidth = true
        infoWindowView.addSubview(directionsLabel)
        infoWindowView.addSubview(directionsBtn)
    }
    
    func addInfoLabels(_ infoWindowView: UIView) {
        
        self.databaseReference.child("users").child(userID as! String).child("directions/routes/0/legs/0/distance/text").observeSingleEvent(of: FIRDataEventType.value, with: {
            (snapshot) in
            self.distanceLabel.text = "Distance: \(snapshot.value as! String)"
        })
        
        self.databaseReference.child("users").child(userID as! String).child("directions/routes/0/legs/0/duration/text").observeSingleEvent(of: FIRDataEventType.value, with: {
            (snapshot) in
            self.durationLabel.text = "Duration: \(snapshot.value as! String)"
        })
        
        self.databaseReference.child("users").child(userID as! String).child("directions/routes/0/summary").observeSingleEvent(of: FIRDataEventType.value, with: {
            (snapshot) in
            self.summaryLabel.text = "Summary: \(snapshot.value as! String)"
        })
        
        distanceLabel.frame = CGRect.init(x: infoWindowView.frame.origin.x + 20,
                                          y: 20,
                                          width: infoWindowView.frame.size.width - 40,
                                          height: 40)
        distanceLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        distanceLabel.textColor = orangeColor
        distanceLabel.adjustsFontSizeToFitWidth = true
        
        durationLabel.frame = CGRect.init(x: infoWindowView.frame.origin.x + 20,
                                          y: distanceLabel.frame.origin.y + 36,
                                          width: infoWindowView.frame.size.width - 40,
                                          height: 40)
        durationLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        durationLabel.textColor = orangeColor
        durationLabel.adjustsFontSizeToFitWidth = true
        
        summaryLabel.frame = CGRect.init(x: infoWindowView.frame.origin.x + 20,
                                         y: durationLabel.frame.origin.y + 36,
                                         width: infoWindowView.frame.size.width - 40,
                                         height: 40)
        summaryLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        summaryLabel.textColor = orangeColor
        summaryLabel.adjustsFontSizeToFitWidth = true
        
        infoWindowView.addSubview(distanceLabel)
        infoWindowView.addSubview(durationLabel)
        infoWindowView.addSubview(summaryLabel)
        
    }
    
    @IBAction func getDirections(_ sender:UIButton!) {
        print("Get Directions")
        showHideInfoWindoView()
        
        let markerLat = UserDefaults.standard.object(forKey: "markerLat")
        let markerLng = UserDefaults.standard.object(forKey: "markerLng")
        var markerTitle = String()
        markerTitle = UserDefaults.standard.object(forKey: "markerTitle") as! String
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(markerLat as! CLLocationDegrees, markerLng as! CLLocationDegrees)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = markerTitle
        mapItem.openInMaps(launchOptions: options)
    }

}
