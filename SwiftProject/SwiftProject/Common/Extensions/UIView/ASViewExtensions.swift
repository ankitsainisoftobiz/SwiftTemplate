//
//  ASViewExtensions.swift
//  LowRateInsuranceAgency
//
//  Created by softobiz on 1/16/18.
//  Copyright © 2018 Ankit_Saini. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func centerEdgesToSuperview(width: CGFloat = 0, height: CGFloat = 0, toView: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if width > 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height > 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: toView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: toView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    //
    //Bind constraints to superview
    //
    func anchorAllEdgesToSuperview() {
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            addSuperviewConstraint(constraint: topAnchor.constraint(equalTo: superview!.topAnchor))
            addSuperviewConstraint(constraint: leftAnchor.constraint(equalTo: superview!.leftAnchor))
            addSuperviewConstraint(constraint: bottomAnchor.constraint(equalTo: superview!.bottomAnchor))
            addSuperviewConstraint(constraint: rightAnchor.constraint(equalTo: superview!.rightAnchor))
        } else {
            for attribute: NSLayoutConstraint.Attribute in [.left, .top, .right, .bottom] {
                anchorToSuperview(attribute: attribute)
            }
        }
    }
    
    func anchorToSuperview(attribute: NSLayoutConstraint.Attribute) {
        addSuperviewConstraint(constraint: NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: superview, attribute: attribute, multiplier: 1.0, constant: 0.0))
    }
    
    func addSuperviewConstraint(constraint: NSLayoutConstraint) {
        superview?.addConstraint(constraint)
    }
}

// MARK: - UIView + Constraints
//
extension UIView {
    
    @discardableResult func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func heightAnchor(equalTo height: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult func widthAnchor(equalTo height: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
}


//
//MARK:- ROTATION
//

extension UIView {
    
    func rotate(radians: CGFloat, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        } else {
            transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
