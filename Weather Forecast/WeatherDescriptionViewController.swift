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
        
        tabSetup()
        
        title = "Weather Description"
        let desc = WeatherDescription.sharedDescription
        let weatherDetails = desc.description().weather[0]
        let tempDetails = desc.description().main
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-mm-dd HH:mm:ss"
        
        let date = formatter.date(from: desc.description().dt_txt)
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLbl.text = formatter.string(from: date!)
        
        let url = URL(string: "http://openweathermap.org/img/w/\(weatherDetails.icon).png")
        weatherIcon.kf.indicatorType = .activity
        weatherIcon.kf.setImage(with: url)
        
        temperature.text =  "Temperature: \(String.init(format: "%.1f\u{00B0}", Double(tempDetails.temp) - 273.15))"
        pressure.text = "Pressure: \(tempDetails.pressure) hpa"
        humidity.text = "Humidity: \(tempDetails.humidity)%"
        weatherLbl.text = "Weather: \(weatherDetails.main)"
        weatherDescription.text = "Description: \(weatherDetails.description.capitalized)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.allowIDFACollection = true
        tracker.set(kGAIScreenName, value: "description")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func tabSetup(){
        
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        tools.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        tools.backgroundColor = UIColor.clear
        tools.clipsToBounds = true;
        tools.isTranslucent = true;
        
        let image2 = UIImage(named: "backWhiteImg")!.withRenderingMode(.alwaysOriginal)
        
        let backButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(self.backButtonPressed(_:)))
        backButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        let buttons1:[UIBarButtonItem] = [backButton]
        tools.setItems(buttons1, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tools)
    }
    
    func backButtonPressed(_ sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
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
