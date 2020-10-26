//
//  WeatherNetAPIServise.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 20.10.20.
//

import UIKit

protocol WeatherNetAPIService {
    var currentLocation: GeolocationSevice! { get set }
    func getCurrentWeather (completion: @escaping(Result<CurrentWeatherData?, Error>) -> Void)
    func getWeatheImage ( imageIndex: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
    func getWeekWeather (completion: @escaping(Result<WeekForecast?, Error>) -> Void)
    init(location: GeolocationSevice)
}


class OpenWeatherAPIService: WeatherNetAPIService {
    
    var currentLocation: GeolocationSevice!
    
    required init(location: GeolocationSevice) {
        currentLocation = location
    }
    
    func getCurrentWeather(completion: @escaping (Result<CurrentWeatherData?, Error>) -> Void) {
        let urlString =
        "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLocation.lat)&lon=\(currentLocation.lon)&units=metric&appid=a5fbd45eb862a80d161c5fb8d6c86008"
        
        guard let url =  URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(CurrentWeatherData.self, from: data!)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getWeatheImage(imageIndex: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let urlString = "https://openweathermap.org/img/wn/\(imageIndex)@2x.png"
        guard let url =  URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let error = error, data == nil {
                completion(.failure(error))
                return
            }
            
            let image = UIImage(data: data!)
            completion(.success(image))
            
        }.resume()
    }
    
    func getWeekWeather(completion: @escaping (Result<WeekForecast?, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(currentLocation.lat)&lon=\(currentLocation.lon)&units=metric&appid=a5fbd45eb862a80d161c5fb8d6c86008"
        
        guard let url =  URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(WeekForecast.self, from: data!)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}
