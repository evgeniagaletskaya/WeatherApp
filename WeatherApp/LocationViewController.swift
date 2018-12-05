//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/1/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showWeatherButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var address: Address?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationLabel.text = ""
        activityIndicator.isHidden = true
        showWeatherButton.isHidden = true
    }
    

    @IBAction private func detectLocation(_ sender: UIButton) {
        activityIndicator.isHidden = false
        startLocationManager()
    }
    
    private func startLocationManager() {
        
       
        if !Reachability.isConnectedToInternet  {
            showNoInternetAlert()
        }
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if !CLLocationManager.locationServicesEnabled() {
            showLocationServicesDisabledAlert()
            return
        }
        
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            showAuthorizationDeniedAlert()
            return
        }
        
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    private func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection",
                                      message: "Please, check network preferences",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    private func showLocationServicesDisabledAlert() {
        let alert = UIAlertController(title: "Location Services Are Disabled",
                                      message: "Change preferences in Settings → Privacy → Location Services ",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    private func showAuthorizationDeniedAlert() {
        let alert = UIAlertController(title: "The use of location services for this app is denied",
                                      message: "Change preferences in Settings → WeatherApp → Location",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    private func chooseLocationPreferencesAlert() {
        let alert = UIAlertController(title: "This app isn't allowed to use location services",
                                      message: "Change preferences in Settings → WeatherApp → Location",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    private func updateLocationLabel() {
        currentLocationLabel.text = "\(self.address!.country),\(self.address!.city) \n\(self.address!.street)"
        activityIndicator.isHidden = true
        showWeatherButton.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
    
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error == nil, let placemarks = placemarks, let placemark = placemarks.last {
                
                self.address = Address(country: placemark.country!,
                                       city: placemark.locality!,
                                       street: placemark.thoroughfare!)
                
                self.updateLocationLabel()
                
            } else {
                print("\(error!)")
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? WeatherViewController {
                vc.address = self.address
        }
    }
    

}
