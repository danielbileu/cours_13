
//===================
import UIKit
import Foundation
//===================
class GrandeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//===================
    let userDefaultsObj = UserDefaultsManager()
//===================
    @IBOutlet weak var grandeField: UITextField!
    @IBOutlet weak var couseField: UITextField!
    @IBOutlet weak var student_name_label: UILabel!
    @IBOutlet weak var course_grande_tableveiw: UITableView!
    @IBOutlet weak var average: UILabel!
    //===================
    typealias studentName = String
    typealias couseName = String
    typealias gradeCouse = Double
//===================
    var studentGredes: [studentName: [couseName: gradeCouse]]!
    var arrayOfCourse: [couseName]!
    var arrayOfGrades: [gradeCouse]!
//===================
    override func viewDidLoad() {
        super.viewDidLoad()
        student_name_label.text = userDefaultsObj.getValue(theKey: "name") as? String
        loadUserDefaults()
        fillUpArray()
        average.text = String(format: "Average: %0.1f", average1(tabNotes: arrayOfGrades, moyenne: {$0 / $1}))
    }
//===================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCourse.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = course_grande_tableveiw.dequeueReusableCell(withIdentifier: "proto")!
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = arrayOfCourse[indexPath.row]
        }
        if let aGrande = cell.viewWithTag(101) as! UILabel! {
            aGrande.text = String(arrayOfGrades[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGredes.keys)[indexPath.row]
        userDefaultsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "proto", sender: nil)
    }
 //===================
    func fillUpArray() {
        let name = student_name_label.text
        let couses_and_grands = studentGredes[name!]
        arrayOfCourse = [couseName](couses_and_grands!.keys)
        arrayOfGrades = [gradeCouse](couses_and_grands!.values)
    }
   //===================
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "gradeCouse") {
            studentGredes = userDefaultsObj.getValue(theKey: "gradeCouse") as! [studentName: [couseName: gradeCouse]]
        } else {
            studentGredes = [studentName: [couseName: gradeCouse]]()
        }
    }
  //===================
    @IBAction func addCourseAndGrande(_ sender: UIButton) {
        let name = student_name_label.text!
        var student_courses = studentGredes[name]!
        student_courses[couseField.text!] = gradeCouse(grandeField.text!)
        studentGredes[name] = student_courses
        userDefaultsObj.setKey(theValue: studentGredes as AnyObject, theKey: "gradeCouse")
        fillUpArray()
        course_grande_tableveiw.reloadData()
    }
   //===================
    func average1(tabNotes: [Double], moyenne: (_ sum: Double, _ nombreDeNotes: Double) -> Double) -> Double {
        let somme = tabNotes.reduce(0, +)
        let resultat = moyenne(somme, Double(tabNotes.count ))
        return resultat
    }
}

























