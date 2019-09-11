//
//  DetailsTableViewCell.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(title: String, author: String, body: String) {
        lbTitle.text = title
        lbBody.text = body
        lbAuthor.text = Constants.author.capitalized + ": \(author)"
    }

}
