//
//  WizardFooterView.swift
//  Countries
//
//  Created by Gabriele Nardi on 29/12/23.
//

import UIKit

// MARK: - WizardFooterViewDelegate

/// The delegate of the `WizardFooterView`.
protocol WizardFooterViewDelegate: AnyObject {
    
    /// Notice the delegate that the continue button was tapped.
    /// - Parameter wizardFooterView: The `WizardFooterView`.
    func didTapOnContinueButton(_ wizardFooterView: WizardFooterView)
}

// MARK: - WizardFooterView

/// The footer of the `WizardViewController`.
final class WizardFooterView: UIView {
    
    // MARK: - Properties
    
    private lazy var continueButton = {
        let button = UIButton().frame(width: 260, height: 44)
        button.setTitle(String(localized: continueButtonTitle), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.buttonText, for: .normal)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(didTapOnContinueButton), for: .touchUpInside)
        
        return button
    }()
    
    private let continueButtonTitle: LocalizedStringResource = "Continue"
    
    weak var delegate: WizardFooterViewDelegate?
    
    // MARK: - Initialization methods
    
    init() {
        super.init(frame: .zero)
        
        addSubview(continueButton, centerX: 0, centerY: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapOnContinueButton() {
        delegate?.didTapOnContinueButton(self)
    }
}
