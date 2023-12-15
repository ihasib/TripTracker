//
//  LocationHandler.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 7/11/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import CoreLocation
import GeoFire
import FirebaseAuth

class LocationHandler: NSObject, CLLocationManagerDelegate{
    static let TAG = "LocationHandler"
    static let shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    var delegate: LocDelegate?
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        REF_USERS.child(Auth.auth().currentUser?.uid).updateChildValues(userPropertyValues) { (error, ref) in
//            print("User successfully registered")
//            self.homeVC?.configureUIAndData()
//            self.dismiss(animated: true, completion: nil)
//        }
        
//        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
//        Log.debug(tag: LocationHandler.TAG, function: #function, msg: "location change notification")
        
        
//        geofire.setLocation(locations.first, forKey: Auth.auth().currentUser?.uid, withCompletionBlock: {(error) in
//            if let error = error {
//                print("error = \(error)")
//                return
//            }
//        })
    }
}
