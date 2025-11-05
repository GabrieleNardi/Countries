//
//  PexelsImageTests.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//


import Testing
import Foundation
@testable import DataModel

@Suite("PexelsImage Model Tests")
struct PexelsImageTests {
    
    // MARK: - Initialization Tests
    
    @Suite("Initialization Tests")
    struct InitializationTests {
        
        @Test("Initialize with valid URL and credits")
        func initializeWithValidData() {
            let url = URL(string: "https://images.pexels.com/photos/123/photo.jpg")
            let image = PexelsImage(imageUrl: url, credits: "John Doe")
            
            #expect(image.imageUrl == url)
            #expect(image.credits == "John Doe")
        }
        
        @Test("Initialize with nil URL")
        func initializeWithNilURL() {
            let image = PexelsImage(imageUrl: nil, credits: "Jane Smith")
            
            #expect(image.imageUrl == nil)
            #expect(image.credits == "Jane Smith")
        }
        
        @Test("Initialize with empty credits")
        func initializeWithEmptyCredits() {
            let url = URL(string: "https://images.pexels.com/photos/456/photo.jpg")
            let image = PexelsImage(imageUrl: url, credits: "")
            
            #expect(image.imageUrl == url)
            #expect(image.credits == "")
        }
        
        @Test(
            "Initialize with various photographer names",
            arguments: [
                "John Doe",
                "María García",
                "李明",
                "Αλέξανδρος",
                "محمد"
            ]
        )
        func initializeWithVariousNames(photographer: String) {
            let image = PexelsImage(imageUrl: nil, credits: photographer)
            
            #expect(image.credits == photographer)
        }
    }
    
    // MARK: - Decodable Tests
    
    @Suite("Decodable Tests")
    struct DecodableTests {
        
