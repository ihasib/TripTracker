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
private let annotationIdentifier = "annotationIdentifier"
class HomeViewController: UIViewController {
    
    // MARK: - properties
    private let TAG = "HomeViewController"
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let locationInputViewHeight: CGFloat = 200
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Sign Out"
        button.backgroundColor = .brown
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private var user: User? {
        didSet { locationInputView.user = user}
    }
    
    private var searchResults = [MKPlacemark]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        
        tryToTriggerCredentialPage()
        view.backgroundColor = .blue
        //signout()
    }

    func fetchCurrentUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            Log.debug(tag: TAG, function: #function, msg: "No current user")
            return
        }
        Service.shared.fetchUserData(uid: currentUserId) {user in
            self.user = user
        }
    }
    
    func fetchDrivers() {
        guard let location = locationManager?.location else {
            Log.debug(tag: TAG, function: #function, msg: "current user location error \(String(describing: locationManager))")
            return
        }
        Log.debug(tag: TAG, function: #function, msg: "current user location = \(String(describing: location))")
        Service.shared.fetchDrivers(location: location) { (driver) in
            Log.debug(tag: self.TAG, function: #function, msg: " driver: \(driver)")
            guard let coordinate = driver.location?.coordinate else {return}
            
            let driverAnnotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            print("annotation = \(driverAnnotation.coordinate)")
            
            var isDriverAddedToAnnotationList: Bool {
                self.mapView.annotations.contains(where: { annotation -> Bool in
                    if let annotation = annotation as? DriverAnnotation {
                        if(annotation.uid == driver.uid) {
                            annotation.updateCoordinate(coordinate: coordinate)
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                            return true
                        }
                    }
                    return false
                })
            }
            
            if (!isDriverAddedToAnnotationList) {
                self.mapView.addAnnotation(driverAnnotation)
            }
        }
    }
    
    func isUserLoggedOut() -> Bool{
        Log.debug(tag: TAG, function: #function)
        if Auth.auth().currentUser?.uid == nil {
            return true
        }
        return false
    }
    
    @objc func signOut() {
        Log.debug(tag: TAG, function: #function)
        signout()
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            tryToTriggerCredentialPage()
        } catch {
            print("sigining out failed \(error)")
        }
    }
    
    func tryToTriggerCredentialPage() {
        Log.debug(tag: TAG, function: #function)
        if isUserLoggedOut() {
            let loginVC = LoginViewController()
            loginVC.homeVC = self
            let nav = UINavigationController(rootViewController: loginVC)
            nav.isModalInPresentation = true
            present(nav, animated: false, completion: nil)
        } else {
            configureUIAndData()
        }
    }
    
    func configureUIAndData() {
        configureUI()
        fetchCurrentUser()
        fetchDrivers()
    }
    
    func configureUI() {
        Log.debug(tag: TAG, function: #function)
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
        
        view.addSubview(signOutButton)
        signOutButton.anchor(topAnchor: view.topAnchor, topPadding: 30, rightAnchor: view.rightAnchor, rightPadding: 20, heightConstant: 30, widthConstant: 60)
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
        mapView.delegate = self
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

    //MARK: extensions for delegates

extension HomeViewController {
    func enableLocationServices() {
        Log.debug(tag: TAG, function: #function,msg: "\(CLLocationManager.authorizationStatus())")
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                print("notDetermined")
                locationManager?.requestWhenInUseAuthorization()
            case .restricted, .denied:
                print("restricted  denied")
            case .authorizedAlways:
                print("authorizedAlways")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
                locationManager?.requestAlwaysAuthorization()
            default:
                break
        }
    }
}


extension HomeViewController: LocationInputActivationViewDelegate {
    func showLocationInputActivationView() {
        showLocationInputView()
    }
}

extension HomeViewController: LocationInputViewDelegate {
    func executeSearch(queryText: String) {
        Log.debug(tag: TAG, function: #function)
        searchBy(naturalLanguageQuery: queryText) { mkPlacemarks in
            self.searchResults = mkPlacemarks
            self.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView() {
        UIView.animate(withDuration: 1, animations: {
            self.locationInputView.alpha = 0
            self.locationInputActivationView.alpha = 1
            self.tableView.frame.origin.y = self.view.frame.height
        })
    }
}

extension HomeViewController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark])->Void) {
        var plcaemarks = [MKPlacemark]()
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start {(response, error) in
            guard let response = response else {
                Log.debug(tag: self.TAG, function: #function, msg: "mapItems error")
                return
            }
            response.mapItems.forEach( { item in
                Log.debug(tag: self.TAG, function: #function, msg: "mapItems = \(String(describing: item.name))")
                plcaemarks.append(item.placemark)
            })
            completion(plcaemarks)
        }
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
        return section == 0  ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            Log.debug(tag: TAG, function: #function, msg: "annotaion = \(annotation)")
            return view
        }
        Log.debug(tag: TAG, function: #function, msg: " No annotaion returned")
        return nil
    }
}
