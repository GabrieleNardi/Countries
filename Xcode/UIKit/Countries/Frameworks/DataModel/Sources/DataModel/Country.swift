//
//  Country.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation

/// The main model of the application. It represents the main properties of a country.
public struct Country: Codable {
    
    // MARK: - Properties
    
    /// The name of the country in a common and official way.
    public let name: Country.Name
    
    /// The `Flag` of the country,
    public let flag: Country.Flag
    
    /// The continent in which the country is in.
    public let continent: String
    
    /// The languages spoken in the country.
    public let languages: [String]
    
    /// The coordinates, divided into latitude and longitude, of the country.
    public let coordinates: Coordinates
    
    /// The capital of the country.
    public let capital: String
    
    /// The area of the country expressed in km².
    public let area: Int
    
    /// The number of people of the country.
    public let population: Int
    
    /// The timezones of the country.
    public let timezones: [String]
    
    /// The valid currencies in the country.
    public let currencies: [Currency]
    
    /// The name of the country translated into different languages.
    public let translations: [Translation]
    
    // MARK: - Initialization methods
    
    public init(
        name: Country.Name,
        flag: Country.Flag,
        continent: String,
        languages: [String],
        coordinates: Coordinates,
        capital: String, area: Int,
        population: Int,
        timezones: [String],
        currencies: [Currency],
        translations: [Translation]
    ) {
        self.name = name
        self.flag = flag
        self.continent = continent
        self.languages = languages
        self.coordinates = coordinates
        self.capital = capital
        self.area = area
        self.population = population
        self.timezones = timezones
        self.currencies = currencies
        self.translations = translations
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(Country.Name.self, forKey: .name)
        flag = try container.decode(Country.Flag.self, forKey: .flag)
        continent = try container.decode([String].self, forKey: .continent).first ?? "-"
        let languagesDictionary = try container.decode([String: String].self, forKey: .languages)
        languages = Array(languagesDictionary.values)
        let coordinatesArray = try container.decode([Double].self, forKey: .coordinates)
        coordinates = Coordinates(latitude: coordinatesArray[0], longitude: coordinatesArray[1])
        population = try container.decode(Int.self, forKey: .population)
        timezones = try container.decode([String].self, forKey: .timezones)
        let capitalArray = try container.decode([String].self, forKey: .capital)
        capital = capitalArray.first ?? "-"
        let areaDouble = try container.decode(Double.self, forKey: .area)
        area = Int(areaDouble)
        let currencyDict = try container.decode([String: [String: String]].self, forKey: .currencies)
        currencies = currencyDict.reduce(into: [Currency]()) { partialResult, current in
            partialResult.append(Currency(name: current.value["name"] ?? "Currency", symbol: current.value["symbol"] ?? "Symbol"))
        }.sorted(by: { $0.name < $1.name })
        let translationDictionary = try container.decode([String: [String: String]].self, forKey: .translations)
        translations = translationDictionary.reduce(into: [Translation]()) { partialResult, current in
            partialResult.append(Translation(language: current.key, name: current.value["common"] ?? "Language"))
        }.sorted(by: { $0.language < $1.language })
    }
    
