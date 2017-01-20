//
//  List.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 19/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct List: Decodable {
    
    let dt_txt: String
    let weather: [WeatherDetail]
    let main: TemperatureDetail
    
    static func decode(_ j: JSON) -> Decoded<List> {
        return curry(List.init)
            <^> j <| "dt_txt"
            <*> j <|| "weather"
            <*> j <| "main"
    }
    
}
