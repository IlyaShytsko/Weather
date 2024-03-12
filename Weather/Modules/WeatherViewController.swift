//
//  WeatherViewController.swift
//  Weather
//
//  Created by Ilya Shytsko on 2.03.24.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var currentLocation: CLLocation?
    private var dataSource: UITableViewDiffableDataSource<WeatherSections, TableViewItem>!
    
    private let locationManager = LocationManager()
    private let apiClient: ApiClientProtocol = ApiClient()
    
    private lazy var placeholderErrorView: PlaceholderErrorView = {
        let view = PlaceholderErrorView.instance()
        view.onRefreshData = { [weak self] in
            self?.getCurrentLocation()
        }
        return view
    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        placeholderErrorView.isLoading = true
        tableView.backgroundView = placeholderErrorView
    }
    
    private func getCurrentLocation() {
        locationManager.getCurrentLocation { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let location):
                currentLocation = location
                loadWeather()
            case .failure(let error):
                placeholderErrorView.isLoading = false
                placeholderErrorView.error = error
                tableView.backgroundView = placeholderErrorView
            }
        }
    }
    
    private func loadWeather() {
        guard let currentLocation else { return }
        
        Task {
            do {
                let current: CurrentWeatherModel = try await apiClient.request(.currentWeatherRequest(currentLocation))
                let forecast: ForecastWeatherModel = try await apiClient.request(.forecastWeatherRequest(currentLocation))
                
                updateBackgroundColor(for: current)
                performTableUpdate(currentModel: current, forecastModel: forecast.filteredForecasts())
                placeholderErrorView.isLoading = false
                tableView.backgroundView = nil
            } catch {
                placeholderErrorView.isLoading = false
                placeholderErrorView.error = error
                tableView.backgroundView = placeholderErrorView
            }
        }
    }
    
    private func updateBackgroundColor(for model: CurrentWeatherModel) {
        guard let weatherModel = model.weather.first else { return }
        view.backgroundColor = Styling.backgroundColor(for: weatherModel.id)
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    enum WeatherSections { case current, forecast }
    
    enum TableViewItem: Hashable {
        case current(CurrentWeatherModel)
        case forecast(ForecastWeatherModel.Forecast)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<WeatherSections, TableViewItem>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .current(let currentWeatherModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.reuseIdentifier, for: indexPath) as! CurrentWeatherCell
                cell.model = currentWeatherModel
                return cell
                
            case .forecast(let forecastWeatherModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: ForecastWeatherCell.reuseIdentifier, for: indexPath) as! ForecastWeatherCell
                cell.model = forecastWeatherModel
                return cell
            }
        }
    }
    
    private func performTableUpdate(currentModel: CurrentWeatherModel, forecastModel: [ForecastWeatherModel.Forecast]) {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherSections, TableViewItem>()
        
        snapshot.appendSections([.current])
        snapshot.appendItems([.current(currentModel)], toSection: .current)
        
        snapshot.appendSections([.forecast])
        let forecastItems = forecastModel.map{TableViewItem.forecast($0)}
        snapshot.appendItems(forecastItems, toSection: .forecast)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.frame.height / 2
        }
        return tableView.rowHeight
    }
}
