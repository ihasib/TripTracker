//
//  LocationInputView.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/25/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
    func executeSearch(queryText: String)
}

class LocationInputView: UIView {
    // MARK: - properties
    private static let TAG = "LocationInputView"
    weak var delegate: LocationInputViewDelegate?
    
    var user: User? {
        didSet {titleLabel.text = user?.fullname}
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hasibur Rahman"
        label.font = UIFont(name: "Avenir-Light", size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal) ,for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let locationConnectorIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let destinationLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let startLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Location"
        textField.isEnabled = false
        textField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.frame.size.height = 30
        paddingView.frame.size.width = 8
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Location you want to go"
        textField.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        textField.returnKeyType = .search
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.delegate = self
        
        let paddingView = UIView()
        paddingView.frame.size.height = 30
        paddingView.frame.size.width = 8
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // MARK: - initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadowEffect()
        
        addSubview(backButton)
        backButton.anchor(topAnchor: topAnchor,  leftAnchor: leftAnchor,
                          heightConstant: 24, widthConstant: 24)
        addSubview(titleLabel)
        titleLabel.anchor(centerXParentView: self, centerYParentView: backButton)
        addSubview(startLocationTextField)
        startLocationTextField.anchor(topAnchor: titleLabel.bottomAnchor, topPadding: 15,
                                      leftAnchor: leftAnchor, leftPadding: 30,
                                      rightAnchor: rightAnchor, rightPadding: 20, heightConstant: 30)
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(topAnchor: startLocationTextField.bottomAnchor,
                                            topPadding: 15,leftAnchor: startLocationTextField.leftAnchor,
                                            rightAnchor: startLocationTextField.rightAnchor, heightConstant: 30)
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.anchor(leftAnchor: leftAnchor, leftPadding: 15, heightConstant: 6,
                                          widthConstant: 6, centerYParentView: startLocationTextField)
        addSubview(destinationLocationIndicatorView)
        destinationLocationIndicatorView.anchor(leftAnchor: leftAnchor, leftPadding: 15, heightConstant: 6,
                                          widthConstant: 6, centerYParentView: destinationLocationTextField)
        addSubview(locationConnectorIndicatorView)
        locationConnectorIndicatorView.anchor(topAnchor: startLocationIndicatorView.bottomAnchor,
                                              topPadding: 3, bottomAnchor: destinationLocationIndicatorView.topAnchor,
                                              bottomPadding: 3, widthConstant: 2,
                                              centerXParentView: startLocationIndicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - selectors
    @objc func handleBackButton() {
        delegate?.dismissLocationInputView()
    }
}

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return false}
        Log.debug(tag: LocationInputView.TAG, function: #function, msg: "textFieldShouldReturn")
        delegate?.executeSearch(queryText: text)
        return true
    }
    
}
