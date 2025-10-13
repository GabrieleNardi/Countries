//
//  MapSnapshotter.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import MapKit

/// A wrapper of a `MKMapSnapshotter`.
/// It provides image from a map.
public struct MapSnapshotter {
    
    // MARK: - Static methods
    
    /// A map snapshot provider.
    /// - Parameters:
    ///   - coordinates: The coordinates to make the snapshot
    ///   - span: The region span
    ///   - type: The map type to snapshot
    ///   - size: The `CGSize` of the snapshot. The default value is `CGSize(width: 285, height: 285)`
    /// - Returns: The map snapshot as `UIImage`.
    public static func provideSnapshot(
        for coordinates: CLLocationCoordinate2D,
        span: MKCoordinateSpan,
        type: MKMapType,
        size: CGSize = CGSize(width: 285, height: 285)
    ) async throws -> UIImage {
        let mainOptions = MKMapSnapshotter.Options()
        mainOptions.region = MKCoordinateRegion(center: coordinates, span: span)
        mainOptions.mapType = type
        mainOptions.pointOfInterestFilter = .includingAll
        mainOptions.showsBuildings = true
        mainOptions.size = size
        
        return try await MKMapSnapshotter(options: mainOptions).start().image
    }
}
