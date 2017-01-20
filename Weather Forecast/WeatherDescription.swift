//
//  WeatherDescription.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 19/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherDescription {
    
    static let sharedDescription = WeatherDescription()
    
    let weather: Variable<[List]> = Variable([])
    
    func description() -> List {
        
        return (weather.value[0])
    }
    
}
