//
//  CountryTests.swift
//  DataModel
//
//  Created by Gabriele Nardi   on 29/10/25.
//


import Testing
import Foundation
@testable import DataModel

@Suite("Country Model Tests")
struct CountryTests {
    
    // MARK: - Test Data
    
    private func createSampleCountry() -> Country {
        Country(
            name: Country.Name(common: "Italy", official: "Italian Republic"),
            flag: Country.Flag(url: URL(string: "https://example.com/flag.png")),
            continent: "Europe",
            languages: ["Italian"],
            coordinates: Country.Coordinates(latitude: 42.8333, longitude: 12.8333),
            capital: "Rome",
            area: 301340,
            population: 60317000,
            timezones: ["UTC+01:00"],
            currencies: [Country.Currency(name: "Euro", symbol: "€")],
            translations: [
                Country.Translation(language: "en", name: "Italy"),
                Country.Translation(language: "fr", name: "Italie")
            ]
        )
    }
    
    private func createSampleJSON() -> [String: Any] {
        [
            "name": [
                "common": "Italy",
                "official": "Italian Republic"
            ],
            "flags": [
                "png": "https://example.com/flag.png"
            ],
            "continents": "Europe",
            "languages": ["Italian"],
            "latlng": [
                "latitude": 42.8333,
                "longitude": 12.8333
            ],
            "capital": "Rome",
            "area": 301340,
            "population": 60317000,
            "timezones": ["UTC+01:00"],
            "currencies": [
                ["name": "Euro", "symbol": "€"]
            ],
            "translations": [
                ["language": "en", "name": "Italy"],
                ["language": "fr", "name": "Italie"]
            ]
        ]
    }
    
    // MARK: - Initialization Tests
    
    @Suite("Initialization Tests")
    struct InitializationTests {
        
