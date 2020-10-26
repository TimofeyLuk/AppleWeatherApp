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
    func ImageSucces()
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



// MARK: - Presenter for main screen

class MainPresenter: MainPresenterProtocole, GeolocationSeviceUpdateSubscriber {
    
    weak var view: MainViewProtocol?
    var networkService: WeatherNetAPIService?
    var currentForecast: CurrentWeatherData?
    var weekForecast: Forecast?
    var persistenceManager = PersistenceManager.share
    
    
    required init(view: MainViewProtocol, networkService: WeatherNetAPIService) {
        self.view = view
        self.view?.presenter = self
        loadOldData()
        self.networkService = networkService
        self.networkService?.currentLocation.subscribers.append(self)
        getCurrentForecast()
        getWeekForecast()
    }
    
    //MARK: - Requests for data
    
    func getCurrentForecast() {
        networkService!.getCurrentWeather{ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    self.currentForecast = forecast
                    self.saveData()
                    self.view?.currentForecastSucces()
                    if let image = forecast?.weather?.first?.icon {
                        self.getImage(imageIndex: image)
                    }
                case .failure(let error):
                    if self.currentForecast == nil {
                        self.view?.currentForecastFailure(error: error)
                    }
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
                        self.getImages()
                        self.view?.weekForecastSucces()
                    case .failure(let error):
                        self.view?.weekForecastFailure(error: error)
                }
            }
        }
    }
    
    //MARK: - Images
    
    func getImage(imageIndex: String) {
        networkService!.getWeatheImage(imageIndex: imageIndex, completion:{ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.weekForecast?.images?[imageIndex] = image
                    self.view?.ImageSucces()
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
        self.saveData()
    }
    
    func lokationDidUpdate() {
        getCurrentForecast()
        getWeekForecast()
    }
    
    // MARK: - CoreData Functions
    
    private func saveData() {
        persistenceManager.clearCoreData()
        
        if currentForecast != nil{
            let forecastData = MainForecastData(context: persistenceManager.context)
            forecastData.setData(currentForecast)
            persistenceManager.saveContext()
        }
        if weekForecast != nil {
            
            for dayIndex in 0...4 {
                let weekForecastData = WeekForecastData(context: persistenceManager.context)
                weekForecastData.setData(weekForecast, dayIndex: dayIndex)
                persistenceManager.saveContext()
            }
            
            if weekForecast?.images != nil {
                let imagesKeys = Array((weekForecast!.images!.keys).map({ String($0)}))
                for key in imagesKeys {
                    let imageData = Images(context: persistenceManager.context)
                    imageData.titile = key
                    imageData.image = (weekForecast!.images![key] ?? UIImage()).pngData()
                    persistenceManager.saveContext()
                }

            }
            
            if let twoDaysInfo = weekForecast?.getTwoDatsInfo() {
                for (number, hourInfo) in twoDaysInfo.enumerated() {
                    let hourForecastData = ForecastDataByHours(context: persistenceManager.context)
                    hourForecastData.id = Int64(number)
                    hourForecastData.image = hourInfo.weather?.first?.icon
                    hourForecastData.time = hourInfo.time
                    hourForecastData.temp = hourInfo.main?.temp ?? 0.0
                    persistenceManager.saveContext()
                }
            }
            
        }
        
    }
    
    
    private func loadOldData() {
        
        let mainForecastData = persistenceManager.fetch(MainForecastData.self, sort: nil).last
        currentForecast = CurrentWeatherData()
        currentForecast?.setData(mainForecastData)
        
        weekForecast = Forecast()
        weekForecast?.data = [:]
        weekForecast?.images = [:]
        
        let imagesData = persistenceManager.fetch(Images.self, sort: nil)
        for imageData in imagesData{
            weekForecast!.images![imageData.titile!] = UIImage(data: imageData.image!)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let weekForecastData = persistenceManager.fetch(WeekForecastData.self, sort: sortDescriptor)
        let forecastByHours = persistenceManager.fetch(ForecastDataByHours.self, sort: sortDescriptor)
        
        for el in weekForecastData {
            let forecastForDayElement = ForecastElement(main: Main(temp: nil, feels_like: nil, temp_min: el.temp_min,
                                                            temp_max: el.temp_max, pressure: nil, humidity: nil),
                                                 weather: [Weather(id: nil, main: nil, description: nil, icon: el.image)],
                                                 time: nil)
            var dayForecast = [forecastForDayElement]
            
            if el.id == Int64(0)  {
                dayForecast = []
                for (number, hourEl) in forecastByHours.enumerated() {
                    let oneMoreHourInfo =  ForecastElement(main: Main(temp: hourEl.temp, feels_like: nil, temp_min: nil,
                                                                      temp_max: nil, pressure: nil, humidity: nil),
                                                           weather: [Weather(id: nil, main: nil, description: nil, icon: hourEl.image)],
                                                           time: hourEl.time)
                    if number == 0 {
                        oneMoreHourInfo.main?.temp_min = el.temp_min
                        oneMoreHourInfo.main?.temp_max = el.temp_max
                    }
                    dayForecast.append(oneMoreHourInfo)
                }
            }
            
            weekForecast?.data?["\(el.id)"] = dayForecast
        }
        
    }
    
}
