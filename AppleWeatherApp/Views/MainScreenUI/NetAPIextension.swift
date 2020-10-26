//
//  NetAPIextension.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 22.10.20.
//

import UIKit

extension MainViewController {
    // MARK: - Network
    
    func currentForecastSucces() {
        locationLabel.text = presenter?.currentForecast?.name ?? ""
        weatherDescription.text = presenter?.currentForecast?.weather?.first?.description ?? ""
    }
    
    func currentForecastFailure(error: Error) {
        showConnectionAlert(error: error, message: "Please connect to the Internet. After pressing \"reconnect\" button, application will try to connect again")
    }
    
    func weekForecastSucces() {
        weatherTable.reloadData()
    }
    
    func weekForecastFailure(error: Error) {
        showConnectionAlert(error: error, message: "Please connect to the Internet. After pressing \"reconnect\" button, application will try to connect again")
    }
    
    func ImageSucces() {
        weatherTable.reloadData()
    }
    
    func ImageFailure(error: Error) {
        showConnectionAlert(error: error, message: "The program was unable to obtain images")
    }
    
    func showConnectionAlert(error: Error, message: String) {
        print(error.localizedDescription)
        let errorMessage = UIAlertController(title: "Connection error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "reconnect", style: .cancel, handler: { (action) -> Void in
            self.presenter.getCurrentForecast()
            self.presenter.getWeekForecast()
         })
        errorMessage.addAction(ok)
        self.present(errorMessage, animated: true, completion: nil)
    }
    
}