        @Test("Initialize country with all properties")
        func initializeWithAllProperties() {
            let country = Country(
                name: Country.Name(common: "France", official: "French Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/france.png")),
                continent: "Europe",
                languages: ["French"],
                coordinates: Country.Coordinates(latitude: 46.2276, longitude: 2.2137),
                capital: "Paris",
                area: 551695,
                population: 67391000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "France")]
            )
            
            #expect(country.name.common == "France")
            #expect(country.capital == "Paris")
            #expect(country.continent == "Europe")
            #expect(country.area == 551695)
            #expect(country.population == 67391000)
        }
        
        @Test("Initialize country from JSON dictionary")
        func initializeFromJSON() {
            let json: [String: Any] = [
                "name": [
                    "common": "Germany",
                    "official": "Federal Republic of Germany"
                ],
                "flags": ["png": "https://example.com/germany.png"],
                "continents": "Europe",
                "languages": ["German"],
                "latlng": ["latitude": 51.0, "longitude": 9.0],
                "capital": "Berlin",
                "area": 357114,
                "population": 83240000,
                "timezones": ["UTC+01:00"],
                "currencies": [["name": "Euro", "symbol": "€"]],
                "translations": [["language": "en", "name": "Germany"]]
            ]
            
            let country = Country(from: json)
            
            #expect(country.name.common == "Germany")
            #expect(country.capital == "Berlin")
        }
        
        @Test("Initialize country with missing JSON fields uses defaults")
        func initializeWithMissingFields() {
            let json: [String: Any] = [
                "name": ["common": "Unknown"],
                "flags": [:],
                "continents": [:],
                "languages": [:],
                "latlng": [:],
                "capital": [:],
                "area": 0,
                "population": 0,
                "timezones": [],
                "currencies": [],
                "translations": []
            ]
            
            let country = Country(from: json)
            
            #expect(country.name.common == "Unknown")
            #expect(country.capital == "-")
            #expect(country.continent == "-")
        }
    }
    
    // MARK: - Codable Tests
    
    @Suite("Codable Tests")
    struct CodableTests {
        
        @Test("Encode country")
        func encodeDecodeCountry() {
            let original = Country(
                name: Country.Name(common: "Spain", official: "Kingdom of Spain"),
                flag: Country.Flag(url: URL(string: "https://example.com/spain.png")),
                continent: "Europe",
                languages: ["Spanish"],
                coordinates: Country.Coordinates(latitude: 40.4637, longitude: -3.7492),
                capital: "Madrid",
                area: 505990,
                population: 47350000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "Spain")]
            )
            
            let data = try? JSONEncoder().encode(original)
            #expect(data != nil)
        }
        
        @Test("Decode country from JSON with array format")
        func decodeFromJSONArray() throws {
            let json = """
            {
                "name": {
                    "common": "Portugal",
                    "official": "Portuguese Republic"
                },
                "flags": {
                    "png": "https://example.com/portugal.png"
                },
                "continents": ["Europe"],
                "languages": {
                    "por": "Portuguese"
                },
                "latlng": [39.5, -8.0],
                "capital": ["Lisbon"],
                "area": 92090.0,
                "population": 10305000,
                "timezones": ["UTC"],
                "currencies": {
                    "EUR": {
                        "name": "Euro",
                        "symbol": "€"
                    }
                },
                "translations": {
                    "en": {
                        "common": "Portugal"
                    }
                }
            }
            """
            
            let data = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let country = try decoder.decode(Country.self, from: data)
            
            #expect(country.name.common == "Portugal")
            #expect(country.capital == "Lisbon")
            #expect(country.continent == "Europe")
            #expect(country.languages.contains("Portuguese"))
            #expect(country.currencies.first?.name == "Euro")
        }
    }
    
    // MARK: - Equatable Tests
    
    @Suite("Equatable Tests")
    struct EquatableTests {
        
        @Test("Equal countries are equal")
        func equalCountries() {
            let country1 = Country(
                name: Country.Name(common: "Italy", official: "Italian Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/italy.png")),
                continent: "Europe",
                languages: ["Italian"],
                coordinates: Country.Coordinates(latitude: 42.8333, longitude: 12.8333),
                capital: "Rome",
                area: 301340,
                population: 60317000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "Italy")]
            )
            
            let country2 = country1
            
            #expect(country1 == country2)
        }
        
        @Test("Different countries are not equal")
        func differentCountries() {
            let italy = Country(
                name: Country.Name(common: "Italy", official: "Italian Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/italy.png")),
                continent: "Europe",
                languages: ["Italian"],
                coordinates: Country.Coordinates(latitude: 42.8333, longitude: 12.8333),
                capital: "Rome",
                area: 301340,
                population: 60317000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "Italy")]
            )
            
            let france = Country(
                name: Country.Name(common: "France", official: "French Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/france.png")),
                continent: "Europe",
                languages: ["French"],
                coordinates: Country.Coordinates(latitude: 46.2276, longitude: 2.2137),
                capital: "Paris",
                area: 551695,
                population: 67391000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "France")]
            )
            
            #expect(italy != france)
        }
    }
    
    // MARK: - Hashable Tests
    
    @Suite("Hashable Tests")
    struct HashableTests {
        
        @Test("Countries can be used in Set")
        func countriesInSet() {
            let italy = Country(
                name: Country.Name(common: "Italy", official: "Italian Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/italy.png")),
                continent: "Europe",
                languages: ["Italian"],
                coordinates: Country.Coordinates(latitude: 42.8333, longitude: 12.8333),
                capital: "Rome",
                area: 301340,
                population: 60317000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "Italy")]
            )
            
            let france = Country(
                name: Country.Name(common: "France", official: "French Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/france.png")),
                continent: "Europe",
                languages: ["French"],
                coordinates: Country.Coordinates(latitude: 46.2276, longitude: 2.2137),
                capital: "Paris",
                area: 551695,
                population: 67391000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "France")]
            )
            
            let set: Set<Country> = [italy, france, italy]
            
            #expect(set.count == 2)
        }
        
        @Test("Countries can be used as Dictionary keys")
        func countriesAsDictionaryKeys() {
            let italy = Country(
                name: Country.Name(common: "Italy", official: "Italian Republic"),
                flag: Country.Flag(url: URL(string: "https://example.com/italy.png")),
                continent: "Europe",
                languages: ["Italian"],
                coordinates: Country.Coordinates(latitude: 42.8333, longitude: 12.8333),
                capital: "Rome",
                area: 301340,
                population: 60317000,
                timezones: ["UTC+01:00"],
                currencies: [Country.Currency(name: "Euro", symbol: "€")],
                translations: [Country.Translation(language: "en", name: "Italy")]
            )
            
            var dict: [Country: String] = [:]
            dict[italy] = "Italian"
            
            #expect(dict[italy] == "Italian")
        }
    }
    
    // MARK: - Comparable Tests
    
    @Suite("Comparable Tests")
    struct ComparableTests {
        
        @Test("Countries are sorted alphabetically by common name")
        func sortCountriesAlphabetically() {
            let france = Country(
                name: Country.Name(common: "France", official: "French Republic"),
                flag: Country.Flag(url: nil),
                continent: "Europe",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Paris",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            let italy = Country(
                name: Country.Name(common: "Italy", official: "Italian Republic"),
                flag: Country.Flag(url: nil),
                continent: "Europe",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Rome",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            let germany = Country(
                name: Country.Name(common: "Germany", official: "Federal Republic of Germany"),
                flag: Country.Flag(url: nil),
                continent: "Europe",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Berlin",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            let countries = [italy, france, germany].sorted()
            
            #expect(countries[0].name.common == "France")
            #expect(countries[1].name.common == "Germany")
            #expect(countries[2].name.common == "Italy")
        }
        
        @Test("Country comparison operators work correctly")
        func comparisonOperators() {
            let aCountry = Country(
                name: Country.Name(common: "A", official: "A"),
                flag: Country.Flag(url: nil),
                continent: "",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            let bCountry = Country(
                name: Country.Name(common: "B", official: "B"),
                flag: Country.Flag(url: nil),
                continent: "",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            #expect(aCountry < bCountry)
            #expect(bCountry > aCountry)
            #expect(aCountry <= bCountry)
            #expect(bCountry >= aCountry)
        }
    }
    
    // MARK: - Nested Types Tests
    
    @Suite("Nested Types Tests")
    struct NestedTypesTests {
        
        @Test("Country.Name initialization")
        func countryNameInitialization() {
            let name = Country.Name(common: "Italy", official: "Italian Republic")
            
            #expect(name.common == "Italy")
            #expect(name.official == "Italian Republic")
        }
        
        @Test("Country.Flag initialization with valid URL")
        func flagWithValidURL() {
            let flag = Country.Flag(url: URL(string: "https://example.com/flag.png"))
            
            #expect(flag.url != nil)
            #expect(flag.url?.absoluteString == "https://example.com/flag.png")
        }
        
        @Test("Country.Flag initialization with nil URL")
        func flagWithNilURL() {
            let flag = Country.Flag(url: nil)
            
            #expect(flag.url == nil)
        }
        
        @Test("Country.Flag equality")
        func flagEquality() {
            let flag1 = Country.Flag(url: URL(string: "https://example.com/flag.png"))
            let flag2 = Country.Flag(url: URL(string: "https://example.com/flag.png"))
            let flag3 = Country.Flag(url: URL(string: "https://example.com/other.png"))
            
            #expect(flag1 == flag2)
            #expect(flag1 != flag3)
        }
        
        @Test("Country.Coordinates initialization")
        func coordinatesInitialization() {
            let coordinates = Country.Coordinates(latitude: 41.9028, longitude: 12.4964)
            
            #expect(coordinates.latitude == 41.9028)
            #expect(coordinates.longitude == 12.4964)
        }
        
        @Test("Country.Coordinates equality")
        func coordinatesEquality() {
            let coord1 = Country.Coordinates(latitude: 41.9, longitude: 12.5)
            let coord2 = Country.Coordinates(latitude: 41.9, longitude: 12.5)
            let coord3 = Country.Coordinates(latitude: 40.0, longitude: 10.0)
            
            #expect(coord1 == coord2)
            #expect(coord1 != coord3)
        }
        
        @Test("Country.Coordinates CustomStringConvertible")
        func coordinatesDescription() {
            let coordinates = Country.Coordinates(latitude: 41.90, longitude: 12.49)
            let description = coordinates.description
            
            // Should format with locale-specific decimal separator
            #expect(description.contains("41"))
            #expect(description.contains("12"))
        }
        
        @Test("Country.Currency initialization")
        func currencyInitialization() {
            let currency = Country.Currency(name: "Euro", symbol: "€")
            
            #expect(currency.name == "Euro")
            #expect(currency.symbol == "€")
        }
        
        @Test("Country.Currency equality")
        func currencyEquality() {
            let euro1 = Country.Currency(name: "Euro", symbol: "€")
            let euro2 = Country.Currency(name: "Euro", symbol: "€")
            let dollar = Country.Currency(name: "Dollar", symbol: "$")
            
            #expect(euro1 == euro2)
            #expect(euro1 != dollar)
        }
        
        @Test("Country.Translation initialization")
        func translationInitialization() {
            let translation = Country.Translation(language: "en", name: "Italy")
            
            #expect(translation.language == "en")
            #expect(translation.name == "Italy")
        }
        
        @Test("Country.Translation equality")
        func translationEquality() {
            let trans1 = Country.Translation(language: "en", name: "Italy")
            let trans2 = Country.Translation(language: "en", name: "Italy")
            let trans3 = Country.Translation(language: "fr", name: "Italie")
            
            #expect(trans1 == trans2)
            #expect(trans1 != trans3)
        }
    }
    
    // MARK: - Properties Tests
    
    @Suite("Properties Tests")
    struct PropertiesTests {
        
        @Test("Country id generates unique UUID")
        func uniqueID() {
            let country = Country(
                name: Country.Name(common: "Italy", official: "Italian Republic"),
                flag: Country.Flag(url: nil),
                continent: "Europe",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Rome",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            let id1 = country.id
            let id2 = country.id
            
            // Each call should generate a new UUID
            #expect(id1 != id2)
        }
        
        @Test("Multiple languages are stored correctly")
        func multipleLanguages() {
            let country = Country(
                name: Country.Name(common: "Belgium", official: "Kingdom of Belgium"),
                flag: Country.Flag(url: nil),
                continent: "Europe",
                languages: ["Dutch", "French", "German"],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Brussels",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            #expect(country.languages.count == 3)
            #expect(country.languages.contains("Dutch"))
            #expect(country.languages.contains("French"))
            #expect(country.languages.contains("German"))
        }
        
        @Test("Multiple currencies are stored correctly")
        func multipleCurrencies() {
            let country = Country(
                name: Country.Name(common: "Test", official: "Test"),
                flag: Country.Flag(url: nil),
                continent: "Test",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Test",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [
                    Country.Currency(name: "Dollar", symbol: "$"),
                    Country.Currency(name: "Euro", symbol: "€")
                ],
                translations: []
            )
            
            #expect(country.currencies.count == 2)
        }
        
        @Test("Multiple timezones are stored correctly")
        func multipleTimezones() {
            let country = Country(
                name: Country.Name(common: "Russia", official: "Russian Federation"),
                flag: Country.Flag(url: nil),
                continent: "Europe",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Moscow",
                area: 0,
                population: 0,
                timezones: ["UTC+02:00", "UTC+03:00", "UTC+04:00"],
                currencies: [],
                translations: []
            )
            
            #expect(country.timezones.count == 3)
        }
    }
    
    // MARK: - Edge Cases
    
    @Suite("Edge Cases")
    struct EdgeCaseTests {
        
        @Test("Country with empty arrays")
        func emptyArrays() {
            let country = Country(
                name: Country.Name(common: "Test", official: "Test"),
                flag: Country.Flag(url: nil),
                continent: "Test",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Test",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            #expect(country.languages.isEmpty)
            #expect(country.timezones.isEmpty)
            #expect(country.currencies.isEmpty)
            #expect(country.translations.isEmpty)
        }
        
        @Test("Country with zero population and area")
        func zeroValues() {
            let country = Country(
                name: Country.Name(common: "Test", official: "Test"),
                flag: Country.Flag(url: nil),
                continent: "Test",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Test",
                area: 0,
                population: 0,
                timezones: [],
                currencies: [],
                translations: []
            )
            
            #expect(country.area == 0)
            #expect(country.population == 0)
        }
        
        @Test("Coordinates with negative values")
        func negativeCoordinates() {
            let coordinates = Country.Coordinates(latitude: -41.9, longitude: -12.5)
            
            #expect(coordinates.latitude == -41.9)
            #expect(coordinates.longitude == -12.5)
        }
        
        @Test("Very large population and area values")
        func largeValues() {
            let country = Country(
                name: Country.Name(common: "Test", official: "Test"),
                flag: Country.Flag(url: nil),
                continent: "Test",
                languages: [],
                coordinates: Country.Coordinates(latitude: 0, longitude: 0),
                capital: "Test",
                area: 17098242, // Russia's area
                population: 1425000000, // China's population
                timezones: [],
                currencies: [],
                translations: []
            )
            
            #expect(country.area == 17098242)
            #expect(country.population == 1425000000)
        }
    }
}
