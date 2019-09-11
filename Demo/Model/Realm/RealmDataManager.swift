//
//  RealmDataManager.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import RealmSwift

class DataManagerRealm {
    
    var realm = try! Realm()
    static let defaultQueue = DispatchQueue(label: "backgroundQueue", qos: .background)
    
    func saveObject(_ object:Object, onBackgroundQueue backgroundQueue:DispatchQueue?=nil, update:Bool = false) {
        if let queue = backgroundQueue {
            queue.async {
                self.write(object, update:update)
            }
        } else {
            write(object, update:update)
        }
    }
    
    func write(_ object:Object, update:Bool) {
        do {
            try self.realm.write {
                self.realm.add(object, update:update == true ? .all : .error)
            }
        } catch { }
    }
    
    func write(_ objects:[Object], update:Bool) {
        do {
            try self.realm.write {
                self.realm.add(objects, update:update == true ? .all : .error)
            }
        } catch { }
    }
    
    func deleteObject(_ object:Object, onBackgroundQueue backgroundQueue:DispatchQueue?=nil) {
        if let queue = backgroundQueue {
            queue.async {
                self.delete(object)
            }
        } else {
            delete(object)
        }
    }
    
    func delete(_ object:Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch { }
    }
}
