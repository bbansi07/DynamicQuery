//
//  ViewController.swift
//  SQLiteWrapper
//
//  Created by Cindy Oakes on 5/28/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

import UIKit

class SQLViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailDelegate {
    
    //MARK: Properties & Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var item: [String] = []
    var items = NSMutableArray()
    var index : Int! = -1
    var selectedIndex : Int!
   private var users = [UserModel]()
    //MARK:  Init & Load
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //SQLLiteWrapper commands called here and table data created to show output
        
       // items = SQLDataIO.PerformedSQLCommands()
       
        
               tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        index = -1
       
     //   items = SQLDataIO.PerformedSQLCommands()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        let pathToDatabase = documentsDirectory.appending("/UserData")
        
        var dbCommand: String = ""
        var databaseRows: [[String]] = [[]]
        
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            
            dbCommand = "select * from User"
            items = SQLDataIO.fetchAllData(dbCommand)
           
        }
            
        else{
            dbCommand = "CREATE TABLE User(ID INT PRIMARY KEY NOT NULL, FirstName CHAR(100), LastName CHAR(100));"
            SQLDataIO.insertUpdateDatabase(dbCommand)
            
            let id: Int = 0
            
            dbCommand = String(format: "insert into User(ID, FirstName, LastName) values (%d, 'Cindy', 'Oakes')", id)
            SQLDataIO.insertUpdateDatabase(dbCommand)
            
            dbCommand = "select * from User"
            items = SQLDataIO.fetchAllData(dbCommand)
           
            
        }
        tableView.dataSource = self
        tableView.delegate = self

         tableView.reloadData()
    }
    
    func passingArray(array: [String]) {
      //  items = array
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        index = -1
    }
    //MARK:  Table View Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath)
       
        let item1 : NSDictionary = items[indexPath.row] as! NSDictionary
        
        
        //print(values)
        //let print = "\(values["id"]) \(values["fname"]) \(values["lname"])"
       let print = "\(item1["ID"]!) \(item1["FirstName"] as! String) \(item1["LastName"] as! String)"
        cell.textLabel?.text = print
       // let item = items[(indexPath as NSIndexPath).row]
        index = (indexPath as NSIndexPath).row
       // cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        selectedIndex = (indexPath as NSIndexPath).row
        
        self.performSegue(withIdentifier: "userDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete
        {
               let item1 : NSDictionary = items[indexPath.row] as! NSDictionary
            let query  = "DELETE FROM User WHERE ID = \(item1["ID"]!);"
            SQLDataIO.insertUpdateDatabase(query)
            items.remove(at: indexPath.row)
            items = SQLDataIO.fetchAllData("select * from User")
            self.tableView.reloadData()
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "userDetail"){
            let dest = segue.destination as? DetailVC
            if(index >= 0){
                let item1 : NSDictionary = items[selectedIndex!] as! NSDictionary
               
                let print = "\(item1["ID"]!)"
                dest?.recordToEdit = index
                dest?.delegate = self
                
                dest?.fname = item1["FirstName"] as! String
                dest?.lname = item1["LastName"] as! String
                dest?.indexx = Int(print)
            }
        }
    }

    
    
        
        
    

}

