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

private let reuseIdentifier = "LocationCell"
class HomeViewController: UIViewController {
    
    // MARK: - properties
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let locationInputViewHeight: CGFloat = 200
    
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
        configureTableView()
        configureLocationInputView()
        
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
                                 heightConstant: locationInputViewHeight)
        locationInputView.alpha = 0
    }
    
    func showLocationInputView() {
        UIView.animate(withDuration: 1) {
            self.locationInputActivationView.alpha = 0
            self.locationInputView.alpha = 1
            self.tableView.frame.origin.y = self.locationInputView.frame.origin.y + self.locationInputView.frame.size.height
        }
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        let tableViewHeight = view.safeAreaLayoutGuide.layoutFrame.height - locationInputView.frame.size.height
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: tableViewHeight)
        view.addSubview(tableView)
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
        showLocationInputView()
    }
}

extension HomeViewController: LocationInputViewDelegate {
    func dismissLocationInputView() {
        UIView.animate(withDuration: 1, animations: {
            self.locationInputView.alpha = 0
            self.locationInputActivationView.alpha = 1
            self.tableView.frame.origin.y = self.view.frame.height
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Title"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        return cell
    }
    
    
}
