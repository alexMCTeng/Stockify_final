//
//  SearchStocks.swift
//  Stockify
//
//  Created by Alex Teng on 12/10/20.
//  Copyright © 2020 Group24. All rights reserved.
//

import SwiftUI

struct SearchStocks: View {
    var par: UIViewController
    //    var stocks = ["AAPL", "GOOG", "YAHOO", "BABA"]
    
    @State private var stocks = getCSVData();
    
    var theUser = User.shared
    var body: some View {
        NavigationView{
            VStack{
                
                List{
                    ForEach(stocks, id: \.self) { stock in
                        
                        VStack{
                            Button(stock.components(separatedBy: ",")[0]){
                                let res = self.theUser.addToFavorites(name: stock.components(separatedBy: ",")[0])
                                if (res){
                                    self.par.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
                
                
                .navigationBarTitle("Stocks")
                
            }
        }
    }
}

func getCSVData() -> Array<String> {
    
    do {
        let filePath = Bundle.main.path(forResource: "stocks", ofType: "csv")!
        let content = try String(contentsOfFile: filePath)
        let parsedCSV: [String] = content.components(
            separatedBy: "\n"
        ).map{ $0 }
        return parsedCSV
    }
    catch {
        
        return []
    }
}

