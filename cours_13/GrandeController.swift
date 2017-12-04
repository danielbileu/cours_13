
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
    typealias courseName = String
    typealias gradeCourse = Double
//===================
    var studentGredes: [studentName: [courseName: gradeCourse]]!
    var arrayOfCourse: [courseName]!
    var arrayOfGrades: [gradeCourse]!
//===================
    override func viewDidLoad() {
        super.viewDidLoad()
        student_name_label.text = userDefaultsObj.getValue(theKey: "name") as? String
        loadUserDefaults()
        fillUpArray()
//        average.text = String(format: "Average: %0.1f", average1(tabNotes: arrayOfGrades, moyenne: {$0 / $1}))
        average.text = verifAverage(dictDeNotes: moienne(), regleDe3:{ $0 * 100.0 / $1})
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
 //===================
    func fillUpArray() {
        let name = student_name_label.text
        let couses_and_grands = studentGredes[name!]
        arrayOfCourse = [courseName](couses_and_grands!.keys)
        arrayOfGrades = [gradeCourse](couses_and_grands!.values)
    }
   //===================
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "gradeCourse") {
            studentGredes = userDefaultsObj.getValue(theKey: "gradeCourse") as! [studentName: [courseName: gradeCourse]]
        } else {
            studentGredes = [studentName: [courseName: gradeCourse]]()
        }
    }
  //===================
    @IBAction func addCourseAndGrande(_ sender: UIButton) {
        let name = student_name_label.text!
        var student_courses = studentGredes[name]!
        student_courses[couseField.text!] = gradeCourse(grandeField.text!)
        studentGredes[name] = student_courses
        userDefaultsObj.setKey(theValue: studentGredes as AnyObject, theKey: "gradeCourse")
        fillUpArray()
        course_grande_tableveiw.reloadData()
        average.text = verifAverage(dictDeNotes: moienne(), regleDe3:{ $0 * 100.0 / $1})
    }
   //===================
    func average1(tabNotes: [Double], moyenne: (_ sum: Double, _ nombreDeNotes: Double) -> Double) -> Double {
        let somme = tabNotes.reduce(0, +)
        let resultat = moyenne(somme, Double(tabNotes.count ))
        return resultat
    }
    func verifAverage(dictDeNotes: [Double: Double], regleDe3: (_ somme: Double, _ sur: Double) -> Double) -> String{
        
        let sommeNotes = [Double](dictDeNotes.keys).reduce(0, +)
        let sommesur = [Double](dictDeNotes.values).reduce(0, +)
        let conversion = regleDe3(sommeNotes, sommesur)
        return String(format: "Average = %0.1f/%0.1f or %0.1f/100", sommeNotes, sommesur, conversion)
        
    }
    
    func moienne () ->  [Double: Double] {
        let average = arrayOfGrades.reduce(0, +)
        let somme = arrayOfGrades.count
        let moienne = Double(average/Double(somme))
        let dictNotes = [moienne: 10.0]
        return dictNotes
    }
    
}

























