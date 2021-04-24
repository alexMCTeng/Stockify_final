//

import Foundation
import Charts


class DateAxisValueFormatter: NSObject, IAxisValueFormatter{
    let dateFormatter =  DateFormatter()
    var dates = [String]()
    init(_ array: [String]){
        super.init()
        dateFormatter.dateFormat = "h:mm a"
        dates = array
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{ //takkes a value, converts the value into int, returns dates at thati as a string
        //let i = Int(value)
        //return dates[i]
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
        
        // Data from API -> json -> date string -> date -> timeinterval -> date -> date string
        
    }
}
//2020-12-07 19:55:00