        @Test("Decode from JSON with medium size image")
        func decodeFromJSONWithMediumSize() throws {
            let json = """
            {
                "src": {
                    "original": "https://images.pexels.com/photos/123/original.jpg",
                    "large": "https://images.pexels.com/photos/123/large.jpg",
                    "medium": "https://images.pexels.com/photos/123/medium.jpg",
                    "small": "https://images.pexels.com/photos/123/small.jpg"
                },
                "photographer": "Alice Johnson"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let image = try decoder.decode(PexelsImage.self, from: data)
            
            #expect(image.imageUrl?.absoluteString == "https://images.pexels.com/photos/123/medium.jpg")
            #expect(image.credits == "Alice Johnson")
        }
        
        @Test("Decode from JSON without medium size falls back")
        func decodeWithoutMediumSize() throws {
            let json = """
            {
                "src": {
                    "original": "https://images.pexels.com/photos/456/original.jpg",
                    "large": "https://images.pexels.com/photos/456/large.jpg"
                },
                "photographer": "Bob Smith"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let image = try decoder.decode(PexelsImage.self, from: data)
            
            #expect(image.imageUrl?.absoluteString == "ImageUrl")
            #expect(image.credits == "Bob Smith")
        }
        
        @Test("Decode from JSON with empty src dictionary")
        func decodeWithEmptySrc() throws {
            let json = """
            {
                "src": {},
                "photographer": "Charlie Brown"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let image = try decoder.decode(PexelsImage.self, from: data)
            
            #expect(image.imageUrl?.absoluteString == "ImageUrl")
            #expect(image.credits == "Charlie Brown")
        }
        
        @Test("Decode from realistic Pexels API response")
        func decodeFromRealisticResponse() throws {
            let json = """
            {
                "id": 2014422,
                "width": 3024,
                "height": 3024,
                "url": "https://www.pexels.com/photo/2014422/",
                "photographer": "Joey Fatoretto",
                "photographer_url": "https://www.pexels.com/@joey",
                "photographer_id": 680589,
                "avg_color": "#374824",
                "src": {
                    "original": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg",
                    "large2x": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                    "large": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                    "medium": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=350",
                    "small": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130",
                    "portrait": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                    "landscape": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                    "tiny": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
                },
                "liked": false,
                "alt": "Brown Rocks During Golden Hour"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let image = try decoder.decode(PexelsImage.self, from: data)
            
            #expect(image.credits == "Joey Fatoretto")
            #expect(image.imageUrl?.absoluteString.contains("auto=compress&cs=tinysrgb&h=350") == true)
        }
        
        @Test("Decode multiple images from array")
        func decodeMultipleImages() throws {
            let json = """
            [
                {
                    "src": {
                        "medium": "https://images.pexels.com/photos/1/medium.jpg"
                    },
                    "photographer": "Photographer One"
                },
                {
                    "src": {
                        "medium": "https://images.pexels.com/photos/2/medium.jpg"
                    },
                    "photographer": "Photographer Two"
                },
                {
                    "src": {
                        "medium": "https://images.pexels.com/photos/3/medium.jpg"
                    },
                    "photographer": "Photographer Three"
                }
            ]
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let images = try decoder.decode([PexelsImage].self, from: data)
            
            #expect(images.count == 3)
            #expect(images[0].credits == "Photographer One")
            #expect(images[1].credits == "Photographer Two")
            #expect(images[2].credits == "Photographer Three")
        }
        
        @Test("Decode throws error with missing photographer field")
        func decodeMissingPhotographer() throws {
            let json = """
            {
                "src": {
                    "medium": "https://images.pexels.com/photos/123/medium.jpg"
                }
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            
            #expect(throws: DecodingError.self) {
                try decoder.decode(PexelsImage.self, from: data)
            }
        }
        
        @Test("Decode throws error with missing src field")
        func decodeMissingSrc() throws {
            let json = """
            {
                "photographer": "Test Photographer"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            
            #expect(throws: DecodingError.self) {
                try decoder.decode(PexelsImage.self, from: data)
            }
        }
        
        @Test("Decode with invalid JSON structure throws error")
        func decodeInvalidJSON() throws {
            let json = """
            {
                "src": "not-a-dictionary",
                "photographer": "Test"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            
            #expect(throws: DecodingError.self) {
                try decoder.decode(PexelsImage.self, from: data)
            }
        }
    }
    
    // MARK: - Hashable Tests
    
    @Suite("Hashable Tests")
    struct HashableTests {
        
        @Test("Equal images have same hash")
        func equalImagesHash() {
            let url = URL(string: "https://images.pexels.com/photos/123/medium.jpg")
            let image1 = PexelsImage(imageUrl: url, credits: "John Doe")
            let image2 = PexelsImage(imageUrl: url, credits: "John Doe")
            
            #expect(image1 == image2)
            #expect(image1.hashValue == image2.hashValue)
        }
        
        @Test("Different URLs produce different images")
        func differentURLs() {
            let url1 = URL(string: "https://images.pexels.com/photos/123/medium.jpg")
            let url2 = URL(string: "https://images.pexels.com/photos/456/medium.jpg")
            let image1 = PexelsImage(imageUrl: url1, credits: "John Doe")
            let image2 = PexelsImage(imageUrl: url2, credits: "John Doe")
            
            #expect(image1 != image2)
        }
        
        @Test("Different credits produce different images")
        func differentCredits() {
            let url = URL(string: "https://images.pexels.com/photos/123/medium.jpg")
            let image1 = PexelsImage(imageUrl: url, credits: "John Doe")
            let image2 = PexelsImage(imageUrl: url, credits: "Jane Smith")
            
            #expect(image1 != image2)
        }
        
        @Test("Images can be stored in Set")
        func imagesInSet() {
            let url1 = URL(string: "https://images.pexels.com/photos/1/medium.jpg")
            let url2 = URL(string: "https://images.pexels.com/photos/2/medium.jpg")
            
            let image1 = PexelsImage(imageUrl: url1, credits: "Photographer 1")
            let image2 = PexelsImage(imageUrl: url2, credits: "Photographer 2")
            let image3 = PexelsImage(imageUrl: url1, credits: "Photographer 1") // Duplicate
            
            let set: Set<PexelsImage> = [image1, image2, image3]
            
            #expect(set.count == 2)
            #expect(set.contains(image1))
            #expect(set.contains(image2))
        }
        
        @Test("Images can be used as Dictionary keys")
        func imagesAsDictionaryKeys() {
            let url = URL(string: "https://images.pexels.com/photos/123/medium.jpg")
            let image = PexelsImage(imageUrl: url, credits: "John Doe")
            
            var dict: [PexelsImage: String] = [:]
            dict[image] = "Favorite"
            
            #expect(dict[image] == "Favorite")
        }
        
        @Test("Images with nil URLs can be compared")
        func nilURLComparison() {
            let image1 = PexelsImage(imageUrl: nil, credits: "John Doe")
            let image2 = PexelsImage(imageUrl: nil, credits: "John Doe")
            let image3 = PexelsImage(imageUrl: nil, credits: "Jane Smith")
            
            #expect(image1 == image2)
            #expect(image1 != image3)
        }
    }
    
    // MARK: - URL Handling Tests
    
    @Suite("URL Handling Tests")
    struct URLHandlingTests {
        
        @Test("Valid HTTPS URL is stored correctly")
        func validHTTPSURL() {
            let urlString = "https://images.pexels.com/photos/123/medium.jpg"
            let url = URL(string: urlString)
            let image = PexelsImage(imageUrl: url, credits: "Test")
            
            #expect(image.imageUrl?.absoluteString == urlString)
            #expect(image.imageUrl?.scheme == "https")
        }
        
        @Test("URL with query parameters is preserved")
        func urlWithQueryParameters() {
            let urlString = "https://images.pexels.com/photos/123/medium.jpg?auto=compress&cs=tinysrgb&h=350"
            let url = URL(string: urlString)
            let image = PexelsImage(imageUrl: url, credits: "Test")
            
            #expect(image.imageUrl?.absoluteString == urlString)
            #expect(image.imageUrl?.query?.contains("auto=compress") == true)
        }
        
        @Test(
            "Various valid URL formats",
            arguments: [
                "https://images.pexels.com/photos/1/photo.jpg",
                "https://images.pexels.com/photos/123456/pexels-photo.jpeg",
                "https://images.pexels.com/photos/789/photo.png?w=800&h=600",
                "https://cdn.pexels.com/images/photo.webp"
            ]
        )
        func variousValidURLs(urlString: String) {
            let url = URL(string: urlString)
            let image = PexelsImage(imageUrl: url, credits: "Test")
            
            #expect(image.imageUrl != nil)
            #expect(image.imageUrl?.absoluteString == urlString)
        }
    }
    
    // MARK: - Credits Tests
    
    @Suite("Credits Tests")
    struct CreditsTests {
        
        @Test("Credits with special characters")
        func creditsWithSpecialCharacters() {
            let credits = "O'Brien-Smith, Jr."
            let image = PexelsImage(imageUrl: nil, credits: credits)
            
            #expect(image.credits == credits)
        }
        
        @Test("Credits with unicode characters")
        func creditsWithUnicode() {
            let credits = "Müller José 李明 Σωκράτης"
            let image = PexelsImage(imageUrl: nil, credits: credits)
            
            #expect(image.credits == credits)
        }
        
        @Test("Credits with emojis")
        func creditsWithEmojis() {
            let credits = "Photo by 📸 John Doe 🎨"
            let image = PexelsImage(imageUrl: nil, credits: credits)
            
            #expect(image.credits == credits)
        }
        
        @Test("Very long credits string")
        func veryLongCredits() {
            let credits = String(repeating: "A", count: 1000)
            let image = PexelsImage(imageUrl: nil, credits: credits)
            
            #expect(image.credits.count == 1000)
        }
    }
    
    // MARK: - Edge Cases
    
    @Suite("Edge Cases")
    struct EdgeCaseTests {
        
        @Test("Both nil URL and empty credits")
        func nilURLEmptyCredits() {
            let image = PexelsImage(imageUrl: nil, credits: "")
            
            #expect(image.imageUrl == nil)
            #expect(image.credits.isEmpty)
        }
        
        @Test("Decode with all size options in src")
        func decodeWithAllSizeOptions() throws {
            let json = """
            {
                "src": {
                    "original": "https://example.com/original.jpg",
                    "large2x": "https://example.com/large2x.jpg",
                    "large": "https://example.com/large.jpg",
                    "medium": "https://example.com/medium.jpg",
                    "small": "https://example.com/small.jpg",
                    "portrait": "https://example.com/portrait.jpg",
                    "landscape": "https://example.com/landscape.jpg",
                    "tiny": "https://example.com/tiny.jpg"
                },
                "photographer": "Test Photographer"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let image = try decoder.decode(PexelsImage.self, from: data)
            
            // Should still use medium size
            #expect(image.imageUrl?.absoluteString == "https://example.com/medium.jpg")
        }
        
        @Test("Decode with extra unknown fields")
        func decodeWithExtraFields() throws {
            let json = """
            {
                "id": 12345,
                "width": 1920,
                "height": 1080,
                "url": "https://www.pexels.com/photo/12345/",
                "src": {
                    "medium": "https://images.pexels.com/photos/123/medium.jpg"
                },
                "photographer": "Test Photographer",
                "photographer_id": 67890,
                "avg_color": "#AABBCC",
                "liked": false,
                "alt": "Test image"
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let image = try decoder.decode(PexelsImage.self, from: data)
            
            #expect(image.credits == "Test Photographer")
            #expect(image.imageUrl != nil)
        }
        
        @Test("Credits with only whitespace")
        func creditsWithWhitespace() {
            let image = PexelsImage(imageUrl: nil, credits: "   ")
            
            #expect(image.credits == "   ")
        }
        
        @Test("URL with international characters")
        func urlWithInternationalCharacters() {
            // URLs should be percent-encoded
            let urlString = "https://images.pexels.com/фото/123/medium.jpg"
            let url = URL(string: urlString)
            let image = PexelsImage(imageUrl: url, credits: "Test")
            
            // URL init might return nil for non-encoded international chars
            #expect(image.imageUrl?.absoluteString.removingPercentEncoding == urlString || image.imageUrl == nil)
        }
    }
    
    // MARK: - Integration Tests
    
    @Suite("Integration Tests")
    struct IntegrationTests {
        
        @Test("Decode and store multiple unique images")
        func decodeAndStoreMultipleImages() throws {
            let json = """
            [
                {
                    "src": {"medium": "https://images.pexels.com/photos/1/medium.jpg"},
                    "photographer": "Alice"
                },
                {
                    "src": {"medium": "https://images.pexels.com/photos/2/medium.jpg"},
                    "photographer": "Bob"
                },
                {
                    "src": {"medium": "https://images.pexels.com/photos/1/medium.jpg"},
                    "photographer": "Alice"
                }
            ]
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let images = try decoder.decode([PexelsImage].self, from: data)
            
            // Convert to Set to remove duplicates
            let uniqueImages = Set(images)
            
            #expect(images.count == 3)
            #expect(uniqueImages.count == 2)
        }
        
        @Test("Sort images by photographer name")
        func sortImagesByPhotographer() {
            let image1 = PexelsImage(imageUrl: nil, credits: "Charlie")
            let image2 = PexelsImage(imageUrl: nil, credits: "Alice")
            let image3 = PexelsImage(imageUrl: nil, credits: "Bob")
            
            let images = [image1, image2, image3]
            let sorted = images.sorted { $0.credits < $1.credits }
            
            #expect(sorted[0].credits == "Alice")
            #expect(sorted[1].credits == "Bob")
            #expect(sorted[2].credits == "Charlie")
        }
        
        @Test("Filter images with valid URLs")
        func filterImagesWithValidURLs() {
            let url = URL(string: "https://images.pexels.com/photos/123/medium.jpg")
            let image1 = PexelsImage(imageUrl: url, credits: "Alice")
            let image2 = PexelsImage(imageUrl: nil, credits: "Bob")
            let image3 = PexelsImage(imageUrl: url, credits: "Charlie")
            
            let images = [image1, image2, image3]
            let withURLs = images.filter { $0.imageUrl != nil }
            
            #expect(withURLs.count == 2)
        }
    }
}
