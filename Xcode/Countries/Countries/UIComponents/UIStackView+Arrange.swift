//
//  UIStackView+Arrange.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit

extension UIStackView {
    
    /// Arrange a subview to the stack.
    /// - Parameter view: the view to arrange.
    func arrange(_ view: UIView) {
        addArrangedSubview(view)
    }
    
    /// Arrange subviews to the stack.
    /// - Parameter view: the views to arrange.
    func arrange(_ views: [UIView]) {
        views.forEach(arrange)
    }
}
