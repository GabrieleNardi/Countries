//
//  MainDetailHeaderCollectionReusableView.swift
//  Countries
//
//  Created by Gabriele Nardi on 28/12/23.
//

import UIKit

/// The main header used in the `CountryDetailViewController`'s `CollectionView`.
final class MainDetailHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    private lazy var contentHStack = HStack(.midPadding, alignment: .top, views: [imageViewContainer, labelVStack])
    
    private lazy var labelVStack = VStack(alignment: .leading, views: [titleLabel, subtitleLabel])
    
    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.text.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowPath = UIBezierPath(
            roundedRect: CGRect(origin: .zero, size: CGSize(width: 101, height: 57)),
            cornerRadius: 10
        ).cgPath
        
        view.addSubview(imageView, padding: 0)
        return view
    }()
    
    private lazy var imageView = {
        let imageView = AsyncImageView().frame(width: 106, height: 60)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .title1
        
        return label
    }()
    
    private lazy var subtitleLabel = {
        let label = UILabel()
        label.font = .title3
        label.textColor = .systemGray3
        
        return label
    }()
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentHStack, insets: .init(top: .midPadding, left: .zero, bottom: .midPadding, right: .midPadding))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionReusableView methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    // MARK: - Public methods
    
    func update(image: URL?, title: String, subtitle: String) {
        imageView.load(url: image)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
