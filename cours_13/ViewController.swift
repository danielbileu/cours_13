
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //--------------------------------
    //connection champ e tableview
    @IBOutlet weak var student_name_field: UITextField!
    @IBOutlet weak var student_name_tableview: UITableView!
    
    //--------------------------------
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    
    //--------------------------------
    let userDefautsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    
    //--------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentGrades.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = [studentName](studentGrades.keys)[indexPath.row]
        return cell
    }
    
    //-------------------------------- pour supprimer le row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let name = [studentName](studentGrades.keys)[indexPath.row]
            studentGrades[name] = nil
            userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    //---Pour garder dans la mémoire le nom. Pour montrer sur label d'autre interface---
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGrades.keys)[indexPath.row]
        userDefautsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "seg", sender: nil)
    }
    
    //---Pour faire le clavier apparaitre et dispparaitre ---
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //---Celui-ci c'est le bouton de connection pour des courses et des notes---
    @IBAction func addStudent(_ sender: UIButton) {
        if student_name_field.text != "" {
            studentGrades[student_name_field.text!] = [course: grade]()
            student_name_field.text = ""
            userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            student_name_tableview.reloadData()
        }
    }
    
    //--------------------------------
    func loadUserDefaults(){ //---Ça c'est pour garder en mémoire studentGrades
        if userDefautsObj.doesKeyExist(theKey: "grades"){
            studentGrades = userDefautsObj.getValue(theKey: "grades") as!
                [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
    
    //--------------------------------
}

