//
//  ForecastWeatherModel.swift
//  Weather
//
//  Created by Ilya Shytsko on 3.03.24.
//

import Foundation

struct ForecastWeatherModel: Decodable, Hashable {
    let list: [Forecast]
}

extension ForecastWeatherModel {
    struct Forecast: Decodable, Hashable {
        let dt: Date
        let main: Main
        let weather: [Weather]
        
        var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: dt)
        }
    }

    struct Main: Decodable, Hashable {
        let temp: Double
    }

    struct Weather: Decodable, Hashable {
        let id: Int
        let main, description, icon: String
    }
}

extension ForecastWeatherModel {
    func filteredForecasts() -> [Forecast] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? calendar.timeZone
        return list.filter { forecast in
            let hour = calendar.component(.hour, from: forecast.dt)
            return hour == 12
        }
    }
}
