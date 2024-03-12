//
//  ApiRouter.swift
//  Weather
//
//  Created by Ilya Shytsko on 3.03.24.
//

import Foundation
import CoreLocation

struct RequestConfig {
    let path: String
    let method: String
    var params: [String: Any]?
}

enum ApiRouter {
    
    // MARK: - Endpoints

    case currentWeatherRequest(CLLocation)
    case forecastWeatherRequest(CLLocation)
    
    // MARK: - Endpoints configuration

    var config: RequestConfig {
        switch self {
        case let .currentWeatherRequest(location):
            return RequestConfig(
                path: "data/2.5/weather",
                method: "GET",
                params: ["lat": location.coordinate.latitude,
                         "lon": location.coordinate.longitude,
                         "appid": AppConfig.weatherApiKey,
                         "units": "metric"]
            )
            
        case let .forecastWeatherRequest(location):
            return RequestConfig(
                path: "data/2.5/forecast",
                method: "GET",
                params: ["lat": location.coordinate.latitude,
                         "lon": location.coordinate.longitude,
                         "appid": AppConfig.weatherApiKey,
                         "units": "metric"]
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseUrl = URL(string: AppConfig.weatherApiUrl) else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(config.path))
        urlRequest.httpMethod = config.method
        
        if let params = config.params, config.method == "GET" {
            var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
            urlRequest.url = urlComponents?.url
        }
        
        return urlRequest
    }
}
