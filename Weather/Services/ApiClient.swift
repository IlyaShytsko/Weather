//
//  ApiClient.swift
//  Weather
//
//  Created by Ilya Shytsko on 3.03.24.
//

import UIKit

protocol ApiClientProtocol {
    func request<Model: Decodable>(_ route: ApiRouter) async throws -> Model
}

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

final class ApiClient: ApiClientProtocol {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request<Model: Decodable>(_ route: ApiRouter) async throws -> Model {
        guard let urlRequest = try? route.asURLRequest() else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let model = try decoder.decode(Model.self, from: data)
        return model
    }
}

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(from: request.url!)
    }
}
