//
//  SignupViewController.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/23/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TRIP TRACKER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1.0, alpha: 0.8)
        return label
    }()
    
    private let emailTextField = UITextField().getFieldWithExtraFeature(textLabel: "Email", isSecured: false)
    private let nameTextField = UITextField().getFieldWithExtraFeature(textLabel: "Full Name", isSecured: false)
    private let passwordTextField = UITextField().getFieldWithExtraFeature(textLabel: "Password", isSecured: true)
    private lazy var emailContainerView: UIView = {
        let view = UIView().getViewWithContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.anchor(heightConstant: 40)
        return view
    }()
    private lazy var nameContainerView: UIView = {
        let view = UIView().getViewWithContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: nameTextField)
        view.anchor(heightConstant: 40)
        return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = UIView().getViewWithContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.anchor(heightConstant: 40)
        return view
    }()
    private lazy var segmentedControlContainerView: UIView = {
        let view = UIView().getViewWithContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"),segmentedControl: accountTypeSegmentedControl)
        view.anchor(heightConstant: 60)
        return view
    }()
    lazy var accountTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Rider","Driver"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
//        button.anchor(heightConstant: 30)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let titleFirstPart = NSMutableAttributedString(string: "Already have an Account?", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray])
        let titleSecondPart = NSMutableAttributedString(string: " Sign In", attributes:
        [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSMutableAttributedString.Key.foregroundColor: UIColor.mainBlueTint])
        
        titleFirstPart.append(titleSecondPart)
        button.setAttributedTitle(titleFirstPart, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - targets
    @objc func handleSignin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignup() {
        guard let email = emailTextField.text else { return }
        guard let name = nameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let accountType = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result , error) in
            if let error = error {
                print("Failed too register user  error =\(error)")
                return
            }
            
            guard let homeVC = UIApplication.shared.keyWindow?.rootViewController as? HomeViewController else {return}
            homeVC.configureUI()
            let userPropertyValues = ["email": email, "fullname": name,
                                      "accountType": accountType] as [String: Any]
            guard let uid = result?.user.uid else {return}
            Database.database().reference().child("users").child(uid).updateChildValues(userPropertyValues) { (error, ref) in
                print("User successfully registered")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - configure UI
    // MARK: - configure UI
    func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, centerXParentView: view)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, nameContainerView,
                                                       passwordContainerView,
                                                       segmentedControlContainerView,signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.anchor(topAnchor: titleLabel.bottomAnchor, topPadding: 50,
                         leftAnchor: view.leftAnchor, leftPadding: 30,
                         rightAnchor: view.rightAnchor, rightPadding: 30)

        view.addSubview(loginButton)
        loginButton.anchor(bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomPadding: 20,
                            leftAnchor: view.leftAnchor, leftPadding: 30,
                            rightAnchor: view.rightAnchor, rightPadding: 30)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
