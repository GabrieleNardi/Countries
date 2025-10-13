//
//  Stack.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit

/// `UIStackView` with a `.horizontal` axis
public class HStack: UIStackView {
    public init(
        _ spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        views: [UIView] = []
    ) {
        super.init(frame: .zero)
        if spacing != 0 { self.spacing = spacing }
        if distribution != .fill { self.distribution = distribution }
        if alignment != .fill { self.alignment = alignment }
        if !views.isEmpty { arrange(views) }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// `UIStackView` with a `.vertical` axis
public class VStack: UIStackView {
    public init(
        _ spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        views: [UIView] = []
    ) {
        super.init(frame: .zero)
        axis = .vertical
        if spacing != 0 { self.spacing = spacing }
        if distribution != .fill { self.distribution = distribution }
        if alignment != .fill { self.alignment = alignment }
        if !views.isEmpty { arrange(views) }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
