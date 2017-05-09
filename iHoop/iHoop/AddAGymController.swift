//
//  AddAGymController.swift
//  iHoop
//
//  Created by Eric Dowdell on 5/8/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GooglePlaces
import CoreLocation


class AddAGymController: UIViewController, UIWebViewDelegate {
    @IBOutlet var txtName: UITextField!
    @IBOutlet var textAddress: UITextField!
    @IBOutlet var textPhoneNumber: UITextField!
    @IBOutlet var textWebsite: UITextField!
    @IBOutlet var menuButton: UIButton!
    
    let textField = TextField()


    override func viewDidLoad() {
       
        
        if revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        textField.setErrorTextField(textField: txtName,borderWidth: 2)
        textField.setErrorTextField(textField: textAddress,borderWidth: 2)
        textField.setErrorTextField(textField: textPhoneNumber,borderWidth: 2)
        textField.setErrorTextField(textField: textWebsite,borderWidth: 2)
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitGymInfo(_ sender: Any) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textAddress.text!) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            print("Lat: \(lat), Lon: \(lon)")
            
            let userAddedPlace = GMSUserAddedPlace()
            let placesClient = GMSPlacesClient()
            userAddedPlace.name = self.txtName.text
            userAddedPlace.address = self.textAddress.text
            userAddedPlace.coordinate = CLLocationCoordinate2DMake(lat!, lon!)
            userAddedPlace.phoneNumber = self.textPhoneNumber.text
            userAddedPlace.website = self.textWebsite.text
            userAddedPlace.types = ["gym"]
            placesClient.add(userAddedPlace, callback: { (place, error) -> Void in
                if let error = error {
                    print("Add Place error: \(error.localizedDescription)")
                    return
                }
                
                if let place = place {
                    print("Added place with placeID \(place.placeID)")
                    print("Added Place name \(place.name)")
                    print("Added Place address \(place.formattedAddress)")
                    
                }
            })
        }
        
      
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
