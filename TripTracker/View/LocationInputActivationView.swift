//
//  LocationInputActivationView.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/24/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

protocol LocationInputActivationViewDelegate: class {
    func showLocationInputActivationView()
}
class LocationInputActivationView: UIView {

    // MARK: -properties
    weak var delegate: LocationInputActivationViewDelegate?
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.textColor = .darkGray
        return label
    }()

    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadowEffect()
        addSubview(indicatorView)
        indicatorView.anchor(leftAnchor: self.leftAnchor, leftPadding: 10, heightConstant: 5,
                             widthConstant: 5, centerYParentView: self)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(topAnchor: self.topAnchor, bottomAnchor: self.bottomAnchor,
                                leftAnchor: indicatorView.rightAnchor, leftPadding: 15,
                                rightAnchor: self.rightAnchor, centerYParentView: self)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleShowLocationInputView))
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - selectors
    @objc func handleShowLocationInputView() {
        delegate?.showLocationInputActivationView()
    }
}
