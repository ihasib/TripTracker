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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TRIP TRACKER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1.0, alpha: 0.8)
        return label
    }()
    
    private let emailTextField = UITextField().getFieldWithExtraFeature(textLabel: "Email", isSecured: false)
    private let passwordTextField = UITextField().getFieldWithExtraFeature(textLabel: "Password", isSecured: true)
    private lazy var emailContainerView = UIView().getViewWithContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"),textField: emailTextField)
    private lazy var passwordContainerView = UIView().getViewWithContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        let titleFirstPart = NSMutableAttributedString(string: "Don't have an Account?", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray])
        let titleSecondPart = NSMutableAttributedString(string: " SignUp", attributes:
        [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSMutableAttributedString.Key.foregroundColor: UIColor.mainBlueTint])
        
        titleFirstPart.append(titleSecondPart)
        button.setAttributedTitle(titleFirstPart, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, centerXParentView: view)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.anchor(topAnchor: titleLabel.bottomAnchor, topPadding: 50,
                         leftAnchor: view.leftAnchor, leftPadding: 30,
                         rightAnchor: view.rightAnchor, rightPadding: 30)
        
        view.addSubview(signupButton)
        signupButton.anchor(bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomPadding: 20,
                            leftAnchor: view.leftAnchor, leftPadding: 30,
                            rightAnchor: view.rightAnchor, rightPadding: 30)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
