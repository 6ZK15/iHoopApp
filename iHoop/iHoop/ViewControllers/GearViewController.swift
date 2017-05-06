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

class GearViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var itemScrollView: UIScrollView!
    @IBOutlet weak var itemStackView: UIStackView!
    
    // Item One Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemInfo: UILabel!
    
    // Item Two Outlets
    @IBOutlet weak var itemBName: UILabel!
    @IBOutlet weak var itemBImageView: UIImageView!
    @IBOutlet weak var itemBInfo: UILabel!
    
    // Item Three Outlets
    @IBOutlet weak var itemCName: UILabel!
    @IBOutlet weak var itemCImageView: UIImageView!
    @IBOutlet weak var itemCInfo: UILabel!
    
    // Item Four Outlets
    @IBOutlet weak var itemDName: UILabel!
    @IBOutlet weak var itemDImageView: UIImageView!
    @IBOutlet weak var itemDInfo: UILabel!
    
    // Item Five Outlets
    @IBOutlet weak var itemEName: UILabel!
    @IBOutlet weak var itemEImageView: UIImageView!
    @IBOutlet weak var itemEInfo: UILabel!
    
    var jacketItems = [Items]()
    var pantsItems = [Items]()
    var shirtsItems = [Items]()
    var shoesItems = [Items]()
    var shortsItems = [Items]()
    var socksItems = [Items]()
    var accessories = [String]()
    var apparel = [String]()
    var accessoryImages = [UIImage]()
    var apparelImages = [UIImage]()
    
    let databaseReference = FIRDatabase.database().reference()
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGearInfo()
        
        accessoryImages = [UIImage.init(named: "bandsGBtn.png")!,
                           UIImage.init(named: "ballGBtn.png")!,
                           UIImage.init(named: "bagsGBtn.png")!,
                           UIImage.init(named: "sleeveGBtn.png")!]
        
        apparelImages = [UIImage.init(named: "socksGBtn.png")!,
                         UIImage.init(named: "shortsGBtn.png")!,
                         UIImage.init(named: "shoesGBtn.png")!,
                         UIImage.init(named: "shirtsGBtn.png")!,
                         UIImage.init(named: "pantsGBtn.png")!,
                         UIImage.init(named: "jacketsGBtn.png")!]
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidLayoutSubviews() {
        itemScrollView.isPagingEnabled = true
        itemScrollView.contentSize = CGSize(width: itemScrollView.frame.size.width * 5, height: itemScrollView.frame.size.height)
//        itemScrollView.contentSize = CGSize.init(width: itemStackView.frame.size.width + 20, height: itemScrollView.frame.size.height)
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
            self.backBtn.alpha = 1
            self.itemScrollView.alpha = 1
        })
        
        if indexPath.section == 0 {
            
        } else {
            if indexPath.row == 0 {
                itemNameLabel.text = socksItems[2].itemName
                itemInfo.text = socksItems[2].itemInfo
                itemBName.text = socksItems[0].itemName
                itemBInfo.text = socksItems[0].itemInfo
                itemCName.text = socksItems[1].itemName
                itemCInfo.text = socksItems[1].itemInfo
                itemDName.text = socksItems[3].itemName
                itemDInfo.text = socksItems[3].itemInfo
                itemEName.text = socksItems[4].itemName
                itemEInfo.text = socksItems[4].itemInfo
            } else if indexPath.row == 1 {
                itemNameLabel.text = shortsItems[2].itemName
                itemInfo.text = shortsItems[2].itemInfo
                itemBName.text = shortsItems[0].itemName
                itemBInfo.text = shortsItems[0].itemInfo
                itemCName.text = shortsItems[1].itemName
                itemCInfo.text = shortsItems[1].itemInfo
                itemDName.text = shortsItems[3].itemName
                itemDInfo.text = shortsItems[3].itemInfo
                itemEName.text = shortsItems[4].itemName
                itemEInfo.text = shortsItems[4].itemInfo
            } else if indexPath.row == 2 {
//                itemNameLabel.text = shoesItems[2].itemName
//                itemInfo.text = shoesItems[2].itemInfo
//                itemBName.text = shoesItems[0].itemName
//                itemBInfo.text = shoesItems[0].itemInfo
//                itemCName.text = shoesItems[1].itemName
//                itemCInfo.text = shoesItems[1].itemInfo
//                itemDName.text = shoesItems[3].itemName
//                itemDInfo.text = shoesItems[3].itemInfo
//                itemEName.text = shoesItems[4].itemName
//                itemEInfo.text = shoesItems[4].itemInfo
            } else if indexPath.row == 3 {
                itemNameLabel.text = shirtsItems[2].itemName
                itemInfo.text = shirtsItems[2].itemInfo
                itemBName.text = shirtsItems[0].itemName
                itemBInfo.text = shirtsItems[0].itemInfo
                itemCName.text = shirtsItems[1].itemName
                itemCInfo.text = shirtsItems[1].itemInfo
                itemDName.text = shirtsItems[3].itemName
                itemDInfo.text = shirtsItems[3].itemInfo
                itemEName.text = shirtsItems[4].itemName
                itemEInfo.text = shirtsItems[4].itemInfo
            } else if indexPath.row == 4 {
                itemNameLabel.text = pantsItems[2].itemName
                itemInfo.text = pantsItems[2].itemInfo
                itemBName.text = pantsItems[0].itemName
                itemBInfo.text = pantsItems[0].itemInfo
                itemCName.text = pantsItems[1].itemName
                itemCInfo.text = pantsItems[1].itemInfo
                itemDName.text = pantsItems[3].itemName
                itemDInfo.text = pantsItems[3].itemInfo
                itemEName.text = pantsItems[4].itemName
                itemEInfo.text = pantsItems[4].itemInfo
            } else if indexPath.row == 5 {
                itemNameLabel.text = jacketItems[2].itemName
                itemInfo.text = jacketItems[2].itemInfo
                itemBName.text = jacketItems[0].itemName
                itemBInfo.text = jacketItems[0].itemInfo
                itemCName.text = jacketItems[1].itemName
                itemCInfo.text = jacketItems[1].itemInfo
                itemDName.text = jacketItems[3].itemName
                itemDInfo.text = jacketItems[3].itemInfo
                itemEName.text = jacketItems[4].itemName
                itemEInfo.text = jacketItems[4].itemInfo
            }
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
    
    @IBAction func backToGear(_ sender: Any) {
        UIView.animate(withDuration: 1.0, animations: {
            self.itemScrollView.alpha = 0
            self.backBtn.alpha = 0
            self.collectionView.alpha = 1
        })
    }
    
    func getGearInfo() {
        databaseReference.child("Gear").child("Accessories").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.accessories = []
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
            self.apparel = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    let key = snap.key
                    self.apparel.insert(key, at: 0)
                }
            }
            print("Apparel: \(self.apparel) \(self.apparel.count)")
            self.collectionView.reloadData()
        })
        
        databaseReference.child("Gear").child("Apparel").child("Jackets & Hoodies").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.jacketItems = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Items(key: key, dictionary: itemDictionary)
                        self.jacketItems.insert(item, at: 0)
                    }
                }
            }
            print("List of items: ", self.jacketItems)
        })
        
        databaseReference.child("Gear").child("Apparel").child("Pants").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.pantsItems = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Items(key: key, dictionary: itemDictionary)
                        self.pantsItems.insert(item, at: 0)
                    }
                }
            }
            print("List of items: ", self.pantsItems)
        })
        
        databaseReference.child("Gear").child("Apparel").child("Shirts").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.shirtsItems = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Items(key: key, dictionary: itemDictionary)
                        self.shirtsItems.insert(item, at: 0)
                    }
                }
            }
            print("List of items: ", self.shirtsItems)
        })
        
//        databaseReference.child("Gear").child("Apparel").child("Shoes").observe(FIRDataEventType.value, with: {
//            (snapshot) in
//            
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
//                    if let itemDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let item = Items(key: key, dictionary: itemDictionary)
//                        self.shoesItems.insert(item, at: 0)
//                    }
//                }
//            }
//            print("List of items: ", self.shoesItems)
//        })
        
        databaseReference.child("Gear").child("Apparel").child("Shorts").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.shortsItems = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Items(key: key, dictionary: itemDictionary)
                        self.shortsItems.insert(item, at: 0)
                    }
                }
            }
            print("List of items: ", self.shortsItems)
        })
        
        databaseReference.child("Gear").child("Apparel").child("Socks").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.socksItems = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Items(key: key, dictionary: itemDictionary)
                        self.socksItems.insert(item, at: 0)
                    }
                }
            }
            print("List of items: ", self.socksItems)
        })
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * itemScrollView.frame.size.width
        itemScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(itemScrollView.contentOffset.x / itemScrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
