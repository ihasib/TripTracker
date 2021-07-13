//
//  DriverAnnotation.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 7/12/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D//"dynamic" makes MKAnnotation a observer:  whenever coordinate of an annotation is set with a value, annotation gets redrawn
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
    
    func updateCoordinate(coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}
