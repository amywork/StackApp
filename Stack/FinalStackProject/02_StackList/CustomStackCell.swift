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
    
    private var payday: String?
    
    var data: Stack? {
        willSet {
            self.titleLabel?.text = data?.title
            self.detailLabel?.text = "\(data?.price)"
            guard let payday = payday else { return }
            self.subTitleLabel?.text = "매 월 " + payday + " 일 결제"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
