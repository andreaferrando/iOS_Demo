//
//  Global.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit

struct DemoError {
    
    enum Domain: String {
        case dataFormat = "Data Format"
        case parsing = "Parsing"
        case network = "Network"
    }
    
    enum Title: String {
        case dataError = "Data Error"
    }
    
    enum Body: String {
        case parsingInformation = "error with parsing information"
        case retrievingInformation = "error with retrieving information"
        case dataNotFound = "data not found"
        case retrievingInformationMethod = "error with retrieving information method"
        case timeout = "Timeout: error retrieving data"
    }
   
}

struct Constants {
    
    static let message = "message"
    static let author = "author"
    static let user = "user"
    
    static var topSafeArea: CGFloat {
        var pad: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            pad = window?.safeAreaInsets.top ?? 0
        }
        return pad
    }
    
    static var leftSafeArea: CGFloat {
        var pad: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            pad = window?.safeAreaInsets.left ?? 0
        }
        return pad
    }
    
    static var rightSafeArea: CGFloat {
           var pad: CGFloat = 0
           if #available(iOS 11.0, *) {
               let window = UIApplication.shared.keyWindow
               pad = window?.safeAreaInsets.right ?? 0
           }
           return pad
       }
}

