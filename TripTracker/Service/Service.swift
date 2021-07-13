//
//  Service.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/25/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")


struct Service {
    static let shared = Service()
    let currentUserId = Auth.auth().currentUser?.uid
    
    func fetchUserData(uid: String, completion: @escaping(User)->()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(self.currentUserId!)
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            print(dictionary)
            let user = User(uid: snapshot.key,dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User)->()) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        print("Hasib: start")
        REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
            print("Hasib: within")
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid,location) in
                print("Hasib: uid = \(uid)")
                print("Hasib: location = \(location.coordinate)")
                self.fetchUserData(uid: uid, completion: { (user) in
                    var driver = user
                    driver.location = location
                    completion(driver)
                })
            })
        }
    }
}
