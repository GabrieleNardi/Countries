//
//  ViewController.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Combine
import SwiftUI
import UIKit

/// A custom implementation of a `UIViewController` made to be a superclass
/// for application's `ViewController`.
class ViewController<Section: Hashable, Model: Hashable>: UIViewController {
    
    // MARK: - Type alias
    
    // The model of the collectionView.
    typealias Model = Model
    
    // The section of the collectionView.
    typealias Section = Section
    
    // MARK: - View properties
    
    /// The `VStack` which act as a container for the `ViewController`.
    private(set) lazy var contentVStack = VStack()
    
    /// The default layout for the collection view of the `ViewController`.
    private(set) lazy var defaultLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = .midPadding
        layout.minimumLineSpacing = 0
        let itemWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: itemWidth, height: 90)
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    /// The main component of the `ViewController`.
    private(set) lazy var collectionView = CollectionView<Section, Model>(layout: defaultLayout)
    
    /// The `UIActivityIndicatorView` of the `ViewController`.
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    /// The default empty view for the `ViewController`.
    lazy var emptyView = {
        let emptyView = EmptyView(
            image: UIImage(systemName: "exclamationmark.magnifyingglass"),
            title: "There are no countries according your search"
        )
            .frame(width: 180)
        emptyView.isHidden = true
        
        return emptyView
    }()
    
    /// A `Set` of `AnyCancellable` that store the `Cancellable`s
    /// of the `ViewController`'s child.
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController methods
    
    override func loadView() {
        view = collectionView
        view.addSubview(emptyView, centerX: 0, centerY: -100)
        view.addSubview(activityIndicator, centerX: 0, centerY: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToPublishers()
        setupCollectionView()
    }
    
    // MARK: - Internal methods
    
    /// The default implementation does nothing.
    /// Override this method to provide a custom
    /// implementation for publisher subscriptions.
    open func subscribeToPublishers() {
        
    }
    
    /// The default implementation does nothing.
    /// Override this method to provide a customization
    /// for the `CollectionView`.
    open func setupCollectionView() {
        
    }
    
    /// The method that handles the new incoming `State`.
    /// - Parameter state: The incoming `State` to be handled.
    func handleState(_ state: ViewState<[Model]>) {
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
    
    func presentErrorAlert(error: Error) {
        let title: LocalizedStringResource = "Attention"
        let message: LocalizedStringResource = "An error has occured, try again please"
        
        let alert = UIAlertController(
            title: String(localized: title),
            message: String(localized: message),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert, animated: true)
    }
}

