//
//  TemperatureDetail.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 19/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct TemperatureDetail: Decodable {
    let temp: Int
    let temp_min: Int
    let temp_max: Int
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Int
    
    static func decode(_ j: JSON) -> Decoded<TemperatureDetail> {
        return curry(TemperatureDetail.init)
            <^> j <| "temp"
            <*> j <| "temp_min"
            <*> j <| "temp_max"
            <*> j <| "pressure"
            <*> j <| "sea_level"
            <*> j <| "grnd_level"
            <*> j <| "humidity"
            <*> j <| "temp_kf"
    }
}
