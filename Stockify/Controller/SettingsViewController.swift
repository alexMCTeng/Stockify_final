

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var inputLabel: UITextField!
    var targetPercentage = UserDefaults.standard.float(forKey: "NotificationTarget")

    //let theUser = User.shared -Alex
    //@IBOutlet weak var thresholdNum: UITextField! -Alex


    override func viewDidLoad() {
        super.viewDidLoad()
       // let textField = UITextField()
       // textField.keyboardType = .numberPad
     
    
       // addDoneButtonOnNumpad(textField: inputLabel)
       // self.thresholdNum.delegate = self -Alex

        // Do any additional setup after loading the view.
      /*  if var x = UserDefaults.standard.object(forKey: "StringNotificationTarget") as? Int {
            inputLabel.text = x
        }*/
        let target = UserDefaults.standard.float(forKey: "NotificationTarget")
        if target  == 0 {
            self.targetPercentage = 0.1
        }
        else {
            self.targetPercentage = target
        }

        inputLabel.delegate = self
        inputLabel.text = String(self.targetPercentage)
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: inputLabel, queue: OperationQueue.main){
            (notification) in
            self.targetPercentage = (self.inputLabel.text as! NSString).floatValue
            UserDefaults.standard.set(self.targetPercentage, forKey: "NotificationTarget")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let period = CharacterSet(charactersIn: ".")
        let both = allowedCharacters.union(period)
        let characterSet = CharacterSet(charactersIn: string)
        return both.isSuperset(of: characterSet)
    }
    
    /*
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items=[
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keypadToolbar
    }//addDoneToKeyPad
*/
/*
    @IBAction func editThreshold(_ sender: Any) {
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // if the user delete the input to an empty string, then, of course, it's allowed, return true
        if(string.count == 0){
            return true
        } else{
            var tempBoolean = true
            let r = Range(range, in: textField.text!)
            let newText = textField.text!.replacingCharacters(in: r!, with: string)
            let anythingButNumberAndDot = NSCharacterSet(charactersIn: "0123456789.").inverted
            let isNewStringValid = string.rangeOfCharacter(from: anythingButNumberAndDot) == nil
            tempBoolean = isNewStringValid
            // the textField is going to know which textField is changed, since our isLessThanTwoDecimalNum doesn't know the new extra string is, we'll need to add it.
            return tempBoolean && isLessThanTwoDecimalNum(inputText: newText)
        }
    }
*/

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.targetPercentage = (textField.text as! NSString).floatValue
        UserDefaults.standard.set(self.targetPercentage, forKey: "NotificationTarget")


    }

/*

    func isLessThanTwoDecimalNum(inputText: String) -> Bool{
        // Seperate the input by ., if there's only 1 dot, then the count should be 2, if there's no dots, then count should be 1.
        let dotNum = inputText.components(separatedBy: ".").count - 1
        //print(dotNum)
        // More than 1 dots, return false, 2 dots is not a decimal
        if(dotNum > 1){
            return false
        } else{
            let decimalNum: Int
            // I used string.index(), but xcode autofix to firstIndex()
            if let dotIndex = inputText.firstIndex(of: "."){
                decimalNum = inputText.distance(from: dotIndex, to: inputText.endIndex) - 1
            } else{
                // number of decimal = 0 if there's no dot.
                decimalNum = 0
            }
            return decimalNum <= 2
        }
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
