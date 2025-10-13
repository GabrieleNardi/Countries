//
//  EmptyView.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit

/// A reusable empty view to show instead of empty page.
final class EmptyView: UIView {
    
    // MARK: - Properties
    
    private lazy var contentVStack = VStack(alignment: .center, views: [imageView, titleLabel])
    
    private lazy var imageView = {
        let imageView = UIImageView().frame(value: 48)
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .headline
        label.textColor = .systemGray3
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Initialization methods
    
    init(image: UIImage?, title: LocalizedStringResource) {
        super.init(frame: .zero)
        
        imageView.image = image
        titleLabel.text = String(localized: title)
        
        addSubview(contentVStack, padding: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
