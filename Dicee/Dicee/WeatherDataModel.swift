//
//  WeatherDataModel.swift
//  Dicee
//
//  Created by apple on 2019/10/7.
//  Copyright © 2019 刘铭. All rights reserved.
//

import Foundation
class WeatherDataModel {
    
    var temperature: Int = 0
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var tempMin: Int = 0
    var tempMax: Int = 0
    var weatherTip: String = ""
    var windSpeed: Int = 0
    //Declare your model variables here
    
    
    //This method turns a condition code into the name of the weather condition image
    func updateWeatherTip(condition: Int) ->String{
         
        switch (condition) {
        
            case 0...300 :
                return "多云（实时）"
            
            case 301...500 :
                return "小雨（实时）"
            
            case 501...600 :
                return "大雨（实时）"
            
            case 601...700 :
                return "多云（实时）"
            
            case 701...771 :
                return "多云（实时）"
            
            case 772...799 :
                return "多云（实时）"
            
            case 800 :
                return "晴（实时）"
            
            case 801...804 :
                return "多云（实时）"
            
            case 900...903, 905...1000  :
                return "多云（实时）"
            
            case 903 :
                return "小雨（实时）"
            
            case 904 :
                return "晴（实时）"
            
            default :
                return "多云（实时）"
        }
    }
    func updateWeatherIcon(condition: Int) -> String {
        
    switch (condition) {
    
        case 0...300 :
            return "cloud"
        
        case 301...500 :
            return "smallrain"
        
        case 501...600 :
            return "bigrain"
        
        case 601...700 :
            return "cloud"
        
        case 701...771 :
            return "cloud"
        
        case 772...799 :
            return "cloud"
        
        case 800 :
            return "sun"
        
        case 801...804 :
            return "cloud"
        
        case 900...903, 905...1000  :
            return "cloud"
        
        case 903 :
            return "smallrain"
        
        case 904 :
            return "sun"
        
        default :
            return "cloud"
        }

    }
}
