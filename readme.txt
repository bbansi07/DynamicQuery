Title: Easy SQLite Wrapper For iOS in Swift
Description: This iOS project is a Example using SQLDataIO.swift
Copyright: Copyright © Cindy Oakes 2016
Contact:  pgmr_64804@yahoo.com or look me up on facebook, twitter, linkedin, ect...


This project is a complete app that creates, creates a table, does various commands and then adds the output to an array to be listed in a tableview. 

To add SQLite functions to your project:

1) Make sure that the libsqlite3.tbd is linked to the project and you can do that in the General Settings of the app

2) Add a header file to the project and call it BridgingHeader.h and type the following line to include the C Api

#include <sqlite3.h>


3)  Go to "Build Settings" and find "Objective-C Bridging Header." Use the search bar to find it quickly.   Double-click and type "BridgingHeader.h"  If you get "Could not import Objective-C Header," try "my-project-name/BridgingHeader.h"


4) Go to "Build Phases," "Link Binary With Libraries," and add libsqlite3.tbd

5) Add in the SQLDataIO.swift to your project (or just create a new one and copy/paste the code in from this sample project)


Note:  functions PerformSQLCommands and printRows are just for the demo and can be deleted out if you like.

