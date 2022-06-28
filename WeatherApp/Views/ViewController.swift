//
//  ViewController.swift
//  WeatherApp
//
//  Created by MAC on 28.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var weatherIconImageView = UIImageView()
    var cityLabel = UILabel()
    var temperatureLabel =  UILabel()
    var feelsLikeTemperature = UILabel()
    var searchButton = UIButton()
    var backgroundImage = UIImageView()
    
    var networkWeatherManager = NetworkWeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constraint()
        
        searchButton.addTarget(self, action: #selector(openAlert), for: .touchUpInside)
        
        networkWeatherManager.fetchCurrentWeather(forCity: "Almaty")
        
        networkWeatherManager.completionHandler = {[weak self] currentWeather in
            self?.updateInterface(weather: currentWeather)
        }
    }
    
        @objc func openAlert() {
            self.presentSearchAlertController(withTitle: "Entry city name", message: nil, style: .alert) { [unowned self] cityName in
            self.networkWeatherManager.fetchCurrentWeather(forCity: cityName)
        }
    }
    
    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString + "ºC"
            self.feelsLikeTemperature.text = "Feels like: " + weather.feelsLikeTemperatureString + "ºC"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func configure() {
        weatherIconImageView.image = UIImage(systemName: "weather")
        
        temperatureLabel.text = "25ºC"
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 20)
        temperatureLabel.font = UIFont.systemFont(ofSize: 60)

        
        feelsLikeTemperature.text = "Feels like 20ºC"
        feelsLikeTemperature.font = UIFont.systemFont(ofSize: 20)
        
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        cityLabel.text = "City"
        cityLabel.font = UIFont.systemFont(ofSize: 25)
        
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    private func constraint() {
        view.addSubview(backgroundImage)
        view.addSubview(weatherIconImageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(feelsLikeTemperature)
        view.addSubview(searchButton)

        
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTemperature.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherIconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 120),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 150),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -15),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: weatherIconImageView.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: feelsLikeTemperature.topAnchor, constant: -15),
            
            feelsLikeTemperature.trailingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor , constant: 0),
            
            searchButton.topAnchor.constraint(equalTo: feelsLikeTemperature.bottomAnchor, constant: 400),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            searchButton.heightAnchor.constraint(equalTo: cityLabel.heightAnchor),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: searchButton.topAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -15),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

