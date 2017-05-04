//
//  GearViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/29/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GearViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Items]()
    var accessories = [String]()
    var apparel = [String]()
    var accessoryImages = [UIImage]()
    var apparelImages = [UIImage]()
    
    let databaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGearInfo()
        
        accessoryImages = [UIImage.init(named: "bandsGBtn.png")!,
                           UIImage.init(named: "ballGbtn.png")!,
                           UIImage.init(named: "bagsGBtn.png")!,
                           UIImage.init(named: "sleeveGBtn.png")!]
        
        apparelImages = [UIImage.init(named: "socksGBtn.png")!,
                         UIImage.init(named: "shortsGBtn.png")!,
                         UIImage.init(named: "shoesGBtn.png")!,
                         UIImage.init(named: "shirtsGBtn.png")!, 
                         UIImage.init(named: "pantsGbtn.png")!,
                         UIImage.init(named: "jacketsGBtn.png")!]

        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return accessories.count
        } else {
            return apparel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "headerIdentifier",
                                                                         for: indexPath) as! GearCollectionReusableView
        
        if indexPath.section == 0 {
            headerView.headerLabel.text = "Accessories"
        } else {
            headerView.headerLabel.text = "Apparel"
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! GearCollectionViewCell
        
        if indexPath.section == 0 {
            cell.titleLabel.text = accessories[indexPath.row]
            cell.cellImage.image = accessoryImages[indexPath.row]
        } else {
            cell.titleLabel.text = apparel[indexPath.row]
            cell.cellImage.image = apparelImages[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0, animations: {
            collectionView.alpha = 0
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getGearInfo() {
        databaseReference.child("Gear").child("Accessories").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    let key = snap.key
                    self.accessories.insert(key, at: 0)
                }
            }
            print("Accessories: \(self.accessories) \(self.accessories.count)")
            self.collectionView.reloadData()
        })
        
        databaseReference.child("Gear").child("Apparel").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    let key = snap.key
                    self.apparel.insert(key, at: 0)
                }
            }
            print("Apparel: \(self.apparel) \(self.apparel.count)")
            self.collectionView.reloadData()
        })
    }

}
