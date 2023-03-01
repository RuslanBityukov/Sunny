//
//  Weater.swift
//  Sunny
//
//  Created by Руслан Битюков on 22.12.2022.
//

import Foundation

struct Weater: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
}

struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct Weather: Codable {
    let id: Int
    
    var idIconString: String {
        switch id {
            
        case 200...232: return "Atmosphere"
        case 300...321: return "Drizzle"
        case 500...531: return "Rain"
        case 600...622: return "Snow"
        case 701...781: return "Atmosphere"
        case 800: return "Clear"
        case 801...804: return "Clouds"
            
        default: return "Error"
        }
    }
}

struct Wind: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Int
}


