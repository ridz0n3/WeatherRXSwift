//
//  WeatherViewController.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 10/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Argo
import Curry
import Runes
import Firebase

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    var weatherData = Observable.just(Weather.ofLocation)
    let disposeBag = DisposeBag()
    var weather: Weather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        title = "Weather Forecast"
        tabSetup()
        
        let geolocationService = GeolocationService.instance
        var isfirst = false
        
        geolocationService.location.drive(onNext: { (loc) in
            if !isfirst{
                isfirst = true
                geolocationService.locationManager.stopUpdatingLocation()
                
                Alamofire.request("http://api.openweathermap.org/data/2.5/forecast?lat=\(loc.latitude)&lon=\(loc.longitude)&appid=8131be7e3e6b2014b3af931e011bd730").responseJSON { response in
                    
                    let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                    
                    if let j: Any = json {
                        self.weather = decode(j)
                        let t = self.weather?.list
                        self.filterWeather(list: t!)
                    }
                }
                
            }
            
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
    }

    func filterWeather(list : [List]){
        
        var t = [List]()
        for data in list{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en-GB")
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            
            let now = Date()
            let date = formatter.date(from: data.dt_txt)
            
            if now.compare(date!) == .orderedAscending{
                t.append(data)
            }
        }
        
        self.weatherData = Observable.just(t)//.just(self.weather!)
        self.setupCellConfiguration()
        self.setupCellTapHandling()
        
    }
    //MARK: Rx Setup
    private func setupCellConfiguration() {
        
        //Equivalent of cell for row at index path
        weatherData
            .bindTo(weatherTableView
                .rx
                .items(cellIdentifier: WeatherCell.identifier, cellType: WeatherCell.self)){
                    row, list, cell in
                    cell.configureWithWeather(list)
        }
                .addDisposableTo(disposeBag)

    }
    
    private func setupCellTapHandling() {
        //Equivalent of did select row at index path
        weatherTableView
            .rx
            .modelSelected(List.self)
            .subscribe(onNext: {
                data in
                
                WeatherDescription.sharedDescription.weather.value = [data]
                
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AIzaSyD2LWQ5ZKGiDPeJR06dsZQ1TFBa42sJBTY
        //let url = URL(string: "https://click.google-analytics.com/redirect?tid=UA-73345306-5&url=https%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Fmy-weather%2Fid1201627588%3Fls%3D1%26mt%3D8&aid=com.me-tech.my.Weather-Forecast&idfa={idfa}&cs=google&cm=cpc&ck=test&anid=admob&hash=md5")
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.allowIDFACollection = true
        
        tracker.set(kGAIScreenName, value: "home")
        
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
