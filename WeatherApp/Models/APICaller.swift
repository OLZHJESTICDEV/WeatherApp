//
//  APICaller.swift
//  WeatherApp
//
//  Created by MAC on 30.06.2022.
//

import Foundation

class APICaller {
    
    var completionHandler: ((CurrentWeather)->Void)?
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {return}
        
        request(url: url, expecting: CurrentWeatherData.self, completion: {result in
            switch result {
            case .success(let data):
                guard let currentWeather = CurrentWeather(currentWeatherData: data) else {return}
                self.completionHandler?(currentWeather)
            
            case .failure(let error):
                print(error)
            }
        })
        
        
    }
    
    private enum APIError: Error {
        case invalidUrl
        case noDataReturned
    }
    
    //Когда вызовем снаружи возьмем уже декодированный result из клоужера (но не приведенный)
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping(Result<T,Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.invalidUrl))
            return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
        
            do {
                let resultData = try JSONDecoder().decode(expecting, from: data)
                completion(.success(resultData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
