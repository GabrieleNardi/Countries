//
//  MapSnapshotTests.swift
//  Commons
//
//  Created by Gabriele Nardi   on 28/10/25.
//


import Testing
import MapKit
@testable import Commons

@Suite("Map Snapshot Provider Tests")
struct MapSnapshotTests {
    
    // MARK: - Test Properties
    
    private let romeCoordinates = CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964)
    private let newYorkCoordinates = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    private let invalidCoordinates = CLLocationCoordinate2D(latitude: 200, longitude: 200)
    
    // MARK: - Basic Functionality Tests
    
    @Test("Provide snapshot with default size returns image")
    func provideSnapshotWithDefaultSize() async throws {
        // Given
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let expectedSize = CGSize(width: 285, height: 285)
        
        // When
        let snapshot = try await MapSnapshotter.provideSnapshot(
            for: romeCoordinates,
            span: span,
            type: .standard
        )
        
        // Then
        #expect(snapshot.size == expectedSize)
    }
    
    @Test("Provide snapshot with custom size returns image with correct size")
    func provideSnapshotWithCustomSize() async throws {
        // Given
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let customSize = CGSize(width: 500, height: 300)
        
        // When
        let snapshot = try await MapSnapshotter.provideSnapshot(
            for: romeCoordinates,
            span: span,
            type: .standard,
            size: customSize
        )
        
        // Then
        #expect(snapshot.size == customSize)
    }
    
    // MARK: - Map Type Tests
    
    @Suite("Map Type Tests")
    struct MapTypeTests {
        private let coordinates = CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964)
        private let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        @Test("Standard map type returns image")
        func standardMapType() async throws {
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard
            )
            
            #expect(snapshot.size.width > 0)
            #expect(snapshot.size.height > 0)
        }
        
        @Test("Satellite map type returns image")
        func satelliteMapType() async throws {
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .satellite
            )
            
            #expect(snapshot.size.width > 0)
            #expect(snapshot.size.height > 0)
        }
        
        @Test("Hybrid map type returns image")
        func hybridMapType() async throws {
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .hybrid
            )
            
            #expect(snapshot.size.width > 0)
            #expect(snapshot.size.height > 0)
        }
        
        @Test(
            "All map types return valid images",
            arguments: [MKMapType.standard, .satellite, .hybrid, .satelliteFlyover, .hybridFlyover]
        )
        func allMapTypes(mapType: MKMapType) async throws {
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: mapType
            )
            
            #expect(snapshot.size.width > 0)
            #expect(snapshot.size.height > 0)
        }
    }
    
    // MARK: - Coordinate Tests
    
    @Test("Different coordinates return images")
    func differentCoordinates() async throws {
        // Given
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        // When
        let romeSnapshot = try await MapSnapshotter.provideSnapshot(
            for: romeCoordinates,
            span: span,
            type: .standard
        )
        
        let nySnapshot = try await MapSnapshotter.provideSnapshot(
            for: newYorkCoordinates,
            span: span,
            type: .standard
        )
        
        // Then
        #expect(romeSnapshot.size.width > 0)
        #expect(nySnapshot.size.width > 0)
    }
    
    // MARK: - Span Tests
    
    @Suite("Span Tests")
    struct SpanTests {
        private let coordinates = CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964)
        
        @Test("Small span returns zoomed in image")
        func smallSpan() async throws {
            let smallSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: smallSpan,
                type: .standard
            )
            
            #expect(snapshot.size.width > 0)
        }
        
        @Test("Large span returns zoomed out image")
        func largeSpan() async throws {
            let largeSpan = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: largeSpan,
                type: .standard
            )
            
            #expect(snapshot.size.width > 0)
        }
        
        @Test(
            "Various span sizes return valid images",
            arguments: [0.01, 0.05, 0.1, 0.5, 1.0]
        )
        func variousSpanSizes(delta: Double) async throws {
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard
            )
            
            #expect(snapshot.size.width > 0)
        }
    }
    
    // MARK: - Size Tests
    
    @Suite("Size Tests")
    struct SizeTests {
        private let coordinates = CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964)
        private let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        @Test("Square size returns square image")
        func squareSize() async throws {
            let squareSize = CGSize(width: 400, height: 400)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard,
                size: squareSize
            )
            
            #expect(snapshot.size == squareSize)
            #expect(snapshot.size.width == snapshot.size.height)
        }
        
        @Test("Rectangular size returns rectangular image")
        func rectangularSize() async throws {
            let rectangularSize = CGSize(width: 600, height: 300)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard,
                size: rectangularSize
            )
            
            #expect(snapshot.size == rectangularSize)
            #expect(snapshot.size.width != snapshot.size.height)
        }
        
        @Test("Very small size returns image")
        func verySmallSize() async throws {
            let tinySize = CGSize(width: 50, height: 50)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard,
                size: tinySize
            )
            
            #expect(snapshot.size == tinySize)
        }
        
        @Test("Very large size returns image")
        func veryLargeSize() async throws {
            let largeSize = CGSize(width: 2000, height: 2000)
            
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard,
                size: largeSize
            )
            
            #expect(snapshot.size.width > 0)
        }
        
        @Test(
            "Various sizes return correctly sized images",
            arguments: [
                CGSize(width: 100, height: 100),
                CGSize(width: 285, height: 285),
                CGSize(width: 500, height: 300),
                CGSize(width: 800, height: 600)
            ]
        )
        func variousSizes(size: CGSize) async throws {
            let snapshot = try await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: span,
                type: .standard,
                size: size
            )
            
            #expect(snapshot.size == size)
        }
    }
    
    // MARK: - Concurrent Requests Tests
    
    @Test("Multiple concurrent requests all succeed")
    func multipleConcurrentRequests() async throws {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let coordinates = [romeCoordinates, newYorkCoordinates, romeCoordinates]
        
        let snapshots = try await withThrowingTaskGroup(of: UIImage.self) { group in
            for coordinate in coordinates {
                group.addTask {
                    try await MapSnapshotter.provideSnapshot(
                        for: coordinate,
                        span: span,
                        type: .standard
                    )
                }
            }
            
            var results: [UIImage] = []
            for try await snapshot in group {
                results.append(snapshot)
            }
            return results
        }
        
        #expect(snapshots.count == coordinates.count)
        for snapshot in snapshots {
            #expect(snapshot.size.width > 0)
        }
    }
    
    // MARK: - Edge Cases
    
    @Suite("Edge Cases")
    struct EdgeCaseTests {
        private let coordinates = CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964)
        
        @Test("Zero span does not crash")
        func zeroSpan() async {
            let zeroSpan = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)
            
            _ = try? await MapSnapshotter.provideSnapshot(
                for: coordinates,
                span: zeroSpan,
                type: .standard
            )
            // If we reach here without crashing, the test passes
        }
        
        @Test("Negative size throws error")
        func negativeSize() async {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let negativeSize = CGSize(width: -100, height: -100)
            
            await #expect(throws: Error.self) {
                try await MapSnapshotter.provideSnapshot(
                    for: coordinates,
                    span: span,
                    type: .standard,
                    size: negativeSize
                )
            }
        }
    }
    
    // MARK: - Performance Tests
    
    @Test("Snapshot generation performance", .timeLimit(.minutes(1)))
    func snapshotGenerationPerformance() async throws {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let snapshot = try await MapSnapshotter.provideSnapshot(
            for: romeCoordinates,
            span: span,
            type: .standard
        )
        
        #expect(snapshot.size.width > 0)
    }
}
