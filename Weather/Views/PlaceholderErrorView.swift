//
//  PlaceholderErrorView.swift
//  Weather
//
//  Created by Ilya Shytsko on 14.02.24.
//

import UIKit

final class PlaceholderErrorView: UIView {
    static func instance() -> PlaceholderErrorView {
        let view = PlaceholderErrorView().loadNib() as! PlaceholderErrorView
        view.stackView.isHidden = true
        view.messageLabel.text = nil
        view.titleImageView.image = nil
        return view
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    var onRefreshData: (() ->  Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hScreen = UIScreen.main.bounds.height
        let hStack = stackView.frame.height
        let hView = self.bounds.height
        let delta = hScreen == hView ? 48.0 : -48.0
        bottomConstraint.constant = (hScreen - hStack)/2 + delta
    }
    
    var error: Error? {
        didSet {
            isLoading = false
            setMessage(error!.localizedDescription)
            buttonContainerView.isHidden = onRefreshData == nil
        }
    }
    
    func setMessage(_ message: String, imageName: String? = nil) {
        messageLabel.text = message
        titleImageView.isHidden = imageName == nil
        titleImageView.image = imageName.flatMap { UIImage(named: $0) }?.withTintColor(.systemOrange)
        buttonContainerView.isHidden = true
        stackView.isHidden = false
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                stackView.isHidden = true
                messageLabel.text = nil
                titleImageView.image = nil
                buttonContainerView.isHidden = true
                activityView.startAnimating()
            } else {
                activityView.stopAnimating()
                stackView.isHidden = false
            }
        }
    }
    
    @IBAction private func refreshAction(_ sender: Any) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.onRefreshData?()
        }
    }
}
