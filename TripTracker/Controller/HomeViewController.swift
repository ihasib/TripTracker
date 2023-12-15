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
import GeoFire


//let currentLocation = CLLocation(latitude: 40.120001, longitude: -74.586643)//Philadelphia
//let currentLocation = CLLocation(latitude: 40.74680853726964, longitude: -73.98468457406955)//Empire state building newyork
let currentLocation = LocationHandler.shared.locationManager.location

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier = "annotationIdentifier"

enum ActionButtonState {
    ///displaying menu button
    case menu
    ///displaying dismissal/back button
    case dismiss
    init() {
        self = .menu
    }
}
class HomeViewController: UIViewController {
    
    // MARK: - properties
    private static let TAG = "HomeViewController"
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let locationInputViewHeight: CGFloat = 200
    private let rideActionViewHeight: CGFloat = 300
    private var actionButtonState = ActionButtonState()
    private var routeToSelectedDestination: MKRoute?
    private let rideActionView = RideActionView()


    private let signOutButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Sign Out"
        button.backgroundColor = .brown
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private let signOutF: UILabel = {
        let button = UILabel()
        button.backgroundColor = .brown
        button.text = "df"
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "baseline_menu_black_36dp")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleSideMenu), for: .touchUpInside)
        return button
    }()
    
    private var user: User? {
        didSet { locationInputView.user = user}
    }
    
    private var searchResults = [MKPlacemark]()
    
    // MARK: - Lifecycle
    
    @objc func test() {
        signOutF.text = signOutF.text!+"d"
    }
    
    override func viewDidLoad() {
        LocationHandler.shared.delegate = self
        LocationHandler.shared.locationManager.startUpdatingLocation()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(test), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        enableLocationServices()
        tryToTriggerCredentialPage()
        view.backgroundColor = .blue
        //signout()
    }

    func fetchCurrentUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            Log.debug(tag: HomeViewController.TAG, function: #function, msg: "No current user")
            return
        }
        Service.shared.fetchUserData(uid: currentUserId) {user in
            self.user = user
        }
    }
    
    func fetchDrivers() {
        guard let location = locationManager?.location else {
            Log.debug(tag: HomeViewController.TAG, function: #function, msg: "current user location error \(String(describing: locationManager))")
            return
        }
//        let location = currentLocation
        Log.debug(tag: HomeViewController.TAG, function: #function, msg: "current user location = \(String(describing: location))")
        Service.shared.fetchDrivers(location: location) { (driver) in
            Log.debug(tag: HomeViewController.TAG, function: #function, msg: " driver: \(driver)")
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
        Log.debug(tag: HomeViewController.TAG, function: #function)
        if Auth.auth().currentUser?.uid == nil {
            return true
        }
        return false
    }
    
    //MARK: - Action Handlers

    @objc func handleSideMenu() {
        switch actionButtonState {
            case .menu:
                print("menu")
            case .dismiss:
                print("dismiss")
                UIView.animate(withDuration: 0.5) {
                    self.locationInputActivationView.alpha = 1
                    self.setActionButtonState(state: .menu)
                    self.animateRideActionView(shouldShow: false)
                }
//                if let deleteAnnotation = lastSelectedAnnotation {
//                    mapView.removeAnnotation(deleteAnnotation)
//                }
                removeAnnotationAndOverlays()
        }
    }

    @objc func signOut() {
        Log.debug(tag: HomeViewController.TAG, function: #function)
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
    
    //MARK: - Helper functions

    func tryToTriggerCredentialPage() {
        Log.debug(tag: HomeViewController.TAG, function: #function)
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
    
    private func setActionButtonState(state: ActionButtonState) {
        switch state {
            case .menu:
                let image = #imageLiteral(resourceName: "baseline_menu_black_36dp")
                self.actionButton.setImage(image, for: .normal)
                self.actionButtonState = .menu
            case .dismiss:
                let image = #imageLiteral(resourceName: "baseline_arrow_back_black_36dp")
                actionButton.setImage(image, for: .normal)
                actionButtonState = .dismiss
        }
    }

    func configureUI() {
        Log.debug(tag: HomeViewController.TAG, function: #function)
        configureNavigationBar()
        configureMapView()
        configureTableView()
        configureLocationInputView()
        configureRideActionView()

        view.addSubview(actionButton)
        actionButton.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, topPadding: 20,
                            leftAnchor: view.leftAnchor, leftPadding: 20,
                            heightConstant: 30, widthConstant: 30)

        view.addSubview(locationInputActivationView)
        locationInputActivationView.anchor(topAnchor: actionButton.bottomAnchor,
                                           topPadding: 15, leftAnchor: view.leftAnchor,
                                           leftPadding: 20, rightAnchor: view.rightAnchor,
                                           rightPadding: 20, heightConstant: 40)
        locationInputActivationView.alpha = 0.0
        UIView.animate(withDuration: 2) {
            self.locationInputActivationView.alpha = 1.0
        }

        view.addSubview(signOutButton)
        signOutButton.anchor(topAnchor: view.topAnchor, topPadding: 30, rightAnchor: view.rightAnchor, rightPadding: 20, heightConstant: 30, widthConstant: 60)
        view.addSubview(signOutF)
        signOutF.anchor(topAnchor: view.topAnchor, topPadding: 100, rightAnchor: view.rightAnchor,
                             rightPadding: 20, heightConstant: 100, widthConstant: 120)
        locationInputActivationView.delegate = self
        locationInputView.delegate = self


        print("set location")
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
//        let location = CLLocation(latitude: 23.7493346, longitude: 90.407290)//mogbazar
//        let location2 = CLLocation(latitude: 23.748456, longitude: 90.357775)//bosilla
        let location = CLLocation(latitude: 40.675914864175525, longitude: -73.94835315091801) //Brooklyn
        let location2 = CLLocation(latitude: 40.72461718933766, longitude: -74.04503021975974) //Jersey city
        geofire.setLocation(location, forKey: "S1kpdkMca4YtWol7nCPrIQSSpGk1")
        geofire.setLocation(location2, forKey: "zf7mq3rPyAhUuAquUh0J8tgMxDk1")
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
        configureLocationInputView()//since it's removed while dismissal
        UIView.animate(withDuration: 0.7) {
            self.locationInputActivationView.alpha = 0
            self.locationInputView.alpha = 1
            self.tableView.frame.origin.y = self.locationInputView.frame.origin.y + self.locationInputView.frame.size.height
        }
    }

    func configureRideActionView() {
        view.addSubview(rideActionView)
        rideActionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: rideActionViewHeight)
        rideActionView.delegate = self
    }

    func animateRideActionView(shouldShow: Bool, selectedDestinationPlacemark: MKPlacemark? = nil) {
        let originY = shouldShow ? view.frame.height-rideActionViewHeight : view.frame.height
        if let placemark = selectedDestinationPlacemark {
            rideActionView.destinationPlacemark = placemark
        }
        UIView.animate(withDuration: 0.5) {
            self.rideActionView.frame.origin.y = originY
        }
    }

    //MARK: Map View Helpers
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true//show blue circle
        mapView.userTrackingMode = .followWithHeading // zoom in to the actual place: follow, heading refers to directional shadow
        mapView.delegate = self
    }

    func generatePolyLine(from source: MKMapItem, to destination: MKMapItem) {//MKMapItem: name, timezone, phonenumber, url, placemark
        //MKDirections.Request(): requesting apple server for travel route for walk or drive
        print(#function)
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .walking

        let directionRequest = MKDirections(request: request)
        directionRequest.calculate{ (response, error) in
            guard let response = response else {
                print("error = \(error?.localizedDescription)")
                return
            }
            self.routeToSelectedDestination = response.routes[0]
            if let route = self.routeToSelectedDestination {
                let polyline = route.polyline
                self.mapView.addOverlay(polyline)
//                let projectedRect = MKMapRect(origin: MKMapPoint(x: polyline.boundingMapRect.origin.x+30, y: polyline.boundingMapRect.origin.y+30) , size: MKMapSize(width: polyline.boundingMapRect.width+25.0, height: polyline.boundingMapRect.height+25.0))
//                self.mapView.setRegion(MKCoordinateRegion(projectedRect), animated: true)
            }
        }
    }

    func removeAnnotationAndOverlays() {
        mapView.annotations.forEach { mkAnnotation in
            //drivers are added as MKAnnotation, selected row of table are added as MKPointAnnotation
//                    if let mkPointAnnotation = mkAnnotation as? MKPointAnnotation {
//                        mapView.removeAnnotation(mkPointAnnotation)
            if let driver = mkAnnotation as? DriverAnnotation {
                return
            }
            mapView.removeAnnotation(mkAnnotation)
//          }
        }
        mapView.overlays.forEach { overlay in
            mapView.removeOverlay(overlay)
        }
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
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil)  {
        UIView.animate(withDuration: 0.7, animations: {
            self.locationInputView.alpha = 0
            self.locationInputView.removeFromSuperview()//dismiss responder chain to dismiss keyboard
            self.tableView.frame.origin.y = self.view.frame.height
        }, completion: completion)
    }
}

    //MARK: Extensions for delegates

extension HomeViewController {
    func enableLocationServices() {
        Log.debug(tag: HomeViewController.TAG, function: #function,msg: "\(CLLocationManager.authorizationStatus())")
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
        Log.debug(tag: HomeViewController.TAG, function: #function)
        searchBy(naturalLanguageQuery: queryText) { mkPlacemarks in
            self.searchResults = mkPlacemarks
            self.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView() {
        dismissLocationView { _ in
            UIView.animate(withDuration: 0.5) {
                self.locationInputActivationView.alpha = 1
            }
        }
    }
}

extension HomeViewController: RideActionViewDelegate {
    func uploadTrip(with destination: CLLocationCoordinate2D) {
        print(#function)
        guard let curLocation = LocationHandler.shared.locationManager?.location?.coordinate else {
            print("error = current location not found")
            return
        }
        Service.shared.uploadTrip(curLocation, destination)
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
                Log.debug(tag: HomeViewController.TAG, function: #function, msg: "mapItems error = \(error?.localizedDescription)")
                return
            }
            response.mapItems.forEach( { item in
                Log.debug(tag: HomeViewController.TAG, function: #function, msg: "mapItems = \(String(describing: item.name))")
                plcaemarks.append(item.placemark)
            })
            completion(plcaemarks)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Title"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
//        return searchResults.count == 0  ? 2 : searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        let h = indexPath.section 
        if indexPath.section == 0 {
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.debug(tag: HomeViewController.TAG, function: #function, msg: "didSelectRowAt \(indexPath.row)")
        let selectedPlacemark = searchResults[indexPath.row]
        setActionButtonState(state: .dismiss)
        let mapItem = MKMapItem(placemark: selectedPlacemark)
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: locationManager?.location?.coordinate ?? CLLocationCoordinate2D()))
        self.generatePolyLine(from: sourceItem, to: mapItem)
        dismissLocationView() {_ in
            Log.debug(tag: HomeViewController.TAG, function: #function, msg: "inside of dismissLocationView selectedPlacemark = \(selectedPlacemark)")

            //MKPlacemark consist of country, region, street, city, street address. conforms to annotation
            //annotation consist of co-ordinate,title,subtitle
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)//animate(moving with larger icon)  at first glance

            let annotations = self.mapView.annotations.filter { !$0.isKind(of: DriverAnnotation.self) }
//            self.mapView.showAnnotations(annotations, animated: true)
            UIView.animate(withDuration: 0.5) {
                self.mapView.zoomToFit(annotations: annotations)
            }
            self.animateRideActionView(shouldShow: true, selectedDestinationPlacemark: selectedPlacemark)
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
//   if you want to display content at a specific point on the map, add an annotation object to the map view.
//   When the annotation’s coordinate is visible on the map, the map view asks its delegate to provide an appropriate view to display any content associated with the annotation.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            Log.debug(tag: HomeViewController.TAG, function: #function, msg: "annotaion = \(annotation)")
            return view
        }
        Log.debug(tag: HomeViewController.TAG, function: #function, msg: " No annotaion returned")
        return nil
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = routeToSelectedDestination {
            let renderer = MKPolylineRenderer(overlay: route.polyline)
            renderer.lineWidth = 4
            renderer.strokeColor = .red
            return renderer
        }
        return MKOverlayRenderer()

    }
}

protocol LocDelegate {
    func fu()
}
extension HomeViewController: LocDelegate {
    func fu() {
        self.dismiss(animated: true)
    }
}
