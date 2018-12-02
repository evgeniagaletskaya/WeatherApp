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
        updateWeather()

    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    

    var city = ""
    var weather = ""
    var temperature = ""
    
    private func updateWeather() {
        cityLabel.text = city
        weatherLabel.text = weather
        temperatureLabel.text = temperature
    }
    
    @IBAction func refreshWeather(_ sender: UIButton) {
        updateWeather()
    }
    
}
