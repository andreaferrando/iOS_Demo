//
//  UIViewController+Utils.swift
//  Demo
//
//  Created by Ferrando, Andrea on 10/04/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var placeholderImageLoadingView: UIImageView = {
        let imv = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        imv.image = UIImage(named:"loadingPostsPlaceHolder")
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    
    lazy var whiteLoadingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var noDataView: UIView?
    
    func getNoDataView(frame: CGRect, text:String?=nil) -> UIView {
        let noDataView: NoDataView = UIView.fromNib()
        noDataView.frame = frame
        self.noDataView = noDataView
        return noDataView
    }
    
    lazy var hud: Hud = {
        return Hud(mainView: self.view)
    }()
    
}



extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
