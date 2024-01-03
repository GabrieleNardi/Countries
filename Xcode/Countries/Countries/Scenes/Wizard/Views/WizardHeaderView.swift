//
//  WizardHeaderView.swift
//  Countries
//
//  Created by Gabriele Nardi on 29/12/23.
//

import UIKit

/// The header of the `WizardViewController`.
final class WizardHeaderView: UIView {
    
    private lazy var contentVStack = VStack(.minPadding, views: [label, separator])
    
    private lazy var label = {
        let label = UILabel()
        label.font = .title2Bold
        label.text = String(localized: title)
        
        return label
    }()
    
    private let separator = {
        let view = UIView().frame(height: 1)
        view.backgroundColor = .separator
        
        return view
    }()
    
    private let title: LocalizedStringResource = "Welcome"
    
    init() {
        super.init(frame: .zero)
        
        addSubview(contentVStack, padding: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
