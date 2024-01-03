//
//  AsyncImageView.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Commons
import UIKit

/// A `UIImageView` subclass made give the imageView the ability to
/// download the image by a given `URL`.
final class AsyncImageView: UIImageView {
    
    // MARK: - Properties
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let placeholder: UIImage?
    
    private(set) var state: State = .idle {
        didSet {
            handleState(state)
        }
    }
    
    private var request: URLRequest?
    
    private var task: Task<Void, Error>?
    
    private let timeout: TimeInterval = 10
    
    // MARK: - Initialization methods
    
    init(url: URL? = nil, placeholder: UIImage? = nil) {
        self.placeholder = placeholder
        if let url { request = URLRequest(url: url, timeoutInterval: timeout) }
        
        super.init(frame: .zero)
        
        addSubview(activityIndicator, centerX: 0, centerY: 0)
        if request != nil { load() }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    /// Check if the image is in the cache,
    /// if not it downloads the resource.
    func load() {
        guard let request else {
            let image = placeholder ?? UIImage()
            state = .loaded(image)
            return
        }
        if let cache = UIApplication.dependencies.networkService.imageCache.cachedResponse(for: request) {
            let image = UIImage(data: cache.data) ?? placeholder ?? UIImage()
            state = .loaded(image)
        } else {
            load(url: request.url)
        }
    }
    
    /// Download the resource.
    func load(url: URL?) {
        guard let url else {
            return
        }
        
        state = .loading
        
        task = Task { [weak self] in
            guard let self else {
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let image = UIImage(data: data) ?? placeholder ?? UIImage()
                state = .loaded(image)
            } catch {
                UIApplication.dependencies.loggerService.log(error)
                state = .failure
            }
        }
    }
    
    /// Cancel the download `Task`
    func cancel() {
        task?.cancel()
        state = .idle
    }
    
    // MARK: - Private methods
    
    private func handleState(_ state: State) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded(let image):
            activityIndicator.stopAnimating()
            self.image = image
            contentMode = .scaleAspectFill
        case .failure:
            activityIndicator.stopAnimating()
            image = placeholder
            contentMode = .scaleAspectFit
        }
    }
}

extension AsyncImageView {
    
    /// The state of the `AsyncImageView`.
    enum State {
        case idle
        case loading
        case loaded(UIImage)
        case failure
    }
}
