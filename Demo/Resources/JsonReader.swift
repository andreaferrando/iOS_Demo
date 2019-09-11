//
//  JsonReader.swift
//  Demo
//
//  Created by Ferrando, Andrea on 12/12/2018.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation


protocol JsonProtocol {
    static func saveDictToJsonFile(fileName: String, array: [String : Any])
    static func retrieveJsonFileFromDocumentDirectory(fileName:String) -> Any?
    static func retrieveJsonFileFromBundle(fileName: String) -> Any?
}


struct JsonManager: JsonProtocol {
    
    static func saveDictToJsonFile(fileName: String, array: [String : Any]) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("\(fileName).json")
//        print(fileUrl)
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    static func retrieveJsonFileFromDocumentDirectory(fileName:String) -> Any? {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("\(fileName).json")
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            return nil
        }
    }
    
    static func retrieveJsonFileFromBundle(fileName: String) -> Any? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        } catch {
            return nil
        }
    }
    
}
