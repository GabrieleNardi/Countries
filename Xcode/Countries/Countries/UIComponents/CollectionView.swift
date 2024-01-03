//
//  CollectionView.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit
/// A custom implementation of a `UICollectionView` made to be a superclass
/// for application's `CollectionView`s.
final class CollectionView<Section: Hashable, Model: Hashable>: UICollectionView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Model>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Model>
  
    private(set) var diffableDataSource: DataSource?
    
    init(layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerCell(cellType: UICollectionViewCell.Type, identifier: String) {
        register(cellType, forCellWithReuseIdentifier: identifier)
    }
    
    func registerSupplementaryView(viewType: UICollectionReusableView.Type, kind: String, identifier: String) {
        register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func setupDataSource<Cell: UICollectionViewCell, View: UICollectionReusableView>(
        cellProvider: @escaping (UICollectionView, IndexPath, Model) -> Cell,
        supplementaryViewProvider: ((UICollectionView, String ,IndexPath) -> View?)? = nil
    ) {
        diffableDataSource = DataSource(collectionView: self, cellProvider: cellProvider)
        diffableDataSource?.supplementaryViewProvider = supplementaryViewProvider
    }
    
    func updateSnapshot(_ snapshot: Snapshot) {
        diffableDataSource?.apply(snapshot)
    }
}
