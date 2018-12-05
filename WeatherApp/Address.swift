//
//  Address.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/4/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import Foundation

struct Address {
    
    var country: String
    var city: String
    var street: String
    
    init(country: String, city: String, street: String) {
        self.country = country
        self.city = city
        self.street = street
    }
    
    var description: String {
        return "\(country), \(city), \(street)"
    }
}
