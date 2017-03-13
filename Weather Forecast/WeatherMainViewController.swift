//
//  WeatherMainViewController.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 08/02/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Argo
import Curry
import Runes

class WeatherMainViewController: UIViewController {

    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var sunriseImg: UIImageView!
    @IBOutlet weak var sunriseTimeLbl: UILabel!
    @IBOutlet weak var sunsetTimeLbl: UILabel!
    @IBOutlet weak var sunsetImg: UIImageView!
    
    let disposeBag = DisposeBag()
    var currentWeather: CurrentWeather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let geolocationService = GeolocationService.instance
        var isfirst = false
        
        geolocationService.location.drive(onNext: { (loc) in
            if !isfirst{
                isfirst = true
                geolocationService.locationManager.stopUpdatingLocation()
                
                let url = URL(string: "https://maps.googleapis.com/maps/api/streetview?size=\(Int(self.view.frame.size.width))x\(Int(self.view.frame.size.height))&location=\(loc.latitude),\(loc.longitude)&heading=151.78&pitch=-0.76&key=AIzaSyD2LWQ5ZKGiDPeJR06dsZQ1TFBa42sJBTY")
                self.backgroundImgView.kf.indicatorType = .activity
                self.backgroundImgView.kf.setImage(with: url)
                
                Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(loc.latitude)&lon=\(loc.longitude)&appid=8131be7e3e6b2014b3af931e011bd730").responseJSON { response in
                    
                    let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                    
                    if let j: Any = json {
                        self.currentWeather = decode(j)
                        self.setupView()
                    }
                }
                
            }
            
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        // Do any additional setup after loading the view.
    }

    func setupView(){
        
        let weather = self.currentWeather?.weather[0]
        let temperature = self.currentWeather?.main
        let sysData = self.currentWeather?.sys
        
        let url = URL(string: "http://openweathermap.org/img/w/\(weather!.icon).png")
        weatherIcon.kf.indicatorType = .activity
        weatherIcon.kf.setImage(with: url)
        
        descriptionLbl.text = weather?.main
        
        temperatureLbl.text =  String.init(format: "%.1f\u{00B0}", Double((temperature?.temp)!) - 273.15)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        let currentDate = Date(timeIntervalSince1970: Double((self.currentWeather?.dt)!))
        
        timeLbl.text = "\(self.currentWeather!.name),\(sysData!.country), \(formatter.string(from: currentDate))".replacingOccurrences(of: ", ", with: "\n")
        
        let sunriseTime = Date(timeIntervalSince1970: Double((sysData?.sunrise)!))
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        sunriseTimeLbl.text = formatter.string(from: sunriseTime)
        sunriseImg.image = sunriseImg.image!.withRenderingMode(.alwaysTemplate)
        
        let sunsetTime = Date(timeIntervalSince1970: Double((sysData?.sunset)!))
        sunsetTimeLbl.text = formatter.string(from: sunsetTime)
        sunsetImg.image = sunsetImg.image!.withRenderingMode(.alwaysTemplate)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.allowIDFACollection = true
        tracker.set(kGAIScreenName, value: "main")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
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
