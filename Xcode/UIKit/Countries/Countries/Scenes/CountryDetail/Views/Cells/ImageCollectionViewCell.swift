//
//  ImageCollectionViewCell.swift
//  Countries
//
//  Created by Gabriele Nardi on 28/12/23.
//

import UIKit

/// Cells used to display images(maps and photos).
final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: ImageCollectionViewCell.self)
    
    private lazy var imageView = {
        let imageView = AsyncImageView(placeholder: UIImage(systemName: "photo")).frame(value: 285)
        imageView.tintColor = .systemGray
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView, padding: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewCell methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    // MARK: - Internal methods
    
    func update(image: UIImage?) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    func update(url: URL?) {
        imageView.load(url: url)
    }
}
