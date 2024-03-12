//
//  ForecastWeatherCell.swift
//  Weather
//
//  Created by Ilya Shytsko on 2.03.24.
//

import UIKit

final class ForecastWeatherCell: UITableViewCell {
    
    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var degreesLabel: UILabel!
    
    var model: ForecastWeatherModel.Forecast? {
        didSet {
            guard let model else { return }
            weekdayLabel.text = model.formattedDate
            degreesLabel.text = "\(Int(model.main.temp))˚"
            
            guard let weather = model.weather.first else { return }
            let icon = Styling.weatherIconImage(for: weather.id)
            weatherImage.image = icon
        }
    }
}
