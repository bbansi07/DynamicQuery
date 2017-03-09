//
//  UserModel.swift
//  SQLiteWrapper
//
//  Created by Zeitech Solutions on 03/03/17.
//  Copyright © 2017 Cindy Oakes. All rights reserved.
//

import Foundation

class UserModel{
    
    var Id : Int!
    var firstName : String!
    var lastName : String!
    
    
    enum Keys:String {
        case ID = "ID"
        case FirstName = "FirstName"
        case LastName = "LastName"
    }
    
    init(id : Int){
        self.Id = id
        self.firstName = ""
        self.lastName = ""
    }
    init(id : Int , fName : String ) {
        self.Id = id
        self.firstName = fName
    }
 
    init(id : Int , fName : String , LName : String) {
        self.Id = id
        self.firstName = fName
        self.lastName = LName
    }
    
    required init?(coder aDecoder: NSCoder) {
        Id = aDecoder.decodeObject(forKey: Keys.ID.rawValue) as! Int
        firstName = aDecoder.decodeObject(forKey: Keys.FirstName.rawValue) as! String
        lastName = aDecoder.decodeObject(forKey: Keys.LastName.rawValue) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Id, forKey: Keys.ID.rawValue)
        aCoder.encode(firstName, forKey: Keys.FirstName.rawValue)
        aCoder.encode(lastName, forKey: Keys.LastName.rawValue)
    }
    
}
