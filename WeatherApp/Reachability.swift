//
//  Reachability.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/5/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import Foundation
import Alamofire

struct Reachability {
    
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return self.sharedInstance.isReachable
    }
}
