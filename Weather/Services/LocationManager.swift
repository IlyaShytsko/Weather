//
//  LocationManager.swift
//  Weather
//
//  Created by Ilya Shytsko on 2.03.24.
//

import CoreLocation

final class LocationManager: NSObject {
    private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }

    private var locationFetchCompletion: ((Result<CLLocation, Error>) -> Void)?

    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationFetchCompletion = completion
        do {
            try requestLocationUpdates()
        } catch {
            completion(.failure(error))
        }
    }

    private func requestLocationUpdates() throws {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            throw LocationError.denied
        case .restricted:
            throw LocationError.restricted
        default:
            throw LocationError.unexpectedStatus
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        do {
            try requestLocationUpdates()
        } catch {
            locationFetchCompletion?(.failure(error))
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        locationManager.stopUpdatingLocation()
        locationFetchCompletion?(.success(location))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        locationFetchCompletion?(.failure(LocationError(error: error)))
    }
}

enum LocationError: Error, Equatable {
    case denied
    case restricted
    case unexpectedStatus
    case customError(Error)

    init(error: Error) {
        switch (error as NSError).code {
            case CLError.denied.rawValue:
                self = .denied
            case CLError.network.rawValue:
                self = .restricted
            default:
                self = .customError(error)
        }
    }
    
    static func == (lhs: LocationError, rhs: LocationError) -> Bool {
           switch (lhs, rhs) {
           case (.denied, .denied), (.restricted, .restricted), (.unexpectedStatus, .unexpectedStatus):
               return true
           case (.customError(let lhsError), .customError(let rhsError)):
               return (lhsError as NSError).code == (rhsError as NSError).code
           default:
               return false
           }
       }
}
