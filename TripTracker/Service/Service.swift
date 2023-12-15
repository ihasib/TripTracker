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
let REF_TRIPS = DB_REF.child("trips")


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
            let circularGeoQuery = geofire.query(at: location, withRadius: 125)
            circularGeoQuery.observe(.keyEntered, with: { (uid,location) in
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

    func uploadTrip(_ pickupCoordinate: CLLocationCoordinate2D, _ destinationCoordinate: CLLocationCoordinate2D) {
        print(#function)
        guard let uId = Auth.auth().currentUser?.uid else { return }
        let pickupLatLong = [pickupCoordinate.latitude, pickupCoordinate.longitude]
        let destLatLong = [destinationCoordinate.latitude, destinationCoordinate.longitude]
        let values = ["pickupCoordinate": pickupLatLong,
                      "destinationCoordinate": destLatLong,
                      "state": TripState.requested.rawValue] as [String : Any]

        REF_TRIPS.child(uId).updateChildValues(values) { error, ref in
            if let error = error {
                print("error = \(error.localizedDescription)")
                return
            }
        }
    }
}
