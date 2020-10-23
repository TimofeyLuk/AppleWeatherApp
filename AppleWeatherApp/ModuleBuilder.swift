//
//  ModuleBuilder.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 22.10.20.
//

import UIKit

class ModuleBuilder {
    
    static let location = Geolocator()
    
    static func createMainModule() -> UIViewController {
        let service = OpenWeatherAPIService(location: ModuleBuilder.location)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let view = sb.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        _ = MainPresenter(view: view, networkService: service)
        
        return view
    }
}
