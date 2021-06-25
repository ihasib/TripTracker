//
//  Service.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/25/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")


struct Service {
    static let shared = Service()
    let currentUserId = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping(User)->()) {
        REF_USERS.child(currentUserId!).observeSingleEvent(of: .value) { (snapshot) in
            print(self.currentUserId!)
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            print(dictionary)
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
