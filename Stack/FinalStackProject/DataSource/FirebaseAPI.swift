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
}
