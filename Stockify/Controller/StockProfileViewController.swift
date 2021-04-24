

import UIKit
import AVFoundation
import Charts
import TinyConstraints
import SafariServices

class StockProfileViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var financialButton: UIButton!
    
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var volumeTradedLabel: UILabel!
    @IBOutlet weak var latestTradingDayLabel: UILabel!
    @IBOutlet weak var previousCloseLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    @IBAction func financialLinkLabel(_ sender: Any) {
        guard let financialLink = financialLink, let url = URL(string: financialLink) else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    
    
    var stockTicker: String = "AAPL"
    var financialLink: String?
    var summaryInfo: String?
    var newsInfos = [NewsInfo]()

   
    private var open: CGFloat? {
        didSet {
            DispatchQueue.main.sync {
                self.openLabel.text = "Open Price: \(open ?? 0.0)"
            }
        }
    }
    
    private var high: CGFloat? {
        didSet {
            DispatchQueue.main.sync {
                self.highLabel.text = "High: \(high ?? 0.0)"
//                let unwrappedHigh = self.high!
            }
        }
    }
    
    
    private var low: CGFloat? {
        didSet {
            DispatchQueue.main.sync {
                self.lowLabel.text = "Low: \(low ?? 0.0)"
            }
        }
    }
    
    private var price: CGFloat? {
        didSet {
            DispatchQueue.main.sync {
                self.priceLabel.text = "$\(price ?? 0.0)"
            }
        }
    }
    
    private var volumeTraded: Int? {
        didSet {
            DispatchQueue.main.sync {
                self.volumeTradedLabel.text = "Volume Traded: \(volumeTraded ?? 0)"
            }
        }
    }
    
    private var latestTradingDay: String? {
        didSet {
            DispatchQueue.main.sync {
                self.latestTradingDayLabel.text = "\(latestTradingDay ?? "")"
            }
        }
    }
    private var previousClose: CGFloat? {
        didSet {
            DispatchQueue.main.sync {
                self.previousCloseLabel.text = "Previous Close: \(previousClose ?? 0)"
            }
        }
    }
    private var change: CGFloat? {
        didSet {
            DispatchQueue.main.sync {
                let CheckValue = change ?? 0
                if CheckValue < 0 {
                    self.changePercentLabel.textColor = UIColor.red
                    self.changeLabel.text = "Dollar Change: \(change ?? 0)"
                }
                else {
                   self.changePercentLabel.textColor = UIColor(named: "Green")
                   self.changeLabel.text = "Dollar Change: \(change ?? 0)"
                }
              
            }
        }
    }
    private var changePercent: String? {
        didSet {
            DispatchQueue.main.sync {
             
                
                self.changePercentLabel.text = "Percent Change: \(changePercent ?? "")"
            }
        }
    }
    
    private var chartData: [ChartDataEntry] = [ChartDataEntry]()
    private var dates: [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.stockTickerLabel.text = "Stock Ticker: \(stockTicker)"
        
        newsButton.isHidden = true
        
        StockService.shared.getDailySeriesData(tickerSymbol: stockTicker) { (data, response, error) in
            
            if let data = data, let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary { //time series to order date
               
                if jsonData.count < 2  {
                                  DispatchQueue.main.async {
                                  //    self.performSegue(withIdentifier: "notFound", sender: nil)
                                  }
                                                 return
                                             
                              }
                
                
                let dataSet = jsonData["Time Series (5min)"] as! NSDictionary
                
              

                
                self.chartData = [ChartDataEntry]()
                self.dates = [String]()
                let dateFormatter =  DateFormatter() //, then built date formatter
                
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
                //dateFormatter.date(from: "")
                //dateFormatter.dateFormat = "HH:mm"
                let dact = dataSet as!  [String:[String:String]] //sort data by key
                let sorted = dact.sorted {
                    ($0.key < $1.key)
                }.map {
                    $0.key
                }
                var counter = 0
                for key in sorted { //loop over keys, plot using calendar ordinality
                    self.dates.append(key)
                    let value = dataSet[key] as! NSDictionary
                    let date = dateFormatter.date(from: key)!
                    let dateTimeInterval = date.timeIntervalSince1970
                    let entry = ChartDataEntry(x: dateTimeInterval, y: (value["1. open"] as! NSString).doubleValue)
                    counter+=1
                    self.chartData.append(entry)
                    
                }
                self.setData(stockData: self.chartData)
            }
        }
        
       
        
        
        StockService.shared.getGeneralInfo(tickerSymbol: stockTicker) {(data, response, error) in
            
            if let data = data, let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary, let globalQuote = jsonData["Global Quote"] as? NSDictionary {
                let formatter = NumberFormatter()
                
                if globalQuote.count == 0 {
                    DispatchQueue.main.async {
                    //    self.performSegue(withIdentifier: "notFound", sender: nil)
                    }
                                   return
                               
                }
                
                
                let openString = globalQuote["02. open"] as! String
                self.open = CGFloat(formatter.number(from: openString)!)
                
                let highString = globalQuote["03. high"] as! String
                self.high = CGFloat(formatter.number(from: highString)!)
                
                let lowString = globalQuote["04. low"] as! String
                self.low = CGFloat(formatter.number(from: lowString)!)
                
                let priceString = globalQuote["05. price"] as! String
                self.price = CGFloat(formatter.number(from: priceString)!)
                
                let volumeTradedString = globalQuote["06. volume"] as! String
                self.volumeTraded = Int(formatter.number(from: volumeTradedString)!)
                
               // let dateFormatter = DateFormatter()
                //dateFormatter.dateFormat = "yyyy-MM-dd"
                let latestTradingDayString = globalQuote["07. latest trading day"] as? String
                self.latestTradingDay =  latestTradingDayString
                
                
                let previousCloseString = globalQuote["08. previous close"] as! String
                self.previousClose = CGFloat(formatter.number(from: previousCloseString)!)
                
                let changeString = globalQuote["09. change"] as! String
                self.change = CGFloat(formatter.number(from: changeString)!)
             
                let changePercentString = globalQuote["10. change percent"] as! String
                self.changePercent = changePercentString
              
                
            }
            
        }
        
        StockService.shared.getNews(tickerSymbol: stockTicker, date: "2020-12-08") {(data, response, error) in
            
                   if let data = data, let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary, let articles = jsonData["articles"] as? [NSDictionary] {
                  

                    print(jsonData)
                    
                    for article in articles {
                     
                        if let title = article["title"] as? String, let description = article["description"] as? String, let url = article["url"] as? String {
                              let newsInfo = NewsInfo(title: title, description: description, url: url)
                               self.newsInfos.append(newsInfo)
                        }
                      
                     
                    }
                    
                    if self.newsInfos.count > 0 {
                        DispatchQueue.main.async {
                            self.newsButton.isHidden = false
                        }
                        //DispatchQueue.main.async {
                        //    self.performSegue(withIdentifier: "notFound", sender: nil)
                       // }
                        return
                    }
                   
          }
                   else{
                    print(error?.localizedDescription)
            }
          }
        
        
        StockService.shared.getFinancials(tickerSymbol: stockTicker) { (data, response, error) in
            
            if let data = data, let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary] {
                
                 if jsonData.count == 0 {
                                  DispatchQueue.main.async {
                                    //  self.performSegue(withIdentifier: "notFound", sender: nil)
                                    self.financialButton.isHidden = true
                                  }
                                                 return
                                             
                              }

                
                let newestData = jsonData[0]
                let finalLink = newestData["finalLink"]
                self.financialLink = finalLink as! String
                
            }
        }
        
        StockService.shared.getStockName(tickerSymbol: stockTicker) { (data, response, error) in
            
            
            if let data = data, let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary] {
               if jsonData.count == 0 {
                                  DispatchQueue.main.async {
                                     // self.performSegue(withIdentifier: "notFound", sender: nil)
                                  }
                                                 return
                                             
                              }
                
                let stockInfo = jsonData[0]
                let stockName = stockInfo["name"] as! String
                DispatchQueue.main.async {
                    self.navigationItem.title = stockName
                }
            }
           
        }
        
        
        StockService.shared.getStockSummary(tickerSymbol: stockTicker) { (data, response, error) in
            
            if let data = data, let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary] {
                
            if jsonData.count == 0 {
                              DispatchQueue.main.async {
                             //     self.performSegue(withIdentifier: "notFound", sender: nil)
                                        self.summaryButton.isHidden = true
                              }
                                             return
                                         
                          }
                
              

                                let descripData = jsonData[0]
                let finalLink = descripData["description"]
                print("HERE!!!")
                print(finalLink)
                
                self.summaryInfo = finalLink as? String
                
                
            }
        }
        
   
       
        lineChartView.rightAxis.enabled = false
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .lightGray
        yAxis.axisLineColor = .lightGray
        yAxis.labelPosition = .outsideChart
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.xAxis.labelTextColor = .lightGray
        lineChartView.xAxis.axisLineColor = .systemGray
        lineChartView.xAxis.labelCount = 2
        lineChartView.animate(xAxisDuration: 2.5)
        lineChartView.legend.enabled = false
    
        
        //formatLegend(legend: lineChartView.legend)
        
        
    }

    func setData(stockData: [ChartDataEntry]) {
        let set1 = LineChartDataSet(entries: stockData)
        
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.lightGray)
        set1.fill = Fill(color: .gray)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
       // set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemGray5
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.xAxis.valueFormatter = DateAxisValueFormatter(self.dates)
        
        lineChartView.data = data
        
    }
    
    
 

    
    // Do any additional setup after loading the view.
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StockNewsViewController {
            destinationVC.newsInfos = newsInfos
        }
        if let destinationVC = segue.destination as? StockDescriptionViewController {
         destinationVC.descriptionLink = summaryInfo
        }

     }
    
   
    
    // Uploaded on Nov 26 2am by Alex Teng,
    // the dataForPlaySound, playSoundArray, and the playAudio function are prototype, we can adjust them based on how we want to calculate and store the data we'd like to play sound.
    var playSoundArray:[dataForPlaySound]!
    func playAudio(){
        for eachData in playSoundArray{
            let inputString = "\(eachData.stockName!)'s price is changed \(eachData.diff!) percent in \(eachData.second!) seconds"
            let turnAudio = AVSpeechUtterance(string: inputString)
            turnAudio.voice = AVSpeechSynthesisVoice(language: "en")
            turnAudio.rate = 0.1
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(turnAudio)
        }
    }
}

struct dataForPlaySound{
    let stockName: String!
    let diff: Double!
    let second: Int!
}



//added features
//zoom in and out, news API, change interval date options
