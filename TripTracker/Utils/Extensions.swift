//
//  Extensions.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 6/23/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

import UIKit
import MapKit

extension UIView {
    
    func getViewWithContainerView(image: UIImage, textField: UITextField? = nil, segmentedControl: UISegmentedControl? = nil) -> UIView {
        Log.debug(tag: "UIView", function: #function)
        let view = UIView()
        view.backgroundColor = .black
        let imageView = UIImageView()
        imageView.image = image
        
        
        view.addSubview(imageView)
        
        if let textField = textField {
            imageView.anchor(leftAnchor: view.leftAnchor, heightConstant: 24, widthConstant: 24,
                             centerYParentView: view)
            
            view.addSubview(textField)
            textField.anchor(leftAnchor: imageView.rightAnchor, leftPadding: 10,
                             rightAnchor: view.rightAnchor,  centerYParentView: view)
        }
        if let segmentedControl = segmentedControl {
            imageView.anchor(topAnchor: view.topAnchor,leftAnchor: view.leftAnchor,
                             heightConstant: 24, widthConstant: 24)
            view.addSubview(segmentedControl)
            segmentedControl.anchor(topAnchor: imageView.bottomAnchor, topPadding: 5,
                                    bottomAnchor: view.bottomAnchor, bottomPadding: 5,
                                    leftAnchor: view.leftAnchor,
                                    rightAnchor: view.rightAnchor)
        }
        let separatorView = UIView()
        view.addSubview(separatorView)
        separatorView.backgroundColor = .white
        separatorView.anchor(bottomAnchor: view.bottomAnchor, leftAnchor: view.leftAnchor,
                             rightAnchor: view.rightAnchor, heightConstant: 0.75)
        
        return view
    }
    
    func addShadowEffect() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.95
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    
    func anchor(topAnchor: NSLayoutYAxisAnchor? = nil,
                topPadding: CGFloat = 0,
                bottomAnchor: NSLayoutYAxisAnchor? = nil,
                bottomPadding: CGFloat = 0,
                leftAnchor: NSLayoutXAxisAnchor? = nil,
                leftPadding: CGFloat = 0,
                rightAnchor: NSLayoutXAxisAnchor? = nil,
                rightPadding: CGFloat = 0,
                heightConstant: CGFloat? = nil,
                widthConstant: CGFloat? = nil,
                centerXParentView: UIView? = nil,
                centerYParentView: UIView? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topPadding).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding).isActive = true
        }
        
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftPadding).isActive = true
        }
        
        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: -rightPadding).isActive = true
        }
        
        if let height = heightConstant {
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


extension UITextField {
    func getFieldWithExtraFeature(textLabel: String, isSecured: Bool) -> UITextField{
        textColor = .white
        font = UIFont.systemFont(ofSize: 16)
        keyboardAppearance = .dark
        isSecureTextEntry = isSecured
        attributedPlaceholder = NSAttributedString(string: textLabel,
                                                   attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return self
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
    static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 237)
}


extension MKPlacemark {
    var address: String? {
        get {
            guard let subThoroughfare = subThoroughfare else { return nil}
            guard let thoroughfare = thoroughfare else { return nil}
            guard let locality = locality else { return nil}
            guard let adminArea = administrativeArea else { return nil}
            
            return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea)"
        }
    }
}
