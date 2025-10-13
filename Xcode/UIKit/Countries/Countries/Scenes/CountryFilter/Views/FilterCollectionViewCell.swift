//
//  FilterCollectionViewCell.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit

/// The cell responsible to display the `CountryFilter` in `FilterCollectionViewController`.
final class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: FilterCollectionViewCell.self)
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .text
        
        return label
    }()
    
    private lazy var separator = {
        let separator = UIView().frame(height: 1)
        separator.backgroundColor = .separator
        
        return separator
    }()
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel, insets: .init(top: .minPadding, left: .midPadding, bottom: .minPadding, right: .midPadding))
        contentView.addSubview(separator, leading: .midPadding, bottom: 0, trailing: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewCell methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.font = .body
        titleLabel.textColor = .text
    }
    
    // MARK: - Public methods
    
    func update(with text: String, shouldHighlight: Bool) {
        titleLabel.text = text
        
        if shouldHighlight {
            titleLabel.font = .bodyBold
            titleLabel.textColor = .accent
        }
    }
}
