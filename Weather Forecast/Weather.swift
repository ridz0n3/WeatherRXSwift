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

struct Weather: Equatable, Decodable {
    
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    
    static var ofLocation: [List] = [List]()
    
    static func decode(_ j: JSON) -> Decoded<Weather> {
        return curry(Weather.init)
            <^> j <| "cod"
            <*> j <| "message"
            <*> j <| "cnt"
            <*> j <|| "list"
    }
}


