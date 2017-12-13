//
//  CustomStackCell.swift
//  FinalStackProject
//
//  Created by 김기윤 on 09/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

class CustomStackCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    var data: Stack? {
        didSet {
            guard let data = data else { return }
            self.titleLabel?.text = data.title
            self.detailLabel?.text = "$ \(data.price)"
            self.subTitleLabel?.text = data.planType.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = colorView.bounds.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
