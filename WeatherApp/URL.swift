//
//  URL.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/3/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import Foundation

struct URL {
    
    var url: String
    var city: String
    
    init(forCity city: String) {
        self.city = city
        url = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=55cdb57ee7b0e907235dd7a675404756"
    }
}
