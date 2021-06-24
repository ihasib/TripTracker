//
//  HomeViewController.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/24/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HomeViewController: UIViewController {
    
    // MARK: - properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        locationManager.delegate = self
        configureUI()
        if isUserLoggedOut() {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.isModalInPresentation = true
            present(nav, animated: false, completion: nil)
        }
        view.backgroundColor = .blue
        
        //signout()
    }

    func isUserLoggedOut() -> Bool{
        if Auth.auth().currentUser?.uid == nil {
            return true
        }
        return false
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("sigining out failed \(error)")
        }
    }
    
    func configureUI() {
        configureMapView()
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
}


extension HomeViewController {
    func enableLocationServices() {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                print("notDetermined")
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                print("restricted  denied")
            case .authorizedAlways:
                print("authorizedAlways")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
                locationManager.requestAlwaysAuthorization()
            default:
                break
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
