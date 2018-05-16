//
//  Category.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 5/14/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
