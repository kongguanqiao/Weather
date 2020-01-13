//
//  ViewController.swift
//  Dicee
//
//  Created by 刘铭 on 2017/12/29.
//  Copyright © 2017年 刘铭. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ChangeCityDelegate{
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "8f1cd1a7f98c131dc6232a6c948c6f8b"
    let WEATHER_FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let currencyArray = ["今天","明天","后天"]
    var params: [String: String]!
    var forecastWeatherJSON: JSON!
    @objc let locationManager = CLLocationManager()  //这里声明了一个CLLocationManagere类型的常量，
    let weatherDataModel = WeatherDataModel() // 创建一个自己定义的weatherdatamodel类的对象
    @IBOutlet weak var cityDate: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempNum: UILabel!
    @IBOutlet weak var tempRange: UILabel!
    @IBOutlet weak var rightTime: UILabel!
    @IBOutlet weak var windSpeedDisplay: UILabel!
    @IBAction func refresh(_ sender: Any) {// 刷新功能
        print("refresh")
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSecondScreen", sender: self)
    }
    @IBOutlet weak var currentPicker: UIPickerView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    currentPicker.delegate = self
    currentPicker.dataSource = self
    locationManager.delegate = self  //委托
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      //设置定位的精度
    locationManager.requestWhenInUseAuthorization()  //定位权限询问
    locationManager.startUpdatingLocation()  //启动iPhone的定位服务
  }
    func updateWeatherData(json: JSON){
        if let tempResult = json["main"]["temp"].double { //这里.double 将json中该条数据强制转换为d双精度类型的变量。
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.tempMin = Int(json["main"]["temp_min"].doubleValue - 273.15)
        weatherDataModel.tempMax = Int(json["main"]["temp_max"].doubleValue - 273.15)
        weatherDataModel.city = json["name"].stringValue   //以String类型赋值给左边的属性
        weatherDataModel.condition = Int(json["weather"][0]["id"].stringValue) ?? 0
            // print(json["weather"][0]["id"].stringValue)//以int类型赋值给左边的属性
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        weatherDataModel.weatherTip = weatherDataModel.updateWeatherTip(condition: weatherDataModel.condition)
        weatherDataModel.windSpeed = json["wind"]["speed"].intValue
        updateUIWithWeatherData()
        }else {
            cityDate.text = " 气象信息不可用 "
        }
    }
    func updateUIWithWeatherData(){
        cityDate.text = weatherDataModel.city
        tempNum.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        tempRange.text = "\(weatherDataModel.tempMin)-\(weatherDataModel.tempMax)℃ "
        rightTime.text = weatherDataModel.weatherTip
        windSpeedDisplay.text = "风力：\(weatherDataModel.windSpeed)级"
    }
    @objc func getWeatherData(url: String,parameters: [String: String]){
        //这里获取的是当前的气象数据
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {  // 调用第三方类库Alamofire，生成并发送HTTP请求
            response in
            if response.result.isSuccess {
                print(" 成功获取气象数据 ")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                print(weatherJSON)
                ProgressHUD.showSuccess("成功刷新")
                }else{
                print(" 错误 \(String(describing: response.result.error))")
                self.cityDate.text = " 连接问题"
                ProgressHUD.showError("失败")
            }
        }
        //这里获取的是气象预报数据
        Alamofire.request(WEATHER_FORECAST_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("成功获取预报数据")
                self.forecastWeatherJSON = JSON(response.result.value!)
                print(self.forecastWeatherJSON["list"][0])
            }else{
                print("错误\(String(describing: response.result.error))")
            }
        }
    }
    //write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil  //这里把delegate属性设置为nil，因为目前用不到locationManager了
            print(" 经度 = \(location.coordinate.longitude), 纬度 = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            params = ["lat": latitude, "lon": longtitude, "appid": APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
            }
    }
    //write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
            cityDate.text = "定位失败"
    }
    func userEnteredANewCityName(city: String){
        params = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
       // print(city)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondScreen"{
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.delegate = self
        }
    }
//*****   pickerView   ******/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }//设置列数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }//设置行数
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }//填充pickerView的内容
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        let forecastJSON = forecastWeatherJSON["list"][row * 8]
       // print(forecastJSON)
        updateWeatherData2(json: forecastJSON)
    }// 根据选中的日期，更新界面
    func updateWeatherData2(json: JSON){
        print("更新气象数据2")
        if let tempResult = json["main"]["temp"].double { //这里.double 将json中该条数据强制转换为d双精度类型的变量。
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.tempMin = Int(json["main"]["temp_min"].doubleValue - 273.15)
        weatherDataModel.tempMax = Int(json["main"]["temp_max"].doubleValue - 273.15)
        weatherDataModel.condition = Int(json["weather"][0]["id"].stringValue) ?? 0
            //print(json["weather"][0]["id"].stringValue)//以int类型赋值给左边的属性
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        weatherDataModel.weatherTip = weatherDataModel.updateWeatherTip(condition: weatherDataModel.condition)
        weatherDataModel.windSpeed = json["wind"]["speed"].intValue
        updateUIWithWeatherData()
        }else {
            cityDate.text = " 气象信息不可用 "
        }
    }
    
}
