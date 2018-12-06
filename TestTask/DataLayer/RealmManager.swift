//
//  RealmManager.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static let sharedManager = RealmManager()
    let realm = try? Realm()
    
    // MARK: Save array of objects to database
    func saveObjects(objs: Object) {
        try? realm!.write ({
            // If update = false, adds the object
            realm?.add(objs, update: false)
        })
    }
    
    // MARK: Returs an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm!.objects(type)
    }
    
    // MARK: delete particular object
    func deleteObject(objs : Object) {
        try? realm!.write ({
            realm?.delete(objs)
        })
    }
}
