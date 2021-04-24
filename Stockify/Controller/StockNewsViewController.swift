

import UIKit
import SafariServices

class StockNewsViewController: UIViewController {
    
    var newsInfos: [NewsInfo]? {
        didSet {
            DispatchQueue.main.async {
                if self.tableViewLabel != nil {
                    self.tableViewLabel.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var tableViewLabel: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       self.tableViewLabel.register(NewsInfoCell.self, forCellReuseIdeSntifier: "NewsInfoCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tableViewLabel != nil {
            self.tableViewLabel.reloadData()
        }
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */



extension StockNewsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsInfos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsInfoCell", for: indexPath) as! NewsInfoCell
        let newsInfo = newsInfos![indexPath.row]
        cell.newsTitleLabel?.text = newsInfo.title
        cell.descriptionNewsLabel?.text = newsInfo.description
        return cell
    }

}

extension StockNewsViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = newsInfos![indexPath.row]
        guard let url = URL(string: newsInfo.url) else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}




