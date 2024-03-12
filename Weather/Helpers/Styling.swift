//
//  Styling.swift
//  Weather
//
//  Created by Ilya Shytsko on 4.03.24.
//

import UIKit

struct Styling {
    static let cloudlyColor = UIColor(named: "cloudly")     ?? UIColor(hexString: "54717A")
    static let rainyColor = UIColor(named: "rainy")         ?? UIColor(hexString: "57575D")
    static let sunnyColor = UIColor(named: "sunny")         ?? UIColor(hexString: "47AB2F")
    
    static func weatherImageBackground(for id: Int) -> UIImage? {
        switch id {
        case 200...699:
            return UIImage(named: "forest_rainy")
        case 700...799:
            return UIImage(named: "forest_cloudy")
        case 800:
            return UIImage(named: "forest_sunny")
        case 801...899:
            return UIImage(named: "forest_cloudy")
        default:
            return UIImage(named: "forest_sunny")
        }
    }
    
    static func weatherIconImage(for id: Int) -> UIImage? {
        switch id {
        case 200...699:
            return UIImage(named: "rain")
        case 700...799:
            return UIImage(named: "partlysunny")
        case 800:
            return UIImage(named: "clear")
        case 801...899:
            return UIImage(named: "partlysunny")
        default:
            return UIImage(named: "clear")
        }
    }
    
    static func backgroundColor(for id: Int) -> UIColor? {
        switch id {
        case 200...699:
            return rainyColor
        case 700...799:
            return cloudlyColor
        case 800:
            return sunnyColor
        case 801...899:
            return cloudlyColor
        default:
            return sunnyColor
        }
    }
}
