//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/2/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class WeatherViewController: UIViewController {
    
    var address: Address!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWeatherData()
        configureView()
    }
    
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var weatherLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
 
    private func configureView() {
        
        cityLabel.textColor = UIColor.white
        cityLabel.shadowColor = UIColor.darkGray
        
        weatherLabel.textColor = UIColor.white
        weatherLabel.shadowColor = UIColor.darkGray
        
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.shadowColor = UIColor.darkGray 
    }
    
    @IBAction private func refreshWeather(_ sender: UIButton) {
        loadWeatherData()
    }
    
    private func hideLabels() {
        cityLabel.isHidden = true
        weatherLabel.isHidden = true
        temperatureLabel.isHidden = true
        activityIndicator.isHidden = false
    }
    
    private func showLabels() {
        cityLabel.isHidden = false
        weatherLabel.isHidden = false
        temperatureLabel.isHidden = false
        activityIndicator.isHidden = true
    }
    
    private func convertToCelsius(kelvin: Double) -> Double {
        return  kelvin - 273.15
    }

    private func loadWeatherData()  {
        
        hideLabels()
        
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(address.city)&APPID=55cdb57ee7b0e907235dd7a675404756"
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            Alamofire.request(url).responseJSON { response in
                self.hideLabels()
                
                
                switch response.result {
                    
                case .success(let value):
                    let jsonData = JSON(value)
                    
                    let temp = self.convertToCelsius(kelvin: jsonData["main"]["temp"].doubleValue)
                    let conditions = jsonData["weather"][0]["main"].stringValue
                    
                    let weatherData = WeatherData(date: Date(),
                                                  temperature: temp,
                                                  conditions: conditions,
                                                  address: self.address)
                    
                    self.saveWeatherData(weatherData)
                    
                    DispatchQueue.main.async {
                        self.showWeather(data: weatherData)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
    }
    
    private func showWeather(data: WeatherData) {
        
        self.cityLabel.text = data.address.city
        self.weatherLabel.text = data.conditions
        self.temperatureLabel.text = String(format: "%.0f", data.temperature) + "℃"
        
        showLabels()
    }
    
    private func saveWeatherData(_ weatherData: WeatherData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let weatherDataEntityDescription = NSEntityDescription.entity(forEntityName: "WeatherDataEntity", in: context)
        
        let weatherDataEntity = NSManagedObject(entity: weatherDataEntityDescription!, insertInto: context) as! WeatherDataEntity
        
        weatherDataEntity.address = weatherData.address.description
        weatherDataEntity.temperature = weatherData.temperature
        weatherDataEntity.date = weatherData.date
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Could not save. \(error),\(error.userInfo)")
        }
        
    }
    
}
