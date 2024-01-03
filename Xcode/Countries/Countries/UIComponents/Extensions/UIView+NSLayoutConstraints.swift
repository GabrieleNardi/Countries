//
//  UIView+NSLayoutConstraints.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit

extension UIView {
    
    /// It sets constraint for width.
    /// - Parameter width: the size for the width
    /// - Returns: the view to which constraint has been set
    func frame(width: CGFloat) -> Self { frame(width: width, height: nil) }
    
    /// It sets constraint for height.
    /// - Parameter width: the size for the height
    /// - Returns: the view to which constraint has been set
    func frame(height: CGFloat) -> Self { frame(width: nil, height: height) }
    
    /// It sets constraint for width and height.
    /// - Parameter value: the size for both width and height
    /// - Returns: the view to which constraints have been set
    func frame(value: CGFloat) -> Self { frame(width: value, height: value) }
    
    /// It sets constraint for width and height.
    /// - Parameters:
    ///   - width: the size for the width
    ///   - height: the size for the height
    /// - Returns: the view to which constraints have been set
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraints: [NSLayoutConstraint] = []
        if let width = width { constraints.append(widthAnchor.constraint(equalToConstant: width)) }
        if let height = height { constraints.append(heightAnchor.constraint(equalToConstant: height)) }
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    /// Give the view a width or a minimum width
    /// - Parameters:
    ///   - width: The width of the view
    ///   - greaterThanOrEqual: If this parameter is `true` the view set the width parameter as minimum width
    /// - Returns: the view to which constraints have been set
    func frame(width: CGFloat, greaterThanOrEqual: Bool = false) -> Self {
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraints: [NSLayoutConstraint] = []
        if greaterThanOrEqual {
            constraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: width))
        } else {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    /// Give the view a height or a minimum height
    /// - Parameters:
    ///   - height: The height of the view
    ///   - greaterThanOrEqual: If this parameter is `true` the view set the height parameter as minimum height
    /// - Returns: the view to which constraints have been set
    func frame(height: CGFloat, greaterThanOrEqual: Bool = false) -> Self {
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraints: [NSLayoutConstraint] = []
        
        if greaterThanOrEqual {
            constraints.append(heightAnchor.constraint(greaterThanOrEqualToConstant: height))
        } else {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    /// Add the given view as child and sets constraints to satisfy the `padding` and `useSafeArea` parameters.
    /// - Parameters:
    ///   - view: the child view
    ///   - padding: apply the padding to each edge between the father and the child view
    ///   - useSafeArea: a `Boolean` parameter to use the father view `safeArea` or not
    func addSubview(_ view: UIView, padding: CGFloat, useSafeArea: Bool = true) {
        addSubview(view, top: padding, leading: padding, bottom: padding, trailing: padding, useSafeArea: useSafeArea)
    }
    
    /// Add the given view as child and sets constraints to satisfy the `insets` and `useSafeArea` parameters.
    /// - Note: This method is designed to add different padding between each father's and child 's edge.
    /// - Parameters:
    ///   - view: the child view
    ///   - insets: apply insets to each edge between the father and the child view
    ///   - useSafeArea: a `Boolean` parameter to use the father view `safeArea` or not
    func addSubview(_ view: UIView, insets: UIEdgeInsets, useSafeArea: Bool = true) {
        addSubview(view, top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right, useSafeArea: useSafeArea)
    }
    
    /// This method is designed to set a custom number of constraints to the given `view`.
    /// - Parameters:
    ///   - view: the child view
    ///   - top: the top inset
    ///   - leading: the leading inset
    ///   - bottom: the bottom inset
    ///   - trailing: the trailing inset
    ///   - centerX: the centerX inset
    ///   - centerY: the centerY inset
    ///   - useSafeArea: a `Boolean` parameter to use the father view `safeArea` or not
    func addSubview(_ view: UIView, top: CGFloat? = nil, leading: CGFloat? = nil, bottom: CGFloat? = nil, trailing: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, useSafeArea: Bool = true) {
        addSubview(view)
        
        if view.translatesAutoresizingMaskIntoConstraints == true {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraints: [NSLayoutConstraint] = []
        if useSafeArea {
            if let top = top { constraints.append(view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: top)) }
            if let leading = leading { constraints.append(view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leading)) }
            if let bottom = bottom { constraints.append(view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottom)) }
            if let trailing = trailing { constraints.append(view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -trailing)) }
            if let centerX = centerX { constraints.append(view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: centerX)) }
            if let centerY = centerY { constraints.append(view.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: centerY)) }
        } else {
            if let top = top { constraints.append(view.topAnchor.constraint(equalTo: topAnchor, constant: top)) }
            if let leading = leading { constraints.append(view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading)) }
            if let bottom = bottom { constraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom)) }
            if let trailing = trailing { constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailing)) }
            if let centerX = centerX { constraints.append(view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerX)) }
            if let centerY = centerY { constraints.append(view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerY)) }
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    /// This method is designed to let the user a high level of customisation for the view.
    /// - Parameters:
    ///   - view: the child view
    ///   - constraints: an array of `NSLayoutConstraint` to activate to the child view
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(view)
        
        if view.translatesAutoresizingMaskIntoConstraints == true {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    /// Get the constraint for the given attribute.
    /// - Parameter attribute: the attribute to get the constraint
    /// - Returns: the constraint of the given attribute,
    func constraintForAttribute(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        superview?.constraints.first(where: { $0.firstAttribute == attribute && ($0.firstItem as? UIView) == self })
    }
    
    /// Get the height constraint of the `UIView`.
    var heightConstraint: NSLayoutConstraint? {
        constraintForAttribute(attribute: .height)
    }
    
    /// Get the width constraint of the `UIView`.
    var widthConstraint: NSLayoutConstraint? {
        constraintForAttribute(attribute: .width)
    }
    
    /// Get the leading constraint of the `UIView`.
    var leadingConstraint: NSLayoutConstraint? {
        constraintForAttribute(attribute: .leading)
    }
    
    /// Get the trailing constraint of the `UIView`.
    var trailingConstraint: NSLayoutConstraint? {
        constraintForAttribute(attribute: .trailing)
    }
    
    /// Get the top constraint of the `UIView`.
    var topConstraint: NSLayoutConstraint? {
        constraintForAttribute(attribute: .top)
    }
    
    /// Get the bottom constraint of the `UIView`.
    var bottomConstraint: NSLayoutConstraint? {
        constraintForAttribute(attribute: .bottom)
    }
}
