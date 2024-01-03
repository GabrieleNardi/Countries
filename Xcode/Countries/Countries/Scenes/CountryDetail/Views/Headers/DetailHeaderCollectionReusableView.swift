//
//  DetailHeaderCollectionReusableView.swift
//  Countries
//
//  Created by Gabriele Nardi on 28/12/23.
//

import UIKit


/// The generic header used in the `CountryDetailViewController`'s `CollectionView`.
final class DetailHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    private let label = {
        let label = UILabel()
        label.font = .title2Bold
        
        return label
    }()
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label, insets: .init(top: .midPadding, left: 0, bottom: 0, right: 0))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func update(text: String) {
        label.text = text
    }
}
