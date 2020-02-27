//
//  ViewController.swift
//  LocationDemo
//
//  Created by HanulYun-Comp on 2020/02/27.
//  Copyright © 2020 Yun. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLHeadingFilterNone
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
        
        let converter: LocationConverter = LocationConverter()
        let (x, y): (Int, Int)
            = converter.convertGrid(lon: longitude, lat: latitude)
        
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
//        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        geoCoder.reverseGeocodeLocation(findLocation) { (place, error) in
            if let address: [CLPlacemark] = place {
                print("(longitude, latitude) = (\(x), \(y))")
                print("시(도): \(address.last?.administrativeArea)")
                print("구(군): \(address.last?.locality)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}
