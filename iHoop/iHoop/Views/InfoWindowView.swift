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
    var addGroupBtn = UIButton()
    var addGroupLabel = UILabel()
    var callBtn = UIButton()
    var webBtn = UIButton()
    var starOne = UIImageView()
    var starTwo = UIImageView()
    var starThree = UIImageView()
    var starFour = UIImageView()
    var starFive = UIImageView()

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
        addActionButtons(infoWindowView)
        addDirectionsBtn(infoWindowView)
        addGroupButton(infoWindowView)
        addRatings(infoWindowView)
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
    
    func addDirectionsBtn(_ infoWindow: UIView) {
        directionsBtn.frame = CGRect.init(x: infoWindow.frame.size.width - 60,
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
        infoWindow.addSubview(directionsLabel)
        infoWindow.addSubview(directionsBtn)
    }
    
    func addInfoLabels(_ infoWindow: UIView) {
        
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
        
        distanceLabel.frame = CGRect.init(x: infoWindow.frame.origin.x + 8,
                                          y: 20,
                                          width: infoWindow.frame.size.width - 40,
                                          height: 40)
        distanceLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        distanceLabel.textColor = orangeColor
        distanceLabel.adjustsFontSizeToFitWidth = true
        
        durationLabel.frame = CGRect.init(x: infoWindow.frame.origin.x + 8,
                                          y: distanceLabel.frame.origin.y + 36,
                                          width: infoWindow.frame.size.width - 40,
                                          height: 40)
        durationLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        durationLabel.textColor = orangeColor
        durationLabel.adjustsFontSizeToFitWidth = true
        
        summaryLabel.frame = CGRect.init(x: infoWindow.frame.origin.x + 8,
                                         y: durationLabel.frame.origin.y + 36,
                                         width: infoWindow.frame.size.width - 40,
                                         height: 40)
        summaryLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        summaryLabel.textColor = orangeColor
        summaryLabel.adjustsFontSizeToFitWidth = true
        
        infoWindow.addSubview(distanceLabel)
        infoWindow.addSubview(durationLabel)
        infoWindow.addSubview(summaryLabel)
        
    }
    
    func addGroupButton(_ infoWindow: UIView) {
        addGroupBtn.frame = CGRect.init(x: infoWindow.frame.origin.x + 8,
                                           y: infoWindow.frame.size.height - 56,
                                           width: 30,
                                           height: 30)
        addGroupBtn.setImage(UIImage.init(named: "addGymBtn.png"), for: UIControlState.normal)
        addGroupBtn.addTarget(self, action: #selector(addPublicGymGroup(_ :)), for: UIControlEvents.touchUpInside)
        
        addGroupLabel.frame = CGRect.init(x: addGroupBtn.frame.origin.x + 38,
                                          y: addGroupBtn.frame.origin.y,
                                          width: infoWindow.frame.size.width - 58,
                                          height: 30)
        addGroupLabel.font = UIFont(name: "Bodoni 72 Smallcaps", size: 20)
        addGroupLabel.textColor = orangeColor
        addGroupLabel.adjustsFontSizeToFitWidth = true
        addGroupLabel.text = "Add Gym's Public Group"
        
        infoWindow.addSubview(addGroupLabel)
        infoWindow.addSubview(addGroupBtn)
    }
    
    func addActionButtons(_ infoWindow: UIView) {
        callBtn.frame = CGRect.init(x: infoWindow.frame.origin.x + 8,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        callBtn.setImage(UIImage.init(named: "callBtn.png"), for: UIControlState.normal)
        callBtn.addTarget(self, action: #selector(dialGymNumber(_:)), for: UIControlEvents.touchUpInside)
        
        webBtn.frame = CGRect.init(x: callBtn.frame.origin.x + 50,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        let website = UserDefaults.standard.url(forKey: "website")
        if website == nil {
            webBtn.setImage(UIImage.init(named: "websiteBtnB.png"), for: UIControlState.disabled)
//            webBtn.isEnabled = false
        } else {
            webBtn.setImage(UIImage.init(named: "websiteBtn.png"), for: UIControlState.normal)
//            webBtn.isEnabled = true
        }
        webBtn.addTarget(self, action: #selector(clickWebsite(_:)), for: UIControlEvents.touchUpInside)
        
        infoWindow.addSubview(callBtn)
        infoWindow.addSubview(webBtn)
    }
    
    func addRatings(_ infoWindow: UIView) {
        starOne.frame = CGRect.init(x: webBtn.frame.origin.x + 50,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        starOne.image = UIImage.init(named: "star.png")
        
        starTwo.frame = CGRect.init(x: starOne.frame.origin.x + 38,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        starTwo.image = UIImage.init(named: "star.png")
        
        starThree.frame = CGRect.init(x: starTwo.frame.origin.x + 38,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        starThree.image = UIImage.init(named: "star.png")
        
        starFour.frame = CGRect.init(x: starThree.frame.origin.x + 38,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        starFour.image = UIImage.init(named: "star.png")
        
        starFive.frame = CGRect.init(x: starFour.frame.origin.x + 38,
                                    y: summaryLabel.frame.origin.y + 50,
                                    width: 30,
                                    height: 30)
        starFive.image = UIImage.init(named: "star.png")
        
        let ratings = UserDefaults.standard.float(forKey: "starRatings")
        if ratings < 5 {
            starFive.image = starFive.image!.withRenderingMode(.alwaysTemplate)
            starFive.tintColor = UIColor.lightGray
        } else if ratings < 4 {
            starFive.image = starFive.image!.withRenderingMode(.alwaysTemplate)
            starFive.tintColor = UIColor.lightGray
            
            starFour.image = starFour.image!.withRenderingMode(.alwaysTemplate)
            starFour.tintColor = UIColor.lightGray
        }
        
        infoWindow.addSubview(starOne)
        infoWindow.addSubview(starTwo)
        infoWindow.addSubview(starThree)
        infoWindow.addSubview(starFour)
        infoWindow.addSubview(starFive)
    }
    
    @IBAction func getDirections(_ sender:UIButton!) {
        print("Get Directions")
        showHideInfoWindoView()
        
        guard let markerLat = UserDefaults.standard.object(forKey: "markerLat") else { return }
        guard let markerLng = UserDefaults.standard.object(forKey: "markerLng") else { return }
        guard let markerTitle = UserDefaults.standard.object(forKey: "markerTitle") else { return }
        guard let markerPhoneNumber = UserDefaults.standard.object(forKey: "phoneNumber") else { return }
        guard let markerWebsite = UserDefaults.standard.object(forKey: "website") else { return }
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(markerLat as! CLLocationDegrees, markerLng as! CLLocationDegrees)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = markerTitle as? String
        mapItem.phoneNumber = markerPhoneNumber as? String
        mapItem.url = markerWebsite as? URL
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func dialGymNumber(_ sender:UIButton!) {
        print("Dial Number")
        if let phoneNumber = UserDefaults.standard.url(forKey: "phoneNumber") {
            UIApplication.shared.open(phoneNumber, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func clickWebsite(_ sender:UIButton) {
        print("Website Clicked")
        if let website = UserDefaults.standard.url(forKey: "website") {
            UIApplication.shared.open(website, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func addPublicGymGroup(_ sender:UIButton) {
        print("Add Gym Button Clicked")
        guard let markerTitle = UserDefaults.standard.object(forKey: "markerTitle") else { return }
        guard let groupLocation = UserDefaults.standard.object(forKey: "locationName") else { return }
        
        self.databaseReference.child("users").child(userID as! String).child("groups").child("public").child(markerTitle as! String).setValue([
            "groupName": markerTitle,
            "groupPrivacy": "public",
            "groupLocation": groupLocation,
            "groupPic": "nothing as of now",
            "locked": true
        ])
        
        self.databaseReference.child("groups").child(markerTitle as! String).setValue([
            "groupName": markerTitle,
            "groupPrivacy": "public",
            "groupLocation": groupLocation,
            "groupPic": "nothing as of now",
            "locked": true
        ])
        
        guard let firstname = UserDefaults.standard.value(forKey: "firstname") else { return }
        guard let lastname = UserDefaults.standard.value(forKey: "lastname") else { return }
        guard let username = UserDefaults.standard.value(forKey: "profileUsername") else { return }
        guard let profilePic = UserDefaults.standard.value(forKey: "profileImageURL") else { return }
        let memberID = self.databaseReference.child(NSUUID().uuidString)
        
        self.databaseReference.child("users").child(userID as! String).child("groups").child("public").child(markerTitle as! String).child("members").child(memberID.key).setValue([
            "uid": userID as! String,
            "username": username,
            "fullname": "\(firstname) \(lastname)",
            "firstname": firstname,
            "lastname": lastname,
            "profilePic": profilePic
        ])
    }
}
