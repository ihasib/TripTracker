//
//  LoginViewController.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/23/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TRIP TRACKER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1.0, alpha: 0.8)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, centerXParentView: view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
