//
//  DBManager.swift
//  Library
//
//  Created by Edward Lauv on 8/24/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    private var database: Realm
    init(){
        //khoi tao realm
        database = try! Realm()
    }
    
    //get all item in db
    func getDataFromDB() -> Results<RealmImage> {
        let result : Results<RealmImage> = database.objects(RealmImage.self)
        return result
    }
    
    //add item to db
    func addData(object: ImageModel) {
        let item = RealmImage()
        item.id = UUID().uuidString
        item.image = object
        try! database.write{
            database.add(item)
        }
    }
    
    // delete item in database
    func deleteItem(object: RealmImage) -> Bool {
        do {
            try database.write {
                database.delete(object)
            }
            return true
        }
        catch {
            return false
        }
    }
    
    // delete all item in db
    func deleteAll() -> Bool {
        do {
            try! database.write {
                database.deleteAll()
            }
            return true
        }
        catch {
            return false
        }
    }
}
