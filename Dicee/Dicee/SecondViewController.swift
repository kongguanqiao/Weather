//
//  SecondViewController.swift
//  Dicee
//
//  Created by apple on 2019/10/21.
//  Copyright © 2019 刘铭. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate{
    func userEnteredANewCityName(city: String)
}

class SecondViewController: UIViewController {
    var delegate: ChangeCityDelegate?
    @IBOutlet weak var textField: UITextField!
    
    
    let cityShowName = ["城市","北京","上海","天津","深圳","济南","青岛","滕州","郑州","上饶","周口","德阳","柏林"]
    let cityEnglishName = ["city","BeiJing","ShangHai","TianJin","ShenZhen","JiNan","QingDao","TengZhou","ZhengZhou","ShangRao","ZhouKou","DeYang","ZhengZhou","BoLin"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func citySelected(_ sender: UIButton) {
        print(sender.tag)
        self.textField.text = cityEnglishName[sender.tag]
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        let cityName = textField.text!
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
