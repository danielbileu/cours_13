
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//===================
    @IBOutlet weak var student_name_tableview: UITableView!
    @IBOutlet weak var student_name_Fild: UITextField!
//===================
    let userDefaultsObj = UserDefaultsManager()
//===================
    typealias studentName = String
    typealias couseName = String
    typealias gradeCouse = Double
//===================
    var studentGredes: [studentName: [couseName: gradeCouse]]!
//===================
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    
    
//===================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentGredes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = [studentName](studentGredes.keys)[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editinsStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editinsStyle == UITableViewCellEditingStyle.delete {
            let name = [studentName](studentGredes.keys)[indexPath.row]
            studentGredes[name] = nil
            userDefaultsObj.setKey(theValue: studentGredes as AnyObject, theKey: "gradeCouse")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGredes.keys)[indexPath.row]
        userDefaultsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "seg", sender: nil)
    }
//===================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//===================
    func loadUserDefaults() {
        //userDefaultsObj.removeKey(theKey: "gradeCouse")
        if userDefaultsObj.doesKeyExist(theKey: "gradeCouse") {
            studentGredes = userDefaultsObj.getValue(theKey: "gradeCouse") as! [studentName: [couseName: gradeCouse]]
        } else {
            studentGredes = [studentName: [couseName: gradeCouse]]()
        }
    }
//===================
    @IBAction func addstudent(_ sender: UIButton) {
        if student_name_Fild.text != "" {
            studentGredes[student_name_Fild.text!] = [couseName: gradeCouse]()
            student_name_Fild.text = ""
            userDefaultsObj.setKey(theValue: studentGredes as AnyObject, theKey: "gradeCouse")
            student_name_tableview.reloadData()
        }
    }
}
//===================

//Méthode reduce - faire moyanne

//func average(tabNotes: [Double], moyenne: (_ sum: Double, _ nombreDeNotes: Double) -> Double) -> Double {
//    let somme = tabNotes.reduce(0, +)
//    let resultat = moyenne(somme, Double(tabNotes.count))
//    return resultat
//}
//
//let this = String(format: "%0.1f", average(tabNotes: notes, moyenne: {$0 / $1}))
//
//print(this)

//func produitCroise(dictDeNotes: [Double: Double], regleDe3: (_ somme: Double, _ sur: Double) -> Double) -> String {
//    let sommeNotes = [Double](dictDeNotes.keys).reduce(0, +)
//    let sommeSur = [Double](dictDeNotes.values).reduce(0, +)
//    let conversion = regleDe3(sommeNotes, sommeSur)
//    return String(format: "Grade = %0.1f/%0.1f or %0.1f/100", sommeNotes, sommeSur, conversion)
//}
//
//let dictNotes = [12.5: 20.0, 13.8: 20.0, 55.3: 50.0, 77.4: 100.0]
//print(produitCroise(dictDeNotes: dictNotes) { $0 * 100.0 / $1 })























