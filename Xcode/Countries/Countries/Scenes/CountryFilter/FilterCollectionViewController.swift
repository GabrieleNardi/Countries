//
//  FilterCollectionViewController.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit
import Commons

/// The delegate of the FilterCollectionViewController.
protocol FilterCollectionViewControllerDelegate: AnyObject {
    
    /// A filter has been selected.
    /// - Parameter filter: The selected filter.
    func didSelect(filter: CountryFilter)
}

/// The `ViewController` by which the user can filter the countries.
final class FilterCollectionViewController: ViewController<FilterCollectionViewController.Section, String> {
    
    // MARK: - Properties
    
    weak var delegate: FilterCollectionViewControllerDelegate?
    
    private let viewModel: FilterCollectionViewModel
    
    // MARK: - Initialization methods
    
    init(viewModel: FilterCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.load()
        setupNavigationBar()
        setupCollectionView()
        subscribeToPublishers()
    }
    
    // MARK: - ViewController methods
    
    override func subscribeToPublishers() {
        viewModel.$state
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.$model
            .sink { [weak self] model in
                self?.updateSnapshot(with: model)
            }
            .store(in: &cancellables)
    }
    
    override func setupCollectionView() {
        collectionView.registerCell(cellType: FilterCollectionViewCell.self, identifier: FilterCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        
        let itemWidth = UIScreen.main.bounds.width
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: 33)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = .minPadding
        
        collectionView.setupDataSource { [weak self] collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath)
            guard let self,
                  let filterCell = cell as? FilterCollectionViewCell
            else {
                return cell
            }
            
            filterCell.update(with: model, shouldHighlight: viewModel.filter.associatedValue == model)
            
            return filterCell
        }
    }
    
    // MARK: - Private methods
    
    private func updateSnapshot(with models: [Model]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        
        collectionView.updateSnapshot(snapshot)
    }
    
    private func setupNavigationBar() {
        switch viewModel.filter {
        case .continent:
            title = String(localized: LocalizedStringResource("Filter by continent"))
        case .language:
            title = String(localized: LocalizedStringResource("Filter by language"))
        default:
            break
        }
        
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapOnCloseButtonItem)
        )
    }
    
    @objc private func didTapOnCloseButtonItem() {
        dismiss(animated: true)
    }
}

// MARK: - Extensions

// MARK: - UICollectionViewDelegate

extension FilterCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let value = viewModel.model[safe: indexPath.row] {
            switch viewModel.filter {
            case .all:
                delegate?.didSelect(filter: .all)
            case .continent:
                delegate?.didSelect(filter: .continent(value))
            case .language:
                delegate?.didSelect(filter: .language(value))
            }
            
            dismiss(animated: true)
        }
    }
}

extension FilterCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(query: searchController.searchBar.text)
    }
}

// MARK: - Section

extension FilterCollectionViewController {
      
    enum Section: Hashable {
        case main
    }
}
