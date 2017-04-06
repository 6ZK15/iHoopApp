//
//  FriendsViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/29/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    let friendOperations = FriendOperations()
    
    var friends = [Friends]()
    var filteredFriends = [Friends]()
    let searchController = UISearchController(searchResultsController: nil)
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendOperations.getListOfFriends()
        setSearchController()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        let menuBtn = UIButton.init(type: UIButtonType.custom)
        menuBtn.setImage(UIImage(named: "menuBtn.png"), for: UIControlState.normal)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let leftBarButton = UIBarButtonItem(customView: menuBtn)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! FriendsTableViewCell
        let friend: Friends
        
        if searchController.isActive && searchController.searchBar.text != "" {
            friend = filteredFriends[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
        cell.configureCell(friend)
        
        cell.setFunction {
            let userID = UserDefaults.standard.value(forKey: "currentUserUID") as! String
            let requestID = self.databaseReference.child("users").child(NSUUID().uuidString)
            let firstname = UserDefaults.standard.value(forKey: "firstname") as! String
            let lastname = UserDefaults.standard.value(forKey: "lastname") as! String
            self.databaseReference.child("requests").child(self.filteredFriends[indexPath.row].username).child(requestID.key).setValue([
                "uid": userID,
                "username": UserDefaults.standard.value(forKey: "profileUsername") as! String,
                "fullname": firstname + " " + lastname
            ])
        }
        
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFriends = friends.filter({( friend : Friends) -> Bool in
            let categoryMatch = (scope == "All") || (friend.key == scope)
            return categoryMatch && friend.username.lowercased().contains(searchText.lowercased())
        })
        friendsTableView.reloadData()
    }
    
    func setSearchController() {
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.view.backgroundColor = UIColor.clear
        searchController.searchBar.barTintColor = UIColor.clear
        searchController.searchBar.tintColor = UIColor.white
        
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Friends", "Username"]
        friendsTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
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
