//
//  CurrentWeather.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 08/02/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

func ==(lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
    return (lhs.name == rhs.name && lhs.dt == rhs.dt)
}

struct CurrentWeather: Equatable, Decodable {
    
    let name: String
    let dt: Int
    let main: TemperatureDetail
    let weather: [WeatherDetail]
    let sys: SysData
    
    static func decode(_ j: JSON) -> Decoded<CurrentWeather> {
        return curry(CurrentWeather.init)
            <^> j <| "name"
            <*> j <| "dt"
            <*> j <| "main"
            <*> j <|| "weather"
            <*> j <| "sys"
    }
    
}
