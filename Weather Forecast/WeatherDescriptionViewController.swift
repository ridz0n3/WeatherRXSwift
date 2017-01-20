//
//  WeatherDescriptionViewController.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 19/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit

class WeatherDescriptionViewController: UIViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let desc = WeatherDescription.sharedDescription
        let weatherDetails = desc.description().weather[0]
        let tempDetails = desc.description().main
        
        dateLbl.text = desc.description().dt_txt
        
        let url = URL(string: "http://openweathermap.org/img/w/\(weatherDetails.icon).png")
        weatherIcon.kf.indicatorType = .activity
        weatherIcon.kf.setImage(with: url)
        
        temperature.text =  String.init(format: "%.1f\u{00B0}", Double(tempDetails.temp) - 273.15)
        pressure.text = "\(tempDetails.pressure) hpa"
        humidity.text = "\(tempDetails.humidity)%"
        weatherLbl.text = weatherDetails.main
        weatherDescription.text = weatherDetails.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
