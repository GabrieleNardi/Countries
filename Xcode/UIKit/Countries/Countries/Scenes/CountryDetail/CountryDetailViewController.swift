//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Gabriele Nardi on 28/12/23.
//

import Combine
import UIKit
import DataModel

/// The viewController which displays the detail of a country.
final class CountryDetailViewController: ViewController<CountryDetailViewController.Section, CountryDetailViewController.Item> {
    
    // MARK: - Type alias
    
    typealias Model = Item
    
    // MARK: - Properties
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self,
                  let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex)
            else {
                return nil
            }
            
            return switch sectionLayoutKind {
            case .mainInfos:
                createMainInfosLayoutSection()
            case .maps, .photos:
                createImagesLayoutSection()
            case .list:
                createListLayoutSection(layoutEnvironment: layoutEnvironment)
            case .translations:
                createTranslationsLayoutSection()
            }
        }
        
        return layout
    }()
    
    private lazy var customCollectionView = CollectionView<Section, Item>(layout: layout)
    
    private let viewModel: CountryDetailViewModel
    
    // MARK: - Initialization methods
    
    init(viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController methods
    
    override func loadView() {
        view = customCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.load()
    }
    
    // MARK: - Internal methods
    
    override func subscribeToPublishers() {
        viewModel.$state.sink { [weak self] state in
            self?.handleState(state: state)
        }
        .store(in: &cancellables)
        
        viewModel.$model
            .drop(while: { $0.isEmpty })
            .sink { [weak self] model in
                self?.updateSnapshot(dataModel: model)
            }
            .store(in: &cancellables)
    }
    
    override func setupCollectionView() {
        customCollectionView.allowsSelection = false
        
        let mainHeaderRegistration = createMainHeaderRegistration()
        let headerRegistration = createHeaderRegistration()
        let infosCellRegistration = createInfosCellRegistration()
        let imageCellRegistration = createImageCellRegistration()
        let listCellRegistration = createListCellRegistration()
        
        customCollectionView.setupDataSource(cellProvider: { collectionView, indexPath, model in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section")
            }
            
            let cell = switch section {
            case .mainInfos, .translations:
                collectionView.dequeueConfiguredReusableCell(using: infosCellRegistration, for: indexPath, item: model)
            case .maps, .photos:
                collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: model)
            case .infos:
                collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: model)
            }
            
            return cell
        }, supplementaryViewProvider: { collectionView, kind, indexPath in
            if kind == ElementKind.mainSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: mainHeaderRegistration, for: indexPath)
            } else if kind == ElementKind.sectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
            
            return nil
        })
    }
    
    // MARK: - Private methods
    
    private func handleState(state: ViewState<CountryDetailViewModel.Model>) {
        emptyView.isHidden = true
        activityIndicator.stopAnimating()
        
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .noResultsFound:
            emptyView.isHidden = false
        case .failure(let error):
            presentErrorAlert(error: error)
        default:
            break
        }
    }
    
    private func updateSnapshot(dataModel: CountryDetailViewModel.DataModel) {
        let mainInfoItems = viewModel.transformToMainInfos(from: dataModel)
        let mapItems = viewModel.transformToMaps(from: dataModel)
        let infoItems = viewModel.transformToInfos(from: dataModel)
        let translationItems = viewModel.transformToTranslations(from: dataModel)
        let photoItems = viewModel.transformToPhotos(from: dataModel)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.mainInfos, .maps, .infos, .translations])
        if !photoItems.isEmpty { snapshot.appendSections([.photos]) }
        
        snapshot.appendItems(mainInfoItems, toSection: .mainInfos)
        snapshot.appendItems(mapItems, toSection: .maps)
        snapshot.appendItems(infoItems, toSection: .infos)
        snapshot.appendItems(translationItems, toSection: .translations)
        if !photoItems.isEmpty { snapshot.appendItems(photoItems, toSection: .photos) }
        
        customCollectionView.diffableDataSource?.apply(snapshot)
    }
}

// MARK: - Extensions

// MARK: - Layout

extension CountryDetailViewController {
    
