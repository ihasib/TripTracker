//
//  LoginViewController.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/23/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import Firebase

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
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
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
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - selectors
    
    @objc func handleSignup() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Log in failed with error \(error)")
            }
            print("Login successful")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - configure UI
    func configureUI() {
        configureNavigationBar()
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
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.barStyle = .black
    }
}
