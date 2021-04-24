
import Foundation

class StockService {
    static private let instance = StockService()
    
    static var shared: StockService {
        return instance
    }
    func getDailySeriesData(tickerSymbol: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let intradayURL = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(tickerSymbol)&interval=5min&apikey=3RF2V6H463YXCWVN")!
        let urlRequest = URLRequest(url: intradayURL)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            callback(data, response, error)
        }.resume()
    }
    func  getGeneralInfo(tickerSymbol: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(tickerSymbol)&apikey=3RF2V6H463YXCWVN")!
        let urlRequest = URLRequest(url: quoteURL)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in callback(data, response, error)}.resume()
    }
    
    func  getNews(tickerSymbol: String, date: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let quoteURL = URL(string: "https://newsapi.org/v2/everything?q=\(tickerSymbol)&from=\(date)&to=\(date)&sortBy=popularity&apiKey=e1cb6d8a30294c3a84f16e4dfa40ea94")!
        let urlRequest = URLRequest(url: quoteURL)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in callback(data, response, error)}.resume()
    }
    
    func  getFinancials(tickerSymbol: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let quoteURL = URL(string: "https://financialmodelingprep.com/api/v3/sec_filings/\(tickerSymbol)?type=10-K&limit=100&apikey=08cf3bc1aad42b79e5101e140844906c")!
        let urlRequest = URLRequest(url: quoteURL)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in callback(data, response, error)}.resume()
    }
    
    
    func  getStockName(tickerSymbol: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let quoteURL = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(tickerSymbol)?apikey=08cf3bc1aad42b79e5101e140844906c")!
        print(quoteURL.absoluteString)
        
        let urlRequest = URLRequest(url: quoteURL)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in callback(data, response, error)}.resume()
    }
    
    func  getStockSummary(tickerSymbol: String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let quoteURL = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(tickerSymbol)?apikey=08cf3bc1aad42b79e5101e140844906c")!
        print(quoteURL.absoluteString)
        let urlRequest = URLRequest(url: quoteURL)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in callback(data, response, error)}.resume()
    }
    
    
    
    
    
}


