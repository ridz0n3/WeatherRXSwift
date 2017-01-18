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

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    var weatherData = Observable.just(Weather.ofLocation)
    let disposeBag = DisposeBag()
    var weather: Weather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather Forecast"
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=8131be7e3e6b2014b3af931e011bd730").responseJSON { response in
            
            let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
            
            if let j: Any = json {
                self.weather = decode(j)
                let t = self.weather?.list
                self.weatherData = Observable.just(t!)
                self.setupCellConfiguration()
            }
        }
        
        // Do any additional setup after loading the view.
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
