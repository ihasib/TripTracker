//
//  RideActionView.swift
//  TripTracker
//
//  Created by S M Hasibur Rahman on 21/11/23.
//  Copyright © 2023 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import MapKit

protocol RideActionViewDelegate {
    func uploadTrip(with destination: CLLocationCoordinate2D)
}

class RideActionView: UIView {
    //MARK: properties

    var delegate: RideActionViewDelegate?

    var destinationPlacemark: MKPlacemark? {
        didSet {
            titleLabel.text = destinationPlacemark?.name
            addressLabel.text = destinationPlacemark?.address
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Address Title"
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Newyork"
        return label
    }()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black

        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40)
        label.text = "X"

        view.addSubview(label)
        label.anchor(centerXParentView: view, centerYParentView: view)
        return view
    }()

    private let uberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "UBER X"
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CONFIRM UBERX", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: action handler

    @objc func confirmButtonTapped() {
        print(#function)
        guard let destinationCoordinate = destinationPlacemark?.coordinate else {
            print("error destinationCoordinate NIL")
            return
        }
        delegate?.uploadTrip(with: destinationCoordinate)
    }

    //MARK: lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(topAnchor: self.topAnchor, topPadding: 10, centerXParentView: self)
        addSubview(infoView)
        infoView.anchor(topAnchor: stack.bottomAnchor, topPadding: 30, heightConstant: 70, widthConstant: 70, centerXParentView: self)
        infoView.layer.cornerRadius = 70/2
        addSubview(uberLabel)
        uberLabel.anchor(topAnchor: infoView.bottomAnchor, topPadding: 30, centerXParentView: self)
        addSubview(separatorView)
        separatorView.anchor(topAnchor: uberLabel.bottomAnchor, topPadding: 10, leftAnchor: self.leftAnchor, leftPadding: 15, rightAnchor: self.rightAnchor, rightPadding: 15, heightConstant: 2)
        addSubview(confirmButton)
        confirmButton.anchor(topAnchor: separatorView.bottomAnchor, topPadding: 15, leftAnchor: self.leftAnchor, leftPadding: 40, rightAnchor: self.rightAnchor, rightPadding: 40)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
