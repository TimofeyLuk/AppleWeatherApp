//
//  MainPresenter.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 22.10.20.
//

import UIKit

protocol MainViewProtocol: class {
    func currentForecastSucces()
    func currentForecastFailure(error: Error)
    func weekForecastSucces()
    func weekForecastFailure(error: Error)
    func ImageSucces(image: UIImage?)
    func ImageFailure(error: Error)
    var presenter: MainPresenterProtocole! {get set}
}

protocol MainPresenterProtocole {
    init(view: MainViewProtocol, networkService: WeatherNetAPIService)
    func getCurrentForecast()
    func getWeekForecast()
    var currentForecast: CurrentWeatherData? { get set }
    var weekForecast: Forecast? { get set }
}

class MainPresenter: MainPresenterProtocole, GeolocationSeviceUpdateSubscriber {
    
    weak var view: MainViewProtocol?
    var networkService: WeatherNetAPIService?
    var currentForecast: CurrentWeatherData?
    var weekForecast: Forecast?
    
    
    required init(view: MainViewProtocol, networkService: WeatherNetAPIService) {
        self.view = view
        self.view?.presenter = self
        self.networkService = networkService
        self.networkService?.currentLocation.subscribers.append(self)
        
        getCurrentForecast()
        getWeekForecast()
    }
    
    func getCurrentForecast() {
        networkService!.getCurrentWeather{ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    self.currentForecast = forecast
                    self.view?.currentForecastSucces()
                    if let image = forecast?.weather?.first?.icon {
                        self.getImage(imageIndex: image)
                    }
                case .failure(let error):
                    self.view?.currentForecastFailure(error: error)
                }
            }
        }
    }
    
    func getWeekForecast() {
        networkService?.getWeekWeather(completion: ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let forecast):
                        self.weekForecast = Forecast(forecast: forecast!)
                        self.view?.weekForecastSucces()
                        self.getImages()
                    case .failure(let error):
                        self.view?.weekForecastFailure(error: error)
                }
            }
        }
    }
    
    func getImage(imageIndex: String) {
        networkService!.getWeatheImage(imageIndex: imageIndex, completion:{ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.weekForecast?.images?[imageIndex] = image
                    self.view?.ImageSucces(image: image)
                case .failure(let error):
                    self.view?.ImageFailure(error: error)
                }
            }
        })
    }
    
    func getImages() {
        if let data = weekForecast?.data {
            let keysArray = Array(data.keys).map({ String($0) })
            for dayKey in keysArray {
                guard let weathersData = weekForecast?.data?[dayKey] else { return }
                if weathersData == nil { return }
                for el in weathersData! {
                    if weekForecast?.images == nil { weekForecast?.images = [:] }
                    guard let imageIndex = el.weather?.first?.icon else { return }
                    if weekForecast?.images?.keys == nil {
                        getImage(imageIndex: imageIndex)
                    } else if !Array((weekForecast?.images?.keys)!).map({ String($0) }).contains(imageIndex) {
                        getImage(imageIndex: imageIndex)
                    }
                }
            }
        }
    }
    
    func lokationDidUpdate() {
        getCurrentForecast()
        getWeekForecast()
    }
    
}
