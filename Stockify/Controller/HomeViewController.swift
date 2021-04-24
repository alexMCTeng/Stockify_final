//
//  ViewController.swift
//  Stockify
//
//  Created by Alex Teng on 11/21/20.
//  Copyright © 2020 Group24. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!

    var watchList: [String] = []
    var feedList: [FeedUITableViewCell] = []
    let theUser = User.shared
    var ref = Database.database().reference()
    
    var tickerData: [String] = []
    var changeData: [Float] = []
    var dateData: [String] = []

    func getFavorites(){
        if (getLoginStatus()){
            ref.child("/users/\(getUserId())/favorites/").observe(.value) { (snap) in
                var newArr:[String]  = []
                if let favs = snap.value as? [String: String] {
                    for (_, v) in favs {
                        newArr.append(v)
                    }
                    self.watchList = newArr
                } else{
                    self.watchList = []
                }
                
            }
        }else{
            self.watchList = []
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // we can assume the our tableview has maximum 20 rows and delete the old ones when excceding 20.
        print(tickerData.count)
        return tickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Add some basic code
        // return feedList[indexPath.row]
        
        if let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell {
            
            cell.set_percent_change(change: changeData[indexPath.row])
            cell.set_ticker(ticker: tickerData[indexPath.row])
            cell.timeLabel.text = dateData[indexPath.row]
            return cell
        }
        
        return FeedTableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        let feedCell = UINib(nibName: "FeedTableViewCell",
                                  bundle: nil)
        self.feedTableView.register(feedCell,
                                forCellReuseIdentifier: "FeedTableViewCell")
        
        self.getFavorites()
        
        let df = DateFormatter()
        df.dateFormat = "HHmm"
        df.timeZone = TimeZone(abbreviation: "EST")
        
            
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
            DispatchQueue.global(qos: .background).async {
                print("timer call... ")
                let today = NSDate()
                print("\(today)")
                let current_time = df.string(from: today as Date)
                
                let beginning_time = "0930"
                let ending_time = "1600"
                
                print(current_time)
                
                if (current_time < ending_time) && (current_time > beginning_time) {
                    GetData.updateInternalData(hvc: self)
                }
               
            }
        }
        
    }

    // call the functions at GetData.swift then update our tableview.
    

}

//class watchListPass{
//    static var shareInstance = watchListPass()
//    var watchList:[String] = []
//}