    private func createMainInfosLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.32), heightDimension: .absolute(99))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(92))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.mainSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [headerSupplementary]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .midPadding, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createImagesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(285), heightDimension: .absolute(285))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(43))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.sectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [headerSupplementary]
        section.interGroupSpacing = .midPadding
        section.contentInsets = NSDirectionalEdgeInsets(top: .midPadding, leading: .midPadding, bottom: 0, trailing: .midPadding)
        
        return section
    }
    
    private func createListLayoutSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(43))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.sectionHeader, alignment: .top)
        headerSupplementary.contentInsets.leading = .midPadding
        
        let section = NSCollectionLayoutSection.list(using: .init(appearance: .plain), layoutEnvironment: layoutEnvironment)
        section.boundarySupplementaryItems = [headerSupplementary]
        
        return section
    }
    
    private func createTranslationsLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.32), heightDimension: .absolute(68))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(43))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.sectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [headerSupplementary]
        section.contentInsets = NSDirectionalEdgeInsets(top: .midPadding, leading: .midPadding, bottom: 0, trailing: 0)
        
        return section
    }
}

// MARK: - Cell Registrations

extension CountryDetailViewController {
    
    private func createMainHeaderRegistration() -> UICollectionView.SupplementaryRegistration<MainDetailHeaderCollectionReusableView> {
        let country = viewModel.country
        
        return UICollectionView.SupplementaryRegistration<MainDetailHeaderCollectionReusableView>(elementKind: ElementKind.mainSectionHeader) { supplementaryView, _, _ in
            supplementaryView.update(image: country.flag.url, title: country.name.common, subtitle: country.continent)
        }
    }
    
    private func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<DetailHeaderCollectionReusableView> {
        UICollectionView.SupplementaryRegistration<DetailHeaderCollectionReusableView>(elementKind: ElementKind.sectionHeader) { [weak self] supplementaryView, _, indexPath in
            guard let self else {
                return
            }
            
            supplementaryView.update(text: viewModel.getHeaderText(for: indexPath.section))
        }
    }
    
    private func createInfosCellRegistration() -> UICollectionView.CellRegistration<InfoCollectionViewCell, Model> {
        UICollectionView.CellRegistration<InfoCollectionViewCell, Model> { [weak self] cell, indexPath, item in
            let cellModel = InfoCollectionViewCell.Model(title: item.title ?? "-", value: item.value ?? "-", unit: item.unit)
            let count = {
                if indexPath.section == 0 {
                    return self?.customCollectionView.diffableDataSource?.snapshot().itemIdentifiers(inSection: .mainInfos).count ?? 0
                } else if indexPath.section == 3 {
                    return self?.customCollectionView.diffableDataSource?.snapshot().itemIdentifiers(inSection: .translations).count ?? 0
                }
                return 0
            }()
             
            cell.update(model: cellModel, isLastCell: count == (indexPath.row + 1))
        }
    }
    
    private func createImageCellRegistration() -> UICollectionView.CellRegistration<ImageCollectionViewCell, Model> {
        UICollectionView.CellRegistration<ImageCollectionViewCell, Model> { cell, indexPath, item in
            if let map = item.map {
                cell.update(image: map)
            } else if let image = item.image {
                cell.update(url: image.imageUrl)
            }
        }
    }
    
    private func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Model> {
        UICollectionView.CellRegistration<UICollectionViewListCell, Model> { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.title
            configuration.secondaryText = "\(item.value ?? "") \(item.unit ?? "")"
            
            cell.contentConfiguration = configuration
        }
    }
}

// MARK: - Section, Item

extension CountryDetailViewController {
    
    enum Section: Int, Hashable {
        case mainInfos
        case maps
        case infos
        case translations
        case photos
    }
    
    struct Item: Hashable, Identifiable {
        
        let id = UUID()
        
        let title: String?
        
        let value: String?
        
        let unit: String?
        
        let map: UIImage?
        
        let image: PexelsImage?
        
        init(title: String? = nil, value: String? = nil, unit: String? = nil, map: UIImage? = nil, image: PexelsImage? = nil) {
            self.title = title
            self.value = value
            self.unit = unit
            self.map = map
            self.image = image
        }
        
        static func info(title: String, value: String, unit: String? = nil) -> Item {
            Item(title: title, value: value, unit: unit)
        }
        
        static func map(_ map: UIImage) -> Item {
            Item(map: map)
        }
        
        static func image(_ image: PexelsImage) -> Item {
            Item(image: image)
        }
    }
}

// MARK: - SectionLayoutKind

extension CountryDetailViewController {
    
    enum SectionLayoutKind: Int, CaseIterable {
        case mainInfos, maps, list, translations, photos
    }
    
    struct ElementKind {
        
        static let mainSectionHeader = "main-section-header-element-kind"
        
        static let sectionHeader = "section-header-element-kind"
        
    }
}
