
import UIKit


class StockDescriptionViewController: UIViewController {

    
    
    @IBOutlet weak var summaryLabel: UITextView!
    
    var descriptionLink: String? {
           didSet {
               DispatchQueue.main.async {
                   if self.summaryLabel != nil {
                    self.summaryLabel.text = self.descriptionLink
                   }
               }
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  

}

//extension StockDescriptionViewController : UITableViewDataSource {
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: //IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescripTableViewCell", for: indexPath) as! ProfileDescripTableViewCell
//
//        cell.newsTitleLabel?.text = newsInfo.title
//        cell.descriptionNewsLabel?.text = newsInfo.description
//        return cell
//    }

//}

//
