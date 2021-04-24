//
//  GetData.swift
//  Stockify
//
//  Created by Alex Teng on 12/1/20.
//  Copyright © 2020 Group24. All rights reserved.
//

import Foundation
import AVFoundation

class GetData {

    static var tickerList : [String] = []
    static let session = URLSession.shared
    static let defaults = UserDefaults.standard
    static let synthesizer = AVSpeechSynthesizer()

    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    static func getDataOfTicker(t: String, hvc: HomeViewController) {


        // old url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(t)&apikey=3RF2V6H463YXCWVN"

        print("https://financialmodelingprep.com/api/v3/quote-short/\(t)?apikey=5b4f11485284d500091053946cc5a6a0")
        if let url = URL(string: "https://financialmodelingprep.com/api/v3/quote-short/\(t)?apikey=5b4f11485284d500091053946cc5a6a0") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if var jsonString = String(data: data, encoding: .utf8) {

                        let start = jsonString.index(jsonString.startIndex, offsetBy: 1)
                        let end = jsonString.index(jsonString.endIndex, offsetBy:  -1)
                        let range = start..<end

                        jsonString = String(jsonString[range])

                        if convertToDictionary(text: jsonString) == nil {
                            return
                        }
                        let dict = convertToDictionary(text: jsonString)! as NSDictionary

                        if dict["price"] == nil {
                            return
                        }
                        print(dict["price"]!) //this line crashed
                        let newValue: Float = (dict["price"] as? NSNumber)!.floatValue
                        if var lastValues = defaults.object(forKey: "lastValues") as? [String: Float?] {

                            if let lastValue = lastValues[t] {

                                let change = 1.0 - newValue / lastValue!
                                let target = Float(UserDefaults.standard.float(forKey: "NotificationTarget"))/100


                                print(target)
                                // needs an update
                                if abs(change) >= target {
                                    print("significant change, \(change), target: \(target)")

                                    DispatchQueue.main.async {
                                        hvc.tickerData.insert(t, at:0)
                                        hvc.changeData.insert(change, at: 0)

                                        let df = DateFormatter()
                                        df.dateFormat = "HH:mm"
                                        let today = NSDate()
                                        print("\(today)")
                                        let currentTime = df.string(from: today as Date)

                                        hvc.dateData.insert(currentTime, at: 0)

                                        hvc.feedTableView.reloadData()
                                    }

                                    let inputTemplate = "\(t) changed \(change * 100.0) percent in 30 seconds "
                                    let turnAudio = AVSpeechUtterance(string: inputTemplate)
                                    turnAudio.voice = AVSpeechSynthesisVoice(language: "en")
                                    turnAudio.rate = 0.5
                                    synthesizer.speak(turnAudio)

                                }
                            } else {
                                lastValues[t] = newValue
                            }

                            lastValues[t] = newValue
                            defaults.set(lastValues, forKey: "lastValues")
                        } else {
                            defaults.set([String: Float?](), forKey: "lastValues")
                        }
                    }
                }
            }.resume()


        }
    }

    // works like this:
    // 1. gets new value, if new value + % > last value, push the update to tableview, sound controller
    // 2. update the last value

    static func updateInternalData(hvc: HomeViewController) {

        print(hvc.watchList)
        for ticker in hvc.watchList {
            getDataOfTicker(t: ticker, hvc: hvc)
        }

    }
}
