//
//  GeolocationService.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 20.10.20.
//

import Foundation
import CoreLocation

protocol GeolocationSevice {
    var lat: Int {get}
    var lon: Int {get}
    var subscribers: [GeolocationSeviceUpdateSubscriber] {get set}
}

protocol GeolocationSeviceUpdateSubscriber {
    func lokationDidUpdate()
}


class Geolocator: NSObject, GeolocationSevice, CLLocationManagerDelegate {
    var lat: Int = 0
    var lon: Int = 0
    var subscribers: [GeolocationSeviceUpdateSubscriber] = []
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 6000
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = Int(locValue.latitude)
        lon = Int(locValue.longitude)
        
        // MARK: Call UI and date update
        
    }
    
}
