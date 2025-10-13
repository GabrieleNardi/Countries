//
//  FilterHeaderView.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit

/// The header that displays the current filter in the `CountryCollectionViewController`.
final class FilterHeaderView: UIView {
    
    // MARK: - Properties
    
    private let filterString: LocalizedStringResource = "Filter:"
    
    private let countryString: LocalizedStringResource = "Country"
    
    private let countriesString: LocalizedStringResource = "Countries"
    
    private lazy var contentHStack = HStack(alignment: .top, views: [titleLabel, subtitleLabel, UIView(), counterLabel])
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .body
        
        return label
    }()
    
    private lazy var subtitleLabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .accent
        
        return label
    }()
    
    private lazy var counterLabel = {
        let label = UILabel()
        label.font = .footnote
        label.textColor = .systemGray3
        
        return label
    }()
    
    // MARK: - Initialization methods
    
    init(filter: CountryFilter, countriesCount: Int) {
        super.init(frame: .zero)
        
        addSubview(contentHStack, padding: .midPadding)
        update(filter: filter, countriesCount: countriesCount)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func update(filter: CountryFilter, countriesCount: Int) {
        switch filter {
        case .all:
            break
        case .continent(let value), .language(let value):
            titleLabel.text = String(localized: filterString)
            subtitleLabel.text = " \(value)"
            counterLabel.text = "\(countriesCount) \(getCountriesText(count: countriesCount))"
        }
    }
    
    // MARK: - Private methods
    
    private func getCountriesText(count: Int) -> String {
        count == 1
        ? String(localized: countryString)
        : String(localized: countriesString)
    }
}
