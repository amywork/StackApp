//
//  FirebaseAPI.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 08/12/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import Foundation
import Firebase

protocol API {
    typealias SuccessHandler = (_ isSuccess: Bool) -> Void
    func fetchExplores(handler: @escaping SuccessHandler) -> Void
    func uploadStacks(data: Stack, handler: @escaping SuccessHandler) -> Void
    func fetchUserStacks(handler: @escaping SuccessHandler) -> Void
}

class FirebaseAPI: API {
    let baseReference = Database.database().reference()
    
    func fetchExplores(handler: @escaping SuccessHandler) {
        baseReference
            .child(GlobalState.Constants.Explore.rawValue)
            .observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionaries = snapshot.value as? [[String: String]] else { return }
                GlobalState.shared.explores = []
                for exploreDict in dictionaries {
                    
                    guard let newExplore = Explore(with: exploreDict) else { return }
                    GlobalState.shared.explores.append(newExplore)
                }
                
                DispatchQueue.main.async {
                    handler(true)
                }
        }
    }
    
    func uploadStacks(data: Stack, handler: @escaping SuccessHandler) {
        let value = data.dictionary
        baseReference
            .child(GlobalState.Constants.Users.rawValue)
            .child(GlobalState.shared.uuid).childByAutoId()
            .updateChildValues(value) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    handler(false)
                }else {
                    print("SUCCESS")
                    handler(true)
                }
        }
    }
    
    func fetchUserStacks(handler: @escaping SuccessHandler) {
        baseReference
            .child(GlobalState.Constants.Users.rawValue)
            .child(GlobalState.shared.uuid)
            .observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                GlobalState.shared.stacks = []
                for (_,value) in dictionary {
                    guard let stackDict = value as? [String:String] else { return }
                    guard let newStack = Stack(with: stackDict) else { return }
                    GlobalState.shared.stacks.append(newStack)
                }
                DispatchQueue.main.async {
                    NotificationCenter.default
                        .post(name: NSNotification.Name.newStack, object: nil)
                    handler(true)
                }
        }
    }
}
