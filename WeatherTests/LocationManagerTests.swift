//
//  LocationManagerTests.swift
//  WeatherTests
//
//  Created by Ilya Shytsko on 2.03.24.
//

import XCTest
import CoreLocation

@testable import Weather

final class LocationManagerTests: XCTestCase {
    func testLocationManager_WhenAuthorized_StartsUpdatingLocation() {
        let mockLocationManager = MockCLLocationManager()
        let locationManager = LocationManager(locationManager: mockLocationManager)
        mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
        
        locationManager.getCurrentLocation { _ in }
        XCTAssertTrue(mockLocationManager.didStartUpdatingLocation)
    }
    
    func testLocationManager_WhenAuthorizationNotDetermined_RequestsAuthorization() {
        let mockLocationManager = MockCLLocationManager()
        let locationManager = LocationManager(locationManager: mockLocationManager)
        
        locationManager.getCurrentLocation { _ in }
        
        XCTAssertTrue(mockLocationManager.didRequestWhenInUseAuthorization)
    }
    
    func testLocationManager_WhenAuthorizationDenied_ReturnsError() {
        let mockLocationManager = MockCLLocationManager()
        mockLocationManager.mockAuthorizationStatus = .denied
        let locationManager = LocationManager(locationManager: mockLocationManager)
        let expectation = self.expectation(description: "AuthorizationDenied")
        
        locationManager.getCurrentLocation { result in
            if case .failure(let error as LocationError) = result, error == .denied {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLocationManager_WhenAuthorizationRestricted_ReturnsError() {
        let mockLocationManager = MockCLLocationManager()
        mockLocationManager.mockAuthorizationStatus = .restricted
        let locationManager = LocationManager(locationManager: mockLocationManager)
        let expectation = self.expectation(description: "AuthorizationRestricted")
        
        locationManager.getCurrentLocation { result in
            if case .failure(let error as LocationError) = result, error == .restricted {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLocationManager_ReceivingLocations_UpdatesLocation() {
        let mockLocationManager = MockCLLocationManager()
        let locationManager = LocationManager(locationManager: mockLocationManager)
        let expectedLocation = CLLocation(latitude: 10.0, longitude: 10.0)
        mockLocationManager.onUpdatingLocation = { return [expectedLocation] }
        let expectation = self.expectation(description: "LocationUpdated")

        locationManager.getCurrentLocation { result in
            if case .success(let location) = result, location.coordinate.latitude == expectedLocation.coordinate.latitude, location.coordinate.longitude == expectedLocation.coordinate.longitude {
                expectation.fulfill()
            }
        }

        mockLocationManager.simulateLocationUpdate()
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLocationManager_OnLocationUpdateError_ReturnsError() {
        let mockLocationManager = MockCLLocationManager()
        let locationManager = LocationManager(locationManager: mockLocationManager)
        let sampleError = NSError(domain: "com.LocationManagerTests", code: 1, userInfo: nil)
        mockLocationManager.onFailWithError = { return sampleError }
        let expectation = self.expectation(description: "LocationUpdateError")

        locationManager.getCurrentLocation { result in
            if case .failure(let error) = result, (error as NSError).code == sampleError.code {
                expectation.fulfill()
            }
        }

        mockLocationManager.simulateLocationFailure()
        waitForExpectations(timeout: 1, handler: nil)
    }

}
    
class MockCLLocationManager: CLLocationManager {
    var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    var didRequestWhenInUseAuthorization = false
    var didStartUpdatingLocation = false
    var didStopUpdatingLocation = false

    var onUpdatingLocation: (() -> [CLLocation])?
    var onFailWithError: (() -> Error)?

    override var authorizationStatus: CLAuthorizationStatus {
        return mockAuthorizationStatus
    }

    override func requestWhenInUseAuthorization() {
        didRequestWhenInUseAuthorization = true
    }

    override func startUpdatingLocation() {
        didStartUpdatingLocation = true
    }

    override func stopUpdatingLocation() {
        didStopUpdatingLocation = true
    }

    func simulateLocationUpdate() {
        if let locations = onUpdatingLocation?() {
            delegate?.locationManager?(self, didUpdateLocations: locations)
        }
    }

    func simulateLocationFailure() {
        if let error = onFailWithError?() {
            delegate?.locationManager?(self, didFailWithError: error)
        }
    }
}
