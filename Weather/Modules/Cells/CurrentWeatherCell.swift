//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by Ilya Shytsko on 2.03.24.
//

import UIKit

final class CurrentWeatherCell: UITableViewCell {
    
    @IBOutlet private weak var mainTempLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var tempMinLabel: UILabel!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var tempMaxLabel: UILabel!
    
    var model: CurrentWeatherModel? {
        didSet {
            guard let model else { return }
            
            mainTempLabel.text = "\(Int(model.main.temp))˚"
            weatherDescriptionLabel.text = model.weather.first?.main.uppercased() ?? ""
            tempMinLabel.text = "\(Int(model.main.tempMin))˚"
            currentTempLabel.text = "\(Int(model.main.temp))˚"
            tempMaxLabel.text = "\(Int(model.main.tempMax))˚"
            
            guard let weather = model.weather.first else { return }
            let backgroundImage = Styling.weatherImageBackground(for: weather.id)
            weatherImage.image = backgroundImage
        }
    }
}
