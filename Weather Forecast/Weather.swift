//
//  Weather.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 10/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

func ==(lhs: Weather, rhs: Weather) -> Bool {
    return (lhs.cod == rhs.cod && lhs.message == rhs.message && lhs.cnt == rhs.cnt)
}

struct Weather: Equatable {
    
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    
    static var ofLocation: [List] = [List]()
    
}

struct List {
    
    let dt_txt: String
    let weather: [WeatherDetail]
    let main: TemperatureDetail
    
}

struct WeatherDetail {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct TemperatureDetail {
    let temp: Int
    let temp_min: Int
    let temp_max: Int
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Int
}

extension Weather: Decodable {
    static func decode(_ j: JSON) -> Decoded<Weather> {
        return curry(Weather.init)
            <^> j <| "cod"
            <*> j <| "message"
            <*> j <| "cnt"
            <*> j <|| "list"
    }
    
}

extension List: Decodable{
    static func decode(_ j: JSON) -> Decoded<List> {
        return curry(List.init)
            <^> j <| "dt_txt"
            <*> j <|| "weather"
            <*> j <| "main"
    }
}

extension WeatherDetail: Decodable{
    static func decode(_ j: JSON) -> Decoded<WeatherDetail> {
        return curry(WeatherDetail.init)
            <^> j <| "id"
            <*> j <| "main"
            <*> j <| "description"
            <*> j <| "icon"
    }
}

extension TemperatureDetail: Decodable{
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
