//
//  InfoCollectionViewCell.swift
//  Countries
//
//  Created by Gabriele Nardi on 28/12/23.
//

import UIKit

/// Cells used to display main infos and infos.
final class InfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: InfoCollectionViewCell.self)
    
    private lazy var contentHStack = HStack(alignment: .center, views: [labelVStack])
    
    private lazy var labelVStack = VStack(8, alignment: .center, views: [titleLabel, valueLabel, unitLabel])
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .systemGray3
        
        return label
    }()
    
    private lazy var valueLabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var unitLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .systemGray
        
        return label
    }()
    
    private var horizontalSeparator: UIView {
        let view = UIView().frame(height: 1)
        view.backgroundColor = .separator
        
        return view
    }
    
    private lazy var verticalSeparator = {
        let view = UIView().frame(width: 1, height: 40)
        view.backgroundColor = .separator
        
        return view
    }()
    
    private lazy var spacer = UIView()
    
    // MARK: - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(horizontalSeparator, top: 0, leading: 0, trailing: 0)
        contentView.addSubview(contentHStack, padding: 0)
        contentView.addSubview(horizontalSeparator, leading: 0, bottom: 0, trailing: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewCell methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        valueLabel.text = nil
        unitLabel.text = nil
        unitLabel.isHidden = false
        verticalSeparator.removeFromSuperview()
        spacer.removeFromSuperview()
    }
    
    // MARK: - Public methods
    
    func update(model: Model, isLastCell: Bool) {
        titleLabel.text = model.title
        valueLabel.text = model.value
    
        if let unit = model.unit {
            unitLabel.text = unit
        } else {
            unitLabel.isHidden = true
            labelVStack.arrange(spacer)
        }
        
        if !isLastCell {
            contentHStack.arrange(verticalSeparator)
        }
    }
}

extension InfoCollectionViewCell {
    
    struct Model: Hashable {
        
        let title: String
        
        let value: String
        
        let unit: String?
    }
}
