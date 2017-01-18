//
//  WeatherCell.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 10/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherCell: UITableViewCell {

    static let identifier = "WeatherCell"

    @IBOutlet weak var weatherImgView: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func configureWithWeather(_ weatherData: List) {
        timeLbl.text = weatherData.dt_txt
        
        let url = URL(string: "http://openweathermap.org/img/w/\(weatherData.weather[0].icon).png")
        weatherImgView.kf.indicatorType = .activity
        weatherImgView.kf.setImage(with: url)
        
        temperatureLbl.text =  String.init(format: "%.1f\u{00B0}", Double(weatherData.main.temp) - 273.15)
        
        weatherLbl.text = weatherData.weather[0].main
        descriptionLbl.text = weatherData.weather[0].description
        
    }
}
