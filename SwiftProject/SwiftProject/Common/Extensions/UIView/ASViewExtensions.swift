//
//  ASViewExtensions.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Center the view to superview
    /// - Parameter width: CGFloat
    /// - Parameter height: CGFloat
    /// - Parameter toView: Parent UIView
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
    
    /// Bind constraints to superview
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
    
    /// Anchor all edges to superview with constants
    /// - Parameter top: CGFloat
    /// - Parameter left: CGFloat
    /// - Parameter bottom: CGFloat
    /// - Parameter right: CGFloat
    /// - Parameter width: CGFloat
    /// - Parameter height: CGFloat
    func anchorAllEdgesToSuperview(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            addSuperviewConstraint(constraint: topAnchor.constraint(equalTo: superview!.topAnchor, constant: top))
            addSuperviewConstraint(constraint: leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: left))
            if height > 0 {
                self.heightAnchor.constraint(equalToConstant: height).isActive = true
            } else {
                addSuperviewConstraint(constraint: bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: bottom))
            }
            
            if width > 0 {
                self.widthAnchor.constraint(equalToConstant: width).isActive = true
            } else {
                addSuperviewConstraint(constraint: rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: right))
            }
            
        } else {
            for attribute: NSLayoutConstraint.Attribute in [.left, .top, .right, .bottom] {
                anchorToSuperview(attribute: attribute)
            }
        }
    }
    
    /// Achors to superview
    /// - Parameter attribute: NSLayoutConstraint.Attribute
    func anchorToSuperview(attribute: NSLayoutConstraint.Attribute) {
        addSuperviewConstraint(constraint: NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: superview, attribute: attribute, multiplier: 1.0, constant: 0.0))
    }
    
    /// Add superview constraints
    /// - Parameter constraint: NSLayoutConstraint
    func addSuperviewConstraint(constraint: NSLayoutConstraint) {
        superview?.addConstraint(constraint)
    }
    
    /// Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @available(iOS 9, *)
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}

// MARK: - UIView + Constraints
//
extension UIView {
    
    /// Top constraint anchor
    /// - Parameter anchor: NSLayoutYAxisAnchor
    /// - Parameter constant: CGFloat
    @discardableResult func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    /// Bottom constraint anchor
    /// - Parameter anchor: NSLayoutYAxisAnchor
    /// - Parameter constant: CGFloat
    @discardableResult func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    /// Leading Anchor
    /// - Parameter anchor: NSLayoutXAxisAnchor
    /// - Parameter constant: CGFloat
    @discardableResult func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    /// Trailing Anchor
    /// - Parameter anchor: NSLayoutXAxisAnchor
    /// - Parameter constant: CGFloat
    @discardableResult func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    /// Height Anchor
    /// - Parameter height: CGFloat
    @discardableResult func heightAnchor(equalTo height: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    /// Width Anchor
    /// - Parameter height: CGFloat
    @discardableResult func widthAnchor(equalTo height: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
}


//
//MARK:- ROTATION
//

extension UIView {
    
    /// Roatet UIView
    /// - Parameter radians: CGFloat
    /// - Parameter animated: Bool
    func rotate(radians: CGFloat, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        } else {
            transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    /// Drop Shadow to uiview
    /// - Parameter color: UIColor
    /// - Parameter opacity: Float
    /// - Parameter offSet: CGSize
    /// - Parameter radius: CGFloat
    /// - Parameter scale: Bool
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

//
//MARK:- UIView
import QuartzCore
extension UIView {
    
    /// Add dashed border to view
    /// - Parameter color: UIColor
    func addDashedBorder(color: UIColor = .black) {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = color.cgColor
        yourViewBorder.lineDashPattern = [4, 4]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
}
