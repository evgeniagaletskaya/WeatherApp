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

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    var city: String?
    var weather: String?
    var temperature: String?
    
    
    //TODO: change city in url
    
    var sourceURL: String = "http://api.openweathermap.org/data/2.5/weather?q=minsk&APPID=55cdb57ee7b0e907235dd7a675404756"
    var weatherData: WeatherData?
    
    
    private func updateWeatherLabels() {
        labelsAreVisible()
        cityLabel.text = city
        weatherLabel.text = weather
        temperatureLabel.text = temperature
    }
    
    @IBAction func refreshWeather(_ sender: UIButton) {
        loadWeatherData(from: sourceURL)
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    private func hideLabels() {
        cityLabel.isHidden = true
        weatherLabel.isHidden = true
        temperatureLabel.isHidden = true
        activityIndicator.isHidden = false
    }
    
    private func labelsAreVisible() {
        cityLabel.isHidden = false
        weatherLabel.isHidden = false
        temperatureLabel.isHidden = false
        activityIndicator.isHidden = true
    }
    
    func loadWeatherData(from url: String)  {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            
            Alamofire.request(url).responseJSON { responce in
                self.hideLabels()
                switch responce.result {
                    
                case .success(let value):
                    let jsonData = JSON(value)
                    
                    for (key, subJson):(String, JSON) in jsonData {
                        if key == "weather" {
                            self.weather = subJson[0]["main"].stringValue
                        }
                            //TODO: convert to celsius
                        else if key == "main" {
                            self.temperature = subJson["temp"].stringValue
                        }
                        else if key == "name" {
                            self.city = subJson.stringValue
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.updateWeatherLabels()
                }
                
            }
            
        }
        
    }
    
}
