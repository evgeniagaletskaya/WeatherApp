//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/2/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import Foundation


struct WeatherData {

    var date: Date
    var temperature: Double
    var conditions: String
    var address: Address

    init(date: Date, temperature: Double, conditions: String, address: Address) {
        self.date = date
        self.temperature = temperature
        self.conditions = conditions
        self.address = address
    }
}

