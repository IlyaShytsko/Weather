//
//  CurrentWeatherModel.swift
//  Weather
//
//  Created by Ilya Shytsko on 3.03.24.
//

import Foundation

struct CurrentWeatherModel: Decodable, Hashable {
    let weather: [Weather]
    let main: Main
}

extension CurrentWeatherModel {
    struct Main: Decodable, Hashable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
    }

    struct Weather: Decodable, Hashable {
        let id: Int
        let main: String
    }
}
