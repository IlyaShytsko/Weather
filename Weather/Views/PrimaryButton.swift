//
//  PrimaryButton.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import UIKit

final class PrimaryButton: UIButton {
    override var isEnabled: Bool {
        willSet {
            layoutSubviews()
        }
    }
    
    convenience init() {
        self.init(type: .custom)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        backgroundColor = isEnabled ? UIColor.systemOrange : UIColor.lightGray
        titleLabel?.textColor = isEnabled ? .white : UIColor.darkGray
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)

        backgroundColor = UIColor.systemOrange
        setTitleColor(.white, for: .normal)
        roundCorners(radius: 10)
        
        titleLabel?.minimumScaleFactor = 0.2
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
