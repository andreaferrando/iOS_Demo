//
//  PostsCollectionViewCell.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit

class PostsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(title:String) {
        lbTitle.text = title
    }

}
