//
//  Extensions.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/23/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(topAnchor: NSLayoutYAxisAnchor? = nil,
                bottomAnchor: NSLayoutYAxisAnchor? = nil,
                leftAnchor: NSLayoutXAxisAnchor? = nil,
                rightAnchor: NSLayoutXAxisAnchor? = nil,
                topPadding: CGFloat = 0,
                bottomPadding: CGFloat = 0,
                leftPadding: CGFloat = 0,
                rightPadding: CGFloat = 0,
                heigtConstant: CGFloat? = nil,
                widthConstant: CGFloat? = nil,
                centerXParentView: UIView? = nil,
                centerYParentView: UIView? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topPadding).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding).isActive = true
        }
        
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftPadding).isActive = true
        }
        
        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightPadding).isActive = true
        }
        
        if let height = heigtConstant {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = widthConstant {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let centerXParentView = centerXParentView {
            self.centerXAnchor.constraint(equalTo: centerXParentView.centerXAnchor).isActive = true
        }
        
        if let centerYParentView = centerYParentView {
            self.centerYAnchor.constraint(equalTo: centerYParentView.centerYAnchor).isActive = true
        }
        
    }
}
