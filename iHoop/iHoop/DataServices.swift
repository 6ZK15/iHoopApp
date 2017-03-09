//
//  DataServices.swift
//  iHoop
//
//  Created by Eric Dowdell on 3/8/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import Firebase



let DB_BASE = FIRDatabase.database().reference()

class DataService{
    
    //Create instance of Class to use
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_FIRSTNAME = DB_BASE.child("firstname")
    private var _REF_LASTNAME = DB_BASE.child("lastname")
    private var _REF_USERNAME = DB_BASE.child("username")
    private var _REF_EMAIL = DB_BASE.child("email")
    private var _REF_PASSWORD = DB_BASE.child("password")
    private var _REF_PROFILEPIC = DB_BASE.child("profilepic")
    private var _REF_SECURITYQUESTION = DB_BASE.child("securityquestion")
    private var _REF_SECURITYANSWER = DB_BASE.child("securityanswer")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_FIRSTNAME: FIRDatabaseReference {
        return _REF_FIRSTNAME
    }
    var REF_LASTNAME: FIRDatabaseReference {
        return _REF_LASTNAME
    }
    var REF_USERNAME: FIRDatabaseReference {
        return _REF_USERNAME
    }
    var REF_EMAIL: FIRDatabaseReference {
        return _REF_EMAIL
    }
    var REF_PASSWORD: FIRDatabaseReference {
        return _REF_PASSWORD
    }
    var REF_PROFILEPIC: FIRDatabaseReference {
        return _REF_PROFILEPIC
    }
    var REF_SECURITYQUESTION: FIRDatabaseReference {
        return _REF_SECURITYQUESTION
    }
    var REF_SECURITYANSWER: FIRDatabaseReference {
        return _REF_SECURITYANSWER
    }
    
    func createFirebaseUser(uid:String){
        REF_USERS.child(uid)
    }
    
}
