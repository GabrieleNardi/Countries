//
//  WizardViewController.swift
//  Countries
//
//  Created by Gabriele Nardi on 29/12/23.
//

import UIKit

/// The `Wizard` which welcomes the user and explains to him/her the application's contents.
final class WizardViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var contentVStack = VStack(.midPadding, views: [header, label, UIView(), footer])
    
    private lazy var header = WizardHeaderView()
    
    private lazy var label = {
        let label = UILabel()
        label.font = .body
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var footer = {
        let footer = WizardFooterView().frame(height: 44)
        footer.delegate = self
        
        return footer
    }()
    
    // MARK: - ViewController methods
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(contentVStack, insets: .init(top: .maxPadding, left: .midPadding, bottom: .midPadding, right: .midPadding))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .modalBackground
        label.text = String(localized: welcome)
    }
}

// MARK: - Extensions

// MARK: - Model

extension WizardViewController {
    
    var welcome: LocalizedStringResource {
        "By this application you will be able to obtain information about countries.\n\nYou could filter them for continent or languages, or, you may want to access to detailed information about a country, such as the capital, the population, and so on.\n\nOnce downloaded, the information about countries will be stored in your iPhone, and you can consult them even if you are offline.\n\nENJOY!"
    }
}

// MARK: - WizardFooterViewDelegate

extension WizardViewController: WizardFooterViewDelegate {
    
    func didTapOnContinueButton(_ wizardFooterView: WizardFooterView) {
        dismiss(animated: true)
    }
}
