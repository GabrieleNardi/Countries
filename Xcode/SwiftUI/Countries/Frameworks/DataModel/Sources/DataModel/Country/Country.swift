//
//  Country.swift
//
//
//  Created by Gabriele Nardi on 29/10/25.
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
        capital: String,
        area: Int,
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
        
        let continent = (try? container.decode([String].self, forKey: .continent).first) ?? ""
        self.continent = continent.isEmpty ? try container.decode(String.self, forKey: .continent) : continent
        
        languages = Array(try container.decode([String: String].self, forKey: .languages).values)
        
        let coordinatesArray = try container.decode([Double].self, forKey: .coordinates)
        coordinates = Coordinates(latitude: coordinatesArray[0], longitude: coordinatesArray[1])
        
        population = try container.decode(Int.self, forKey: .population)
        
        timezones = try container.decode([String].self, forKey: .timezones)
        
        capital = try container.decode([String].self, forKey: .capital).first ?? "-"
        
        area = Int(try container.decode(Double.self, forKey: .area))
        
        currencies = try container.decode([String: [String: String]].self, forKey: .currencies)
            .reduce(into: [Currency]()) { partialResult, current in
                partialResult.append(Currency(name: current.value["name"] ?? "Currency", symbol: current.value["symbol"] ?? "Symbol"))
            }
            .sorted(by: { $0.name < $1.name })
        
        translations = try container.decode([String: [String: String]].self, forKey: .translations)
            .reduce(into: [Translation]()) { partialResult, current in
                partialResult.append(Translation(language: current.key, name: current.value["common"] ?? "Language"))
            }
            .sorted(by: { $0.language < $1.language })
    }
    
    public init(from json: [String: Any]) {
        let nameJSON = json["name"] as? [String: Any]
        
        name = Name(common: nameJSON?["common"] as? String ?? "-", official: nameJSON?["official"] as? String ?? "-")
        
        flag = Flag(url: URL(string: (json["flags"] as? [String: String])?["png"] ?? "-"))
        
        continent = json["continents"] as? String ?? "-"
        
        languages = json["languages"] as? [String] ?? []
        
        let coordinateJSON = json["latlng"] as? [String: Any]
        coordinates =  Coordinates(latitude: coordinateJSON?["latitude"] as? Double ?? 0, longitude: coordinateJSON?["longitude"] as? Double ?? 0)
        
        population = json["population"] as? Int ?? 0
        
        timezones = json["timezones"] as? [String] ?? []
        
        capital = json["capital"] as? String ?? "-"
        
        area = json["area"] as? Int ?? 0
        
        currencies = (json["currencies"] as? [[String: Any]])?
            .reduce(into: [Currency]()) { partialResult, current in
            partialResult.append(Currency(name: current["name"] as? String ?? "-", symbol: current["symbol"] as? String ?? "-"))
        } ?? [Currency(name: "-", symbol: "-")]
        
        translations = (json["translations"] as? [[String: Any]])?.reduce(into: [Translation]()) { partialResult, current in
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
