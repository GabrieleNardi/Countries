//
//  CountryTests.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import XCTest
@testable import DataModel

final class CountryTests: XCTestCase {
    
    // MARK: - Properties
    
    var country: Country!
    
    // MARK: - XCTestCase methods
    
    override func setUp() {
        super.setUp()
        
        country = Country(
            name: Country.Name(
                common: "Italy",
                official: "Italian Republic"
            ),
            flag: Country.Flag(url: URL(string: "https://flagcdn.com/w320/it.png")),
            continent: "Europe",
            languages: ["Italian"],
            coordinates: Country.Coordinates(latitude: 42.83333333, longitude: 12.83333333),
            capital: "Rome",
            area: 301336,
            population: 59554023,
            timezones: ["UTC+01:00"],
            currencies: [Country.Currency(
                name: "Euro",
                symbol: "€"
            )],
            translations: getTranslations()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        country = nil
    }
    
    // MARK: - Tests methods
    
    func test_init_name_common() throws {
        XCTAssertEqual(country.name.common, "Italy")
    }
    
    func test_init_name_official() throws {
        XCTAssertEqual(country.name.official, "Italian Republic")
    }
    
    func test_init_flag() throws {
        XCTAssertEqual(country.flag.url?.absoluteString, "https://flagcdn.com/w320/it.png")
    }
    
    func test_init_continent() throws {
        XCTAssertEqual(country.continent, "Europe")
    }
    
    func test_init_languages() throws {
        XCTAssertEqual(country.languages, ["Italian"])
    }
    
    func test_init_coordinates() throws {
        XCTAssertEqual(country.coordinates, Country.Coordinates(latitude: 42.83333333, longitude: 12.83333333))
    }
    
    func test_init_capital() throws {
        XCTAssertEqual(country.capital, "Rome")
    }
    
    func test_init_area() throws {
        XCTAssertEqual(country.area, 301336)
    }
    
    func test_init_population() throws {
        XCTAssertEqual(country.population, 59554023)
    }
    
    func test_init_timezones() throws {
        XCTAssertEqual(country.timezones, ["UTC+01:00"])
    }
    
    func test_init_currencies() throws {
        XCTAssertEqual(country.currencies, [
            Country.Currency(
                name: "Euro",
                symbol: "€"
            )]
        )
    }
    
    func test_init_translations() throws {
        XCTAssertEqual(country.translations, getTranslations())
    }
    
    func test_decode_name_common() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.name.common, "British Indian Ocean Territory")
    }
    
    func test_decode_name_official() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.name.official, "British Indian Ocean Territory")
    }
    
    func test_decode_flag() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.flag.url?.absoluteString, "https://flagcdn.com/w320/io.png")
    }
    
    func test_decode_continent() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.continent, "Asia")
    }
    
    func test_decode_languages() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.languages, ["Italian"])
    }
    
    func test_decode_coordinates() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.coordinates, Country.Coordinates(latitude: 42.83333333, longitude: 12.83333333))
    }
    
    func test_decode_capital() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.capital, "Rome")
    }
    
    func test_decode_area() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
                
        XCTAssertEqual(country.area, 301336)
    }
    
    func test_decode_population() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.population, 59554023)
    }
    
    func test_decode_timezones() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
                
        XCTAssertEqual(country.timezones, ["UTC+01:00"])
    }
    
    func test_decode_currencies() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
        
        XCTAssertEqual(country.currencies, [
            Country.Currency(
                name: "Euro",
                symbol: "€"
            )]
        )
    }
    
    func test_decode_translations() throws {
        let country: Country = try getDecodableFromJSON(name: "Country")
                
        XCTAssertEqual(country.translations, getTranslations())
    }
    
    func test_decode_performance()  {
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            do {
                let _: Country = try getDecodableFromJSON(name: "Country")
            } catch {
                print("CountryTestError:", error)
            }
        }
    }
    
    private func getTranslations() -> [Country.Translation] {
        [Country.Translation(language: "ara", name: "إيطاليا"),
         Country.Translation(language: "bre", name: "Italia"),
         Country.Translation(language: "ces", name: "Itálie"),
         Country.Translation(language: "cym", name: "Italy"),
         Country.Translation(language: "deu", name: "Italien"),
         Country.Translation(language: "est", name: "Itaalia"),
         Country.Translation(language: "fin", name: "Italia"),
         Country.Translation(language: "fra", name: "Italie"),
         Country.Translation(language: "hrv", name: "Italija"),
         Country.Translation(language: "hun", name: "Olaszország"),
         Country.Translation(language: "ita", name: "Italia"),
         Country.Translation(language: "jpn", name: "イタリア"),
         Country.Translation(language: "kor", name: "이탈리아"),
         Country.Translation(language: "nld", name: "Italië"),
         Country.Translation(language: "per", name: "ایتالیا"),
         Country.Translation(language: "pol", name: "Włochy"),
         Country.Translation(language: "por", name: "Itália"),
         Country.Translation(language: "rus", name: "Италия"),
         Country.Translation(language: "slk", name: "Taliansko"),
         Country.Translation(language: "spa", name: "Italia"),
         Country.Translation(language: "srp", name: "Италија"),
         Country.Translation(language: "swe", name: "Italien"),
         Country.Translation(language: "tur", name: "İtalya"),
         Country.Translation(language: "urd", name: "اطالیہ"),
         Country.Translation(language: "zho", name: "意大利")]
    }
}
