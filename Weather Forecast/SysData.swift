//
//  SysData.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 08/02/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct SysData: Decodable {
    let country: String
    let sunrise: Int
    let sunset: Int
    
    static func decode(_ j: JSON) -> Decoded<SysData> {
        return curry(SysData.init)
            <^> j <| "country"
            <*> j <| "sunrise"
            <*> j <| "sunset"
    }
}
