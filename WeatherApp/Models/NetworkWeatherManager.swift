//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by MAC on 28.06.2022.
//

import Foundation

class NetworkWeatherManager {
    var completionHandler: ((CurrentWeather)->Void)?

    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.completionHandler?(currentWeather)
                } //self bcs we call method in closure
            }
        }
        task.resume()
    }
    
    //JSON Parsing
    func parseJSON(withData data: Data) -> CurrentWeather? {
        do {
            let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {return nil}
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