    public init(from json: [String: Any]) {
        let nameJSON = json["name"] as? [String: Any]
        name = Name(common: nameJSON?["common"] as? String ?? "-", official: nameJSON?["official"] as? String ?? "-")
        let flagJSON = json["flags"] as? [String: String]
        flag = Flag(url: URL(string: flagJSON?["png"] ?? "-"))
        continent = json["continents"] as? String ?? "-"
        languages = json["languages"] as? [String] ?? []
        let coordinateJSON = json["latlng"] as? [String: Any]
        coordinates =  Coordinates(latitude: coordinateJSON?["latitude"] as? Double ?? 0, longitude: coordinateJSON?["longitude"] as? Double ?? 0)
        population = json["population"] as? Int ?? 0
        timezones = json["timezones"] as? [String] ?? []
        capital = json["capital"] as? String ?? "-"
        area = json["area"] as? Int ?? 0
        let currenciesJSON = json["currencies"] as? [[String: Any]]
        currencies = currenciesJSON?.reduce(into: [Currency]()) { partialResult, current in
            partialResult.append(Currency(name: current["name"] as? String ?? "-", symbol: current["symbol"] as? String ?? "-"))
        } ?? [Currency(name: "-", symbol: "-")]
        let translationsJSON = json["translations"] as? [[String: Any]]
        translations = translationsJSON?.reduce(into: [Translation]()) { partialResult, current in
            partialResult.append(Translation(language: current["language"] as? String ?? "-", name: current["name"] as? String ?? "-"))
        } ?? [Translation(language: "-", name: "-")]
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case name
        case flag = "flags"
        case continent = "continents"
        case languages
        case coordinates = "latlng"
        case capital
        case area
        case population
        case timezones
        case currencies
        case translations
    }
    
    // MARK: - Name
    
    /// The name of the country, divided into common and official.
    public struct Name: Codable {
        
        /// The common name of the country.
        public let common: String
 
        /// The official name of the country.
        public let official: String
    }
    
    // MARK: - Flag
    
    /// The flag of the country.
    public struct Flag: Codable, Equatable {
        
        /// The image url of the country flag.
        public let url: URL?
        
        enum CodingKeys: String, CodingKey {
            case url = "png"
        }
        
        public init(url: URL?) {
            self.url = url
        }
        
        public init(from decoder: Decoder) {
            do {
                let container = try decoder.container(keyedBy: Country.Flag.CodingKeys.self)
                self.url = try container.decodeIfPresent(URL.self, forKey: Country.Flag.CodingKeys.url)
            } catch {
                logger.log(error)
                self.url = nil
            }
        }
    }
    
    // MARK: - Coordinates
    
    /// Standard coordinate system divided into latitude and longitude.
    public struct Coordinates: Codable, Equatable {
        
        /// The latitude of the country.
        public let latitude: Double
        
        /// The longitude of the country.
        public let longitude: Double
    }
    
    // MARK: - Currency
    
    /// A `Currency`.
    public struct Currency: Codable, Equatable {
        
        /// The name of a valid currency into a country.
        public let name: String
        
        /// The symbol of a valid currency into a country.
        public let symbol: String
    }
    
    // MARK: - Translation
    
    /// `Translation` is a structure that provide the translated name and the language in which the name of the country is translated.
    public struct Translation: Codable, Equatable {
        
        /// The language in which the country name is translated.
        public let language: String
        
        /// The name of the country translated.
        public let name: String
    }
}

extension Country {

    /// The unique identifier of the country.
    public var id: UUID { UUID() }
}

// MARK: - Hashable

extension Country: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name.common)
        hasher.combine(flag.url)
        hasher.combine(continent)
    }
}

// MARK: - Equatable

extension Country: Equatable {
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name.common == rhs.name.common
        && lhs.flag.url == rhs.flag.url 
        && lhs.continent == rhs.continent 
        && lhs.area == rhs.area
        && lhs.population == rhs.population
        && lhs.capital == rhs.capital
        && lhs.currencies == rhs.currencies
        && lhs.timezones == rhs.timezones
        && lhs.translations == rhs.translations
    }
}

// MARK: - Comparable

extension Country: Comparable {
    
    public static func < (lhs: Country, rhs: Country) -> Bool {
        lhs.name.common < rhs.name.common
    }
}

// MARK: - Country.Coordinates - CustomStringConvertible

extension Country.Coordinates: CustomStringConvertible {
    
    private static let numberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter
    }()
    
    public var description: String {
        let latitude = Country.Coordinates.numberFormatter.string(from: NSNumber(value: latitude)) ?? "-"
        let longitude = Country.Coordinates.numberFormatter.string(from:  NSNumber(value: longitude)) ?? "-"
        
        return "\(latitude), \(longitude)"
    }
}
