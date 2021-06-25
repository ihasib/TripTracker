//
//  LocationCell.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/25/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    // MARK: - properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Shikder bari"
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Shikder bari, Road no 1"
        return label
    }()
    
    // MARK: - initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.anchor(leftAnchor: leftAnchor, leftPadding: 15, centerYParentView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
