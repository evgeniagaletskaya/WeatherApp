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
    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
//    var city: String?
//    var weather: String?
//    var temperature: String?
//    var time: String?
    
    
//    private func updateWeatherLabels() {
//        labelsAreVisible()
//        cityLabel.text = city
//        weatherLabel.text = weather
//        temperatureLabel.text = temperature
//    }
    
    @IBAction func refreshWeather(_ sender: UIButton) {
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

    func loadWeatherData()  {
        
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
        
        //showAllRecords()
    }
    
//    func showAllRecords() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<WeatherDataEntity>(entityName: "WeatherDataEntity")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//
//        let result = try! context.fetch(fetchRequest)
//        result.forEach {
//            print($0.date, $0.address, $0.temperature)
//        }
//    }
}
