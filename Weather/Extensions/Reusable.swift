//
//  Reusable.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}
