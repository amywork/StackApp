//  FinalStackProject
//
//  Created by Kimkeeyun on 20/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import Foundation
import UIKit

struct Explore {
    
    var title: String
    var category: String
    var URL: String
    var imageURL: String
    var description: String
    
    init?(with dic: [String:String]) {
        guard let title = dic["title"] else { return nil }
        self.title = title
        
        guard let category = dic["category"] else { return nil }
        self.category = category
        
        guard let url = dic["URL"] else { return nil }
        self.URL = url
        
        guard let imageURL = dic["imageURL"] else { return nil }
        self.imageURL = imageURL
        
        guard let description = dic["description"] else { return nil }
        self.description = description
    }
    
}



