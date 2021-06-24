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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if isUserLoggedOut() {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.isModalInPresentation = true
            present(nav, animated: false, completion: nil)
        }
        view.backgroundColor = .blue
        
        signout()
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
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
}
