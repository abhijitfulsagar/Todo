//
//  AppDelegate.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 4/6/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
             _ = try Realm()
        }catch{
            print("Error is:\(error)")
        }
       
        return true
    }

}

