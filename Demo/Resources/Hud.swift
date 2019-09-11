//
//  Hud.swift
//  VISA Challenger
//
//  Created by Ferrando, Andrea on 02/08/2018.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

protocol DismissHudTimeout {
    func hudTimeout()
}

class Hud {
    
    var delegateTimeout: DismissHudTimeout?
    var timer: Timer?
    
    private lazy var hudView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
        if self.showGradient {
            view.addSubview(gradientV)
        }
        self.hud.center = view.center
        view.addSubview(self.hud)
        return view
    }()
    
    private lazy var gradientV: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
        view.backgroundColor = UIColor.black
        view.alpha = 0.75
        return view
    }()
    
    private lazy var hud: NVActivityIndicatorView = {
        return NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25), type: .ballSpinFadeLoader, color: .orange, padding: 80)
    }()
    
    var view: UIView!
    var showGradient: Bool = false
    
    init(mainView: UIView, showGradient:Bool=true, color:UIColor = .orange) {
        self.view = mainView
        self.showGradient = showGradient
        self.hud.color = color
    }
    
    func showLoading(_ timeout:Double=10) {
        self.timer = Timer.scheduledTimer(timeInterval: timeout, target: self, selector: #selector(triggerEndLoading), userInfo: nil, repeats: true)
        DispatchQueue.main.async {
            if !self.view.subviews.contains(self.hudView) {
                self.view.addSubview(self.hudView)
            }
            self.hud.startAnimating()
        }
    }
    
    @objc func triggerEndLoading(_ timer:Timer) {
        delegateTimeout?.hudTimeout()
        self.dismissLoading()
        timer.invalidate()
    }
    
    func dismissLoading() {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.hudView.removeFromSuperview()
            self.hud.stopAnimating()
        }
        
    }
    
    func showConfirmationTick(delay:Double=1.5, tickColor:UIColor=UIColor.green) {
        if !self.view.subviews.contains(self.hudView) {
            self.view.addSubview(self.hudView)
        }
        self.hud.removeFromSuperview()
        gradientV.alpha = 0.5
        gradientV.frame.size = CGSize(width: self.view.frame.width/2.5, height: self.view.frame.width/2.5)
        gradientV.center = self.view.center
        gradientV.layer.cornerRadius = 30
        
        let uimView = UIImageView(image: UIImage(named:"tick"))
        uimView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: gradientV.frame.width*2/3, height: gradientV.frame.height*2/3))
        uimView.tintColor = tickColor
        uimView.center = self.view.center
        uimView.contentMode = .scaleAspectFit
        hudView.addSubview(uimView)
        
        _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(triggerTime), userInfo: nil, repeats: true)
    }
    
    @objc func triggerTime(_ timer:Timer) {
        UIView.animate(withDuration: 0.5) {
            self.dismissLoading()
            self.gradientV.alpha = 0.75
            self.gradientV.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
            self.gradientV.center = self.view.center
            self.gradientV.layer.cornerRadius = 0
        }
        timer.invalidate()
    }
    
}
