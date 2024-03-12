//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Ilya Shytsko on 2.03.24.
//

import XCTest
import CoreLocation
@testable import Weather

class ApiClientTests: XCTestCase {

    var apiClient: ApiClient!
    var mockURLSession: MockURLSession!
    let currentLocation: CLLocation = CLLocation(latitude: 37.33233141, longitude: -122.03121860)


    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiClient = ApiClient(session: mockURLSession)
    }

    func testRequestSuccess() async {
        guard let url = Bundle(for: type(of: self)).url(forResource: "mockWeatherData", withExtension: "json"),
                 let jsonData = try? Data(contentsOf: url) else {
               XCTFail("Failed to load test data file")
               return
           }
        
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let result: CurrentWeatherModel = try await apiClient.request(.currentWeatherRequest(currentLocation))
            let expectedModel = try decoder.decode(CurrentWeatherModel.self, from: jsonData)
            XCTAssertEqual(result, expectedModel)
        } catch {
            XCTFail("Expected successful model decoding, but received an error: \(error)")
        }
    }

    func testRequestFailure() async {
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)

        do {
            let _: CurrentWeatherModel = try await apiClient.request(.currentWeatherRequest(currentLocation))
            XCTFail("Expected an error, but request was successful")
        } catch {
        }
    }

    func testNetworkFailure() async {
        mockURLSession.mockError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)

        do {
            let _: CurrentWeatherModel = try await apiClient.request(.currentWeatherRequest(currentLocation))
            XCTFail("Expected a network error, but request was successful")
        } catch {
        }
    }

    override func tearDown() {
        mockURLSession = nil
        apiClient = nil
        super.tearDown()
    }
}

class MockURLSession: URLSessionProtocol {

    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw NSError(domain: "MockURLSessionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data or response is nil."])
        }
        return (data, response)
    }
}

