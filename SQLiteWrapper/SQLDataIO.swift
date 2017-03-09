 //
//  SQLDataIO.swift
//  SQLiteWrapper
//
//  Created by Cindy Oakes on 5/28/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

//the directory and file url prints, so you can navigate to it and throw the database in the trash between runs while testing
//if you can not find the folders by browing then on the Finder menu at the top click Go=>GoToFolder then type in  Library or 
//Developer to help you get to it because apple is hiding them

// be sure and use the readme.txt to get the sql libraries linked up correctly

import UIKit



class SQLDataIO
{
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let DBURL = DocumentsDirectory.appendingPathComponent("UserData")
   
    static var items: [String] = []
    
    static func fetchArray() -> [String]{
        var dbCommand: String = ""
        var databaseRows: [[String]] = [[]]
        dbCommand = "select * from User"
        databaseRows = getRows(dbCommand, numColumns: 3)
        printRows(databaseRows)
        return items
    }
    
    static func PerformedSQLCommands() -> [String]
    {
        
        print("\(DocumentsDirectory)")
        print("\(DBURL)")
       // let path = DBURL as? String
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        let pathToDatabase = documentsDirectory.appending("/UserData")


         var dbCommand: String = ""
         var databaseRows: [[String]] = [[]]
        
        
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            //dbCommand = "select ID, FirstName, LastName from User"
            items.removeAll()
            dbCommand = "select * from User"
            databaseRows = getRows(dbCommand, numColumns: 3)
            printRows(databaseRows)
        }
            
        else{
        dbCommand = "CREATE TABLE User(ID INT PRIMARY KEY NOT NULL, FirstName CHAR(100), LastName CHAR(100));"
        insertUpdateDatabase(dbCommand)
        
        let id: Int = 0
            
        dbCommand = String(format: "insert into User(ID, FirstName, LastName) values (%d, 'Cindy', 'Oakes')", id)
        insertUpdateDatabase(dbCommand)
        
        dbCommand = "select ID, FirstName, LastName from User"
        databaseRows = getRows(dbCommand, numColumns: 3)
        printRows(databaseRows)
        
        }
        
              return items
    }
    
    
    //MARK: Print Rows
    
    static func printRows(_ rows: [[String]])
    {
        for i in 0..<rows.count
        {
            var rowValue = "";
            
            var row: [String] = rows[i]
            
            for j in 0..<row.count
            {
                rowValue += String(format: " %@", row[j])
            }
            
            if (rowValue != "")
            {
                items.append(rowValue)
            }
        }
     
    }

    
    //MARK:  Open Database
    
    static func openDatabase() -> OpaquePointer {
        var db: OpaquePointer? = nil
        if sqlite3_open(DBURL.absoluteString, &db) == SQLITE_OK {
           //do nothing
        } else {
            print("Unable to open database. ")
        }
        return db!
    }
    
    
    
    static func fetchAllData(_ dbCommand : String) -> NSMutableArray {
        var statement: OpaquePointer? = nil
        let arr = NSMutableArray()
        let db: OpaquePointer = SQLDataIO.openDatabase()
        var tempDictionary : NSMutableDictionary!
        
       
        if (sqlite3_prepare_v2(db, dbCommand , -1, &statement, nil) == SQLITE_OK) {
           
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                let columnCount = sqlite3_column_count(statement)
                tempDictionary = NSMutableDictionary()
               
                
                for i in  0..<columnCount
                {
                    
                    let type = sqlite3_column_type(statement,Int32(i))
                    
                    let name  = sqlite3_column_name(statement, Int32(i))
                    let nameStr  = String(cString: name!)
                    var valStr : Any!
                    print(nameStr)
                   
                    if type == SQLITE_TEXT{
                        let val = sqlite3_column_text(statement, Int32(i))
                        
                        valStr = String(cString: val!)
                        
                        
                    }else if type == SQLITE_INTEGER{
                        let val = sqlite3_column_int64(statement, Int32(i))
                        
                         valStr = Int64(val)
                        
                    }
                     tempDictionary.setValue(valStr, forKey: nameStr)
                    print("dictionary here: \(tempDictionary)")
                    
                    //print("col: \(i) | value:\(valStr)")
                }
                arr.add(tempDictionary)
                print("array: \(arr)")
                
            }
           
            
        }
        return arr
    }
    
    //MARK:  Update Database
    
    
    static func insertUpdateDatabase(_ dbCommand: String)
    {
        var statement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
               //do nothing
              
            } else {
                print("Could not updateDatabase")
            }
        } else {
            print("updateDatabase dbCommand could not be prepared")
        }
        
        sqlite3_finalize(statement)
        
        sqlite3_close(db)
        
    }
    
    //MARK:  Get DBValue
    
    static func dbValue(_ dbCommand: String) -> String
    {
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        var value: String? = nil
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                let getResultCol = sqlite3_column_text(getStatement, 0)
                value = String(cString:getResultCol!)
                print("value is >>> \(value)")
                
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
        
        if (value == nil)
        {
            value = ""
        }
       
        return value!
    }
    
       

    
    //MARK: Get Next ID
    
    static func nextID(_ tableName: String!) -> Int
    {
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        let dbCommand = String(format: "select ID from %@ order by ID desc limit 1", tableName)
        
        var value: Int32? = 0
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                value = sqlite3_column_int(getStatement, 0)
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
        
        var id: Int = 1
        if (value != nil)
        {
            id = Int(value!) + 1
        }
        
        return id
    }

    
    //MARK: Get DB Int
    
    static func dbInt(_ dbCommand: String!) -> Int
    {
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        var value: Int32? = 0
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                value = sqlite3_column_int(getStatement, 0)
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
       
        var int: Int = 1
        if (value != nil)
        {
            int = Int(value!)
        }
       
        
        return int
    }

    
    //MARK:  Get Rows
    
    static func getRows(_ dbCommand: String, numColumns: Int) -> [[String]]
    {
        var outputArray: [[String]] = [[]]
        
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            while sqlite3_step(getStatement) == SQLITE_ROW {
                
                var rowArray: [String] = []
                
                for i in  0..<numColumns
                {
                    let val = sqlite3_column_text(getStatement, Int32(i))
                    //let valStr = String(cString: UnsafePointer<CChar>(val!))
                    
                    let valStr = String(cString: val!)
                    
                    
                    rowArray.append(valStr)
                    //print("col: \(i) | value:\(valStr)")
                }
                
                outputArray.append(rowArray)
                
            }
            
        } else {
            print("getRows statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
        
        return outputArray
    }
    

   
    
}
