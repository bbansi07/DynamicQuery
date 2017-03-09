//
//  DetailVC.swift
//  SQLiteDemo
//
//  Created by Zeitech Solutions on 02/03/17.
//  Copyright © 2017 Zeitech Solutions. All rights reserved.
//

import Foundation


import UIKit

protocol DetailDelegate : class {
    
    func passingArray(array : [String])
   
    
}


class DetailVC: UIViewController {
    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtLName : UITextField!
    @IBOutlet weak var btnADD : UIButton!
    @IBOutlet weak var btnUpdate : UIButton!
    var fullData : String? = ""
    var user = [UserModel]()
    
    var fname = ""
    var lname = ""
    var recordToEdit :Int? = -1
    var indexx : Int!
    
    weak var delegate : DetailDelegate?
     var updatedItems: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        btnADD?.isHidden = true
        btnUpdate?.isHidden = true
        if(recordToEdit! >= 0){
            txtName.text = fname
            txtLName.text = lname
            //indexx = varStr
            btnADD?.isHidden = true
            btnUpdate?.isHidden = false
            
        }else{
            btnADD?.isHidden = false
            btnUpdate?.isHidden = true
        }
       
    }
    
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        fullData = ""
    }
    
    @IBAction func insertData(_ sender: Any) {
        let nextID = SQLDataIO.nextID("User")
        let query : String = String(format:"INSERT INTO User (ID,FirstName, LastName) VALUES (\(nextID),'\(txtName.text!)','\(txtLName.text!)');")
       
        SQLDataIO.insertUpdateDatabase(query)
           //  updatedItems = SQLDataIO.fetchArray()
        
       // delegate?.passingArray(array: updatedItems)
      
        
        //let user = UserModel(id: indexx , fName: txtName.text!, LName: txtLName.text!)
        
        //print("\(user.firstName)")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func updatedata(_ sender: Any) {
        let query : String = "UPDATE User SET FirstName='\(txtName.text!)',LastName='\(txtLName.text!)' WHERE ID=\(indexx!);"
      
        SQLDataIO.insertUpdateDatabase(query)
     
       
       
        self.navigationController?.popViewController(animated: true)
    }
    
   }
