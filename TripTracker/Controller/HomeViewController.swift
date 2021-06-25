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
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        locationManager.delegate = self
        configureUI()
        triggerCredentialPage()
        
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
    
    func triggerCredentialPage() {
        if isUserLoggedOut() {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.isModalInPresentation = true
            present(nav, animated: false, completion: nil)
        }
    }
    
    func configureUI() {
        configureNavigationBar()
        configureMapView()
        
        view.addSubview(locationInputActivationView)
        locationInputActivationView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                           topPadding: 15, leftAnchor: view.leftAnchor,
                                           leftPadding: 20, rightAnchor: view.rightAnchor,
                                           rightPadding: 20, heightConstant: 40)
        locationInputActivationView.alpha = 0.0
        UIView.animate(withDuration: 2) {
            self.locationInputActivationView.alpha = 1.0
        }
        locationInputActivationView.delegate = self
        locationInputView.delegate = self
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                 leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor,
                                 heightConstant: 200)
        UIView.animate(withDuration: 1){
            self.locationInputActivationView.alpha = 0
            self.locationInputView.alpha = 1
        }
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

extension HomeViewController: LocationInputActivationViewDelegate {
    func showLocationInputActivationView() {
        configureLocationInputView()
    }
}

extension HomeViewController: LocationInputViewDelegate {
    func dismissLocationInputView() {
        UIView.animate(withDuration: 1, animations: {
            self.locationInputView.alpha = 0
            self.locationInputActivationView.alpha = 1
        })
    }
}
