//
//  Alert.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit

struct Alert {
    
    static func present(on vc: UIViewController, title:String, message:String, cancelBtnTitle:String="Cancel", confirmBtnTitle:String="Ok", accepted:@escaping() -> Void, denied:@escaping() -> Void) {
        let popup = PopupDialog(title: title, message: message)
        let buttonOne = CancelButton(title: cancelBtnTitle, height: 60) {
            denied()
        }
        let buttonTwo = DefaultButton(title: confirmBtnTitle, height: 60) {
            accepted()
        }
        popup.addButtons([buttonOne, buttonTwo])
        vc.present(popup, animated: true, completion: nil)
    }
    
    static func present(on vc: UIViewController, title:String, message:String, animated:Bool=true) {
        let popup = PopupDialog(title: title, message: message)
        let buttonOne = DefaultButton(title: "Ok", height: 60) {}
        popup.addButtons([buttonOne])
        vc.present(popup, animated: animated, completion: nil)
    }
    
    static func presentAndRetry(on vc: UIViewController, title:String, message:String, completion:@escaping(_ retry:Bool) -> Void) {
        let popup = PopupDialog(title: title, message: message)
        let buttonOne = CancelButton(title: "Cancel", height: 60) {
            completion(false)
        }
        let buttonTwo = DefaultButton(title: "Ok", height: 60) {
            completion(true)
        }
        popup.addButtons([buttonOne, buttonTwo])
        vc.present(popup, animated: true, completion: nil)
    }
    
    static func presentAndRetryNoNetworkConnectivity(on vc: UIViewController, completion:@escaping(_ retry:Bool) -> Void) {
        let title = "No Network Connectivity"
        let message = "No internet connection on your device, cross check your internet connectivity and try again"
        let popup = PopupDialog(title: title, message: message, transitionStyle:PopupDialogTransitionStyle.zoomIn, tapGestureDismissal:false, panGestureDismissal:false)

        let buttonOne = CancelButton(title: "Cancel", height: 60) {
            completion(false)
        }
        let buttonTwo = DefaultButton(title: "Ok", height: 60) {
            completion(true)
        }
        popup.addButtons([buttonOne, buttonTwo])
        vc.present(popup, animated: true, completion: nil)
    }
}
