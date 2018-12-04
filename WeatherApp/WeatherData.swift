//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/2/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import Foundation

struct WeatherData {
    
    var time: String
    var temperature: String
    var address: Address
   
    init(time: String, temperature: String, address: Address) {
        self.time = time
        self.temperature = temperature
        self.address = address
    }
}

