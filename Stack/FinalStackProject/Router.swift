//
//  Router.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 25/08/2018.
//  Copyright © 2018 younari. All rights reserved.
//

import UIKit

fileprivate var cacheViewControllers = [String: UIViewController]()
fileprivate var storyBoardInstance = [String: UIStoryboard]()

@objc protocol RouterProtocol: NSObjectProtocol {
    static var storyboardName: String { get }
}

class Router {
    class func assembleModule(_ storyboardName: String, _ bundle: Bundle, _ identifier: String) -> UIViewController {
        if let storyboard: UIStoryboard = storyBoardInstance[storyboardName] {
            return storyboard.instantiateViewController(withIdentifier: identifier)
        }
        else {
            let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
            storyBoardInstance.updateValue(storyboard, forKey: storyboardName)
            return storyboard.instantiateViewController(withIdentifier: identifier)
        }
    }
    
    @discardableResult
    class func pushViewController(_ storyboard: String, _ identifier: String, _ navigationController: UINavigationController?, _ bundle: Bundle =  Bundle.main, _ animated: Bool = true) -> UIViewController {
        let vc = self.assembleModule(storyboard, bundle, identifier)
        navigationController?.pushViewController(vc, animated: animated)
        return vc
    }
    
    class func getStoryboardId<T>(_ classType: T) -> String {
        return String(describing: classType)
    }
    
    class func getViewController<T:UIViewController & RouterProtocol>(_ classType: T.Type, cache: Bool = false) -> T {
        let storyboardName = classType.storyboardName
        let storyboardID = self.getStoryboardId(classType)
        if cache {
            if let vc = cacheViewControllers[storyboardID] {
                return vc as! T
            } else {
                let vc = Router.assembleModule(storyboardName, Bundle.main, storyboardID)
                cacheViewControllers.updateValue(vc, forKey: storyboardID)
                return vc as! T
            }
        }
        return Router.assembleModule(storyboardName, Bundle.main, storyboardID) as! T
    }
}
