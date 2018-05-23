//
//  ViewController.swift
//  What's the Weather
//
//  Created by Saurabh on 5/22/18.
//  Copyright © 2018 Saurabh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var city: NSString = ""
    var message = ""

    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var textfieldForecast: UILabel!
    
    @IBAction func submit(_ sender: UIButton) {
        
        if (textfield.text?.isEmpty)! {
            
                message = "The weather there couldn't be found. Please try again"
                textfieldForecast.text = message
                message = ""
            
        } else {
            
            if let cityName = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) as? NSString {
                
                if cityName.contains(" "){
                
                    print("contains space")
                    city =  cityName.replacingOccurrences(of: " ", with: "-") as NSString
                    print("cityName: \(city)")
                
                } else{
                    
                    city = cityName
                
                }
                
                print(city)
                
                var url = URL(string: "http://www.weather-forecast.com/locations/\(city)/forecasts/latest");
                
                print(url)
                
                var request = NSMutableURLRequest(url: url!)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest){
                    
                    data, response, error in
                    if error != nil{
                        
                        print(error)
                    
                    } else {
                        
                        if let unwrappedData = data {
                            let dataSring = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            print(dataSring)
                            
                            var stringSeperator = " Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                            
                            if let contentArray = dataSring?.components(separatedBy: stringSeperator){
                                
                                if contentArray.count > 1{
                                    
                                    stringSeperator = "</span>"
                                    
                                    let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                        
                                        if newContentArray.count > 0 {
                                            self.message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°");
                                            
                                            print("message")
                                            print(self.message)
                                        }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    if self.message == "" {
                        
                        self.message = "The weather there couldn't be found. Please try again"
                    
                    }
                    
                    DispatchQueue.main.sync(execute: {
                        
                        self.textfieldForecast.text = self.message
                        
                    })
                    
                }
                
                task.resume()
                
            }
            
            city = ""
            message = ""
            
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    
    }
    

}

