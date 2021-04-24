//
//  WatchlistViewController.swift
//  Stockify
//
//  Created by Angelica Harris on 11/22/20.
//  Copyright © 2020 Group24. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftUI
class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref = Database.database().reference()
    let theUser = User.shared
    
    let loginView = UIView()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var addButton: UIBarButtonItem!
    
    // Member favorites variable
    var favorites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(getLoginStatus()){
            loginView.isHidden = true
            tableView.isHidden = false
            self.navigationItem.rightBarButtonItem = self.addButton
            getFavorites()
        }
        else{
            self.navigationItem.rightBarButtonItem = nil
            tableView.isHidden = true
            renderNoLogin()
            //            labelHeight.constant = 25
        }
    }
    
    func renderNoLogin(){
        loginView.isHidden = false
        let img = UIImage(named: "AccessDenied") ?? nil
        let imgView = UIImageView();
        imgView.image = img
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.frame.size.width = 200
        imgView.frame.size.height = 200
        imgView.center = self.view.center
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 45))
        label.text = "Please login to create a watchlist"
        label.center = CGPoint(x: 160, y: 250)
        label.center.x = self.view.center.x
        label.textAlignment = .center
        label.textColor = UIColor(named: "LightGray")
        label.adjustsFontSizeToFitWidth = true
        loginView.addSubview(label)
        loginView.addSubview(imgView)
        mainView.addSubview(loginView)
    }
    
    func getFavorites(){
        if (getLoginStatus()){
            ref.child("/users/\(getUserId())/favorites/").observe(.value) { (snap) in
                var newArr:[String]  = []
                if let favs = snap.value as? [String: String] {
                    for (_, v) in favs {
                        newArr.append(v)
                    }
                    self.favorites = newArr
                    GetData.tickerList = newArr
                    self.tableView.reloadData()
                }
                else{
                    self.favorites = []
                    self.tableView.reloadData()
                }
                
            }
        }
        else{
            self.favorites = []
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "favCell")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel!.text = favorites[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let stock = favorites[indexPath.row]
        _ = theUser.removeFavorite(name: stock)
    }
    
    
    @IBAction func addToWatchlist(_ sender: Any) {
        let parent = UIViewController()
        let searchHostingController = UIHostingController(rootView: SearchStocks(par: parent))
        searchHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        searchHostingController.view.frame = parent.view.bounds
        parent.view.addSubview(searchHostingController.view)
        parent.addChild(searchHostingController)
        self.navigationController?.pushViewController(parent, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedStock = favorites[indexPath.row]
        
        if let stockProfileVC  = UIStoryboard.init(name: "StockProfile", bundle: nil).instantiateViewController(withIdentifier: "StockProfileNav") as? UINavigationController {
            
            if let top = stockProfileVC.topViewController as? StockProfileViewController {
                top.stockTicker = clickedStock
                self.navigationController?.pushViewController(top, animated: true)
                }
        }
        
        
    }
    
    
}
