//
//  Extensions.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 05/12/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    static func main() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}

extension Notification.Name {
    static let newStack = Notification.Name(rawValue: "NewStack")
    static let fetchExplores = Notification.Name(rawValue: "fetchExplores")
}

var imageCache = [String:UIImage]()

extension UIImageView {
    
    func loadImage(URLstring : String) {
        
        self.image = nil
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        
        if let cachedImage = imageCache[URLstring] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string : URLstring) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.image = nil
                }
                print(error.localizedDescription)
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                imageCache[URLstring] = image
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            }.resume()
    }
    
}

extension UIImage {
    func generateJPEGData() -> Data {
        return UIImageJPEGRepresentation(self, 0.5)!
    }
}

extension Date {
    public func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd - MM - yy"
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    
    public func makeDate(with string: String) -> Date? {
        self.dateFormat = "dd - MM - yy"
        return self.date(from: string)
    }
    
}

