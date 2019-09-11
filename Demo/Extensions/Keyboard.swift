//
//  Keyboard.swift
//  Demo
//
//  Created by Ferrando, Andrea on 27/08/2019.
//  Copyright © 2019 Capco. All rights reserved.
//

import UIKit

// MARK: - Keyboard
protocol KeyboardAppearingProtocol {
    func startObservingKeyboardChanges(completion:@escaping(_ keyboardSize:CGSize, _ dismiss:Bool) -> Void)
}

extension KeyboardAppearingProtocol {
    
    func startObservingKeyboardChanges(completion:@escaping(_ keyboardSize:CGSize, _ dismiss:Bool) -> Void) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo,
            let keyboardFrameEndUserInfoKey = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardSize = keyboardFrameEndUserInfoKey.cgRectValue.size
            completion(keyboardSize, false)
        }
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo,
                let keyboardFrameEndUserInfoKey = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardSize = keyboardFrameEndUserInfoKey.cgRectValue.size
            completion(keyboardSize, true)
        }
    }
}
