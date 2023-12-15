//
//  Trip.swift
//  TripTracker
//
//  Created by S M Hasibur Rahman on 6/12/23.
//  Copyright © 2023 S. M. Hasibur Rahman. All rights reserved.
//

import CoreLocation

struct Trip {
    var pickupCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!

    let passengerUid: String
    var driverUid: String?
    var state: TripState!

    init(passengerUid: String, dictionary: [String:Any]) {
        self.passengerUid = passengerUid
        if let pickupCoordinate = dictionary["pickupCoordinate"] as? NSArray {
            guard let lat = pickupCoordinate[0] as? CLLocationDegrees else { return }
            guard let long = pickupCoordinate[1] as? CLLocationDegrees else { return }
            self.pickupCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }

        if let destinationCoordinate = dictionary["destinationCoordinate"] as? NSArray {
            guard let lat = destinationCoordinate[0] as? CLLocationDegrees else { return }
            guard let long = destinationCoordinate[1] as? CLLocationDegrees else { return }
            self.destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }

        let driverUid = dictionary["driverUid"] as? String ?? ""
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        }
    }
}

enum TripState: Int {
    case requested, accepted, inProgress, completed
}
