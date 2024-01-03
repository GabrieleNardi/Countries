//
//  CountryCollectionViewCell.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit
import DataModel

/// The cell to show main information of a country in `CountryCollectionViewController`.
final class CountryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = String(describing: CountryCollectionViewCell.self)
    
    private lazy var contentHStack = HStack(.midPadding, alignment: .center, views: [imageViewContainer, labelVStack, chevronIcon])
    
    private lazy var labelVStack = VStack(views: [titleLabel, subtitleLabel])
    
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
    
    private lazy var imageView: AsyncImageView = {
        let imageView = AsyncImageView(placeholder: UIImage(systemName: "photo")).frame(width: 101, height: 57)
        imageView.tintColor = .systemGray
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .systemGray3
        
        return label
    }()
    
    private lazy var chevronIcon: UIImageView = {
        let imageView = UIImageView().frame(value: 24)
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        
        return imageView
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView().frame(height: 1)
        separator.backgroundColor = .separator
        
        return separator
    }()
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let inset: CGFloat = .midPadding
        contentView.addSubview(contentHStack, insets: .init(top: 0, left: inset, bottom: 0, right: inset))
        contentView.addSubview(separator, leading: .midPadding, bottom: 0, trailing: 0)
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
    
    func update(with country: Country) {
        imageView.load(url: country.flag.url)
        titleLabel.text = country.name.common
        subtitleLabel.text = country.continent
    }
}
