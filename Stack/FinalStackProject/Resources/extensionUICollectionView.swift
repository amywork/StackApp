//
//  extensionUICollectionView.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 25/08/2018.
//  Copyright © 2018 younari. All rights reserved.
//

import Foundation
import UIKit

private var Object_class_Name_Key : UInt8 = 0
private var Object_iVar_Name_Key : UInt8 = 0
private var Object_iVar_Value_Key : UInt8 = 0


@inline(__always) public func swiftClassFromString(_ className: String, bundleName: String = "WiggleSDK") -> AnyClass? {
    
    // get the project name
    if  let appName = Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as? String {
        // generate the full name of your class (take a look into your "YourProject-swift.h" file)
        let classStringName = "\(appName).\(className)"
        guard let aClass = NSClassFromString(classStringName) else {
            let classStringName = "\(bundleName).\(className)"
            guard let aClass = NSClassFromString(classStringName) else {
                //                print(">>>>>>>>>>>>> [ \(className) ] : swiftClassFromString Create Fail <<<<<<<<<<<<<<")
                return nil
                
            }
            return aClass
        }
        return aClass
    }
    //    print(">>>>>>>>>>>>> [ \(className) ] : swiftClassFromString Create Fail <<<<<<<<<<<<<<")
    return nil
}


extension NSObject {
    
    public var tag_name: String? {
        get {
            return objc_getAssociatedObject(self, &Object_iVar_Name_Key) as? String
        }
        set {
            objc_setAssociatedObject(self, &Object_iVar_Name_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var tag_value: Any? {
        get {
            return objc_getAssociatedObject(self, &Object_iVar_Value_Key)
        }
        set {
            objc_setAssociatedObject(self, &Object_iVar_Value_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var className: String {
        if let name = objc_getAssociatedObject(self, &Object_class_Name_Key) as? String {
            return name
        }
        else {
            let name = String(describing: type(of:self))
            objc_setAssociatedObject(self, &Object_class_Name_Key, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
        
        
    }
    
    public class var className: String {
        if let name = objc_getAssociatedObject(self, &Object_class_Name_Key) as? String {
            return name
        }
        else {
            let name = NSStringFromClass(self).components(separatedBy: ".").last ?? ""
            objc_setAssociatedObject(self, &Object_class_Name_Key, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
    }
}

extension UICollectionView {
    
    public func register(_ Class: UICollectionViewCell.Type) {
        register(Class, forCellWithReuseIdentifier: Class.className)
    }
    
    public func registerNibCell(_ Class: UICollectionViewCell.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forCellWithReuseIdentifier: Class.className)
    }
    
    public func registerNibCellHeader(_ Class: UICollectionReusableView.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Class.className)
    }
    
    public func registerNibCellFooter(_ Class: UICollectionReusableView.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Class.className)
    }
    
    public func registerHeader(_ Class: UICollectionReusableView.Type) {
        register(Class, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Class.className)
    }
    
    public func registerCustomKindReusableView(_ Class: UICollectionReusableView.Type, _ Kind: String, _ identifier: String) {
        register(Class, forSupplementaryViewOfKind: Kind, withReuseIdentifier: identifier)
    }
    
    public func registerFooter(_ Class: UICollectionReusableView.Type) {
        register(Class, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Class.className)
    }
    
    public func dequeueReusableCell<T:UICollectionViewCell>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: Class.className, for: indexPath) as! T
    }
    
    public func dequeueReusableHeader<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Class.className, for: indexPath) as! T
    }
    
    public func dequeueReusableFooter<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Class.className, for: indexPath) as! T
    }
    
    public func dequeueDefaultSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
    }
    
    
}
