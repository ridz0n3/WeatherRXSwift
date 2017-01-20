//
//  WeatherDetail.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 19/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct WeatherDetail: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    static func decode(_ j: JSON) -> Decoded<WeatherDetail> {
        return curry(WeatherDetail.init)
            <^> j <| "id"
            <*> j <| "main"
            <*> j <| "description"
            <*> j <| "icon"
    }
}
