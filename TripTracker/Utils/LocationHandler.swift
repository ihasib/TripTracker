//
//  LocationHandler.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 7/11/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate{
    static let shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
    }
}
