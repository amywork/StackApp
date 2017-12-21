//
//  SearchResultsCell.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 02/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    
    var data: Explore? {
        didSet {
            configureCell()
        }
    }
    
    func configureCell() {

        let image = UIImage(named: "placeHolder")
        if let imageURL = data?.imageURL {
            self.iconImageView.kf.setImage(with: URL(string: imageURL)!, placeholder: image)
        }
        self.titleLabel.text = data?.title
        self.subTitleLabel.text = data?.URL

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.isHighlighted = false
        // Configure the view for the selected state
    }

}
