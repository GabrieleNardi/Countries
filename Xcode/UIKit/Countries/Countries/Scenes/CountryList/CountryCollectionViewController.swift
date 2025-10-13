//
//  CountryCollectionViewController.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import SwiftUI
import UIKit
import Commons
import DataModel

/// The controller which displays the list of the countries.
/// It lets you sort them alphabetically or filter them for continent or language.
final class CountryCollectionViewController: ViewController<CountryCollectionViewController.Section, Country> {
    
    // MARK: - Properties
    
    private lazy var filterHeaderView = FilterHeaderView(filter: viewModel.currentFilter, countriesCount: viewModel.model.count)
        .frame(height: 52)
    
    @ObservedObject private var viewModel: CountryCollectionViewModel
    
    private var shouldShowFilterHeaderView = false {
        didSet {
            filterHeaderView.isHidden = !shouldShowFilterHeaderView
        }
    }
    
    // MARK: - Initialization methods
    
    init(viewModel: CountryCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController methods
    
    override func loadView() {
        view = UIView()
        view.addSubview(contentVStack, padding: 0)
        contentVStack.arrange([filterHeaderView, collectionView])
        view.addSubview(emptyView, centerX: 0, centerY: -100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.load()
        
        subscribeToPublishers()
        
        if viewModel.shouldShowWizard {
            presentWizardViewController()
            UserDefaults.saveFirstApplicationLaunch()
        }
    }
    
    // MARK: - ViewController methods
    
    override func handleState(_ state: ViewState<[Country]>) {
        emptyView.isHidden = true
        activityIndicator.stopAnimating()
        
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .noResultsFound:
            emptyView.isHidden = false
        case .failure(let error):
            if viewModel.model.isEmpty {
                emptyView.isHidden = false
            }
            
            presentErrorAlert(error: error)
        default:
            break
        }
    }
    
    override func subscribeToPublishers() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.$model
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] model in
                guard let self else {
                    return
                }
                
                updateSnapshot(model: model)
                filterHeaderView.update(filter: viewModel.currentFilter, countriesCount: model.count)
            }
            .store(in: &cancellables)
        
        viewModel.$currentFilter
            .receive(on: RunLoop.main)
            .sink { [weak self] filter in
                guard let self else {
                    return
                }
                
                shouldShowFilterHeaderView = filter != .all
            }
            .store(in: &cancellables)
    }
    
    override func setupCollectionView() {
        collectionView.registerCell(cellType: CountryCollectionViewCell.self, identifier: CountryCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.setupDataSource { collectionView, indexPath, model in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier, for: indexPath)
            
            guard let countryCell = cell as? CountryCollectionViewCell else {
                return cell
            }
            
            countryCell.update(with: model)
            
            return countryCell
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupToolBar()
    }
    
    private func setupNavigationBar() {
        title = String(localized: LocalizedStringResource("Countries"))
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapOnSortButtonItem)
        )
    }
    
    private func setupToolBar() {
        navigationController?.setToolbarHidden(false, animated: false)
        setToolbarItems(
            [.flexibleSpace(),
             UIBarButtonItem(image: UIImage(systemName: "globe.americas"), style: .plain, target: self, action: #selector(didTapOnContinentButtonItem)),
             .flexibleSpace(),
             UIBarButtonItem(image: UIImage(systemName: "character.bubble"), style: .plain, target: self, action: #selector(didTapOnLanguageButtonItem)),
             .flexibleSpace()],
            animated: false
        )
    }
    
    private func updateSnapshot(model: [Model]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model, toSection: .main)
        
        collectionView.updateSnapshot(snapshot)
    }
    
    private func presentFilterViewController(filter: CountryFilter) {
        let filterController = FilterCollectionViewController(viewModel: .init(
            filter: filter,
            dependencies: viewModel.dependencies)
        )
        filterController.delegate = self
        
        present(UINavigationController(rootViewController: filterController), animated: true)
    }
    
    private func presentWizardViewController() {
        navigationController?.present(WizardViewController(), animated: true)
    }
    
    @objc
    private func didTapOnContinentButtonItem() {
        let filter: CountryFilter
        
        switch viewModel.currentFilter {
        case .all, .language:
            filter = .continent("All")
        case .continent(let value):
            filter = .continent(value)
        }
        
        presentFilterViewController(filter: filter)
    }
    
    @objc
    private func didTapOnLanguageButtonItem() {
        let filter: CountryFilter
        
        switch viewModel.currentFilter {
        case .all, .continent:
            filter = .language("All")
        case .language(let value):
            filter = .language(value)
        }
        
        presentFilterViewController(filter: filter)
    }
    
    @objc
    private func didTapOnSortButtonItem() {
        viewModel.sort(viewModel.currentSortOrder == .forward ? .reverse : .forward)
    }
}

// MARK: - Extensions

// MARK: - UICollectionViewDelegate

extension CountryCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let country = viewModel.model[safe: indexPath.row] else {
            return
        }
        
        let viewController = CountryDetailViewController(viewModel: .init(dependencies: viewModel.dependencies, country: country))
        viewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension CountryCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(for: searchController.searchBar.text)
    }
}

// MARK: - FilterCollectionViewControllerDelegate

extension CountryCollectionViewController: FilterCollectionViewControllerDelegate {
    
    func didSelect(filter: CountryFilter) {
        viewModel.updateCurrentFilter(filter)
    }
}

// MARK: - Section

extension CountryCollectionViewController {
    
    enum Section: Hashable {
        case main
    }
}
