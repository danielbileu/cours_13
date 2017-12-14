//---
import UIKit
//---
class GradeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //---
    @IBOutlet weak var course_grade_tableview: UITableView!
    @IBOutlet weak var student_name_label: UILabel!
    @IBOutlet weak var course_field: UITextField!
    @IBOutlet weak var grade_field: UITextField!
    //-------------------------
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    
    //--------------------------
    let userDefautsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    var arrOfCourses: [course]!
    var arrOfGrades: [grade]!
    
    //--------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        student_name_label.text = userDefautsObj.getValue(theKey: "name") as? String
        loadUserDefaults()
        fillUpArray()
        //let this = String(format: "%0.1f", averageNote(tabNotes: arrOfGrades, moyenne: {$0 * 100.0 / $1}))
        averageDisplay.text = verifAverage(dictDeNotes: intermediaire(), regleDe3:{ $0 * 100.0 / $1})
    }
    
    //--------------------------
    func fillUpArray() {
        let name = student_name_label.text
        let courses_and_grades = studentGrades[name!]
        arrOfCourses = [course](courses_and_grades!.keys)
        arrOfGrades = [grade](courses_and_grades!.values)
    }
    
    
    //--------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfCourses.count
    }
    
    //---Pour definir ---
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = course_grade_tableview.dequeueReusableCell(withIdentifier: "proto")!
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = arrOfCourses[indexPath.row]
        }
        if let aGrade = cell.viewWithTag(101) as! UILabel! {
            aGrade.text = String(arrOfGrades[indexPath.row])
        }
        return cell
    }
    
    //---Il supprime la rangée---
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let name = student_name_label.text!
            var courses_and_grades = studentGrades[name]
            let deleteTheLineOfTheCourse = [course](courses_and_grades!.keys)[indexPath.row]
            courses_and_grades![deleteTheLineOfTheCourse] = nil
            studentGrades[name] = courses_and_grades
            userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            fillUpArray()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
            }
    
    //---Pour garder en mémoire les grades des étudiants---
    func loadUserDefaults(){
        if userDefautsObj.doesKeyExist(theKey: "grades"){
            studentGrades = userDefautsObj.getValue(theKey: "grades") as! [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
    
    //---Add course and Grade---
    @IBAction func save_course_and_grade(_ sender: UIButton) {
        let name = student_name_label.text!
        var student_courses = studentGrades[name]!
        student_courses[course_field.text!] = Double(grade_field.text!)
        studentGrades[name] = student_courses
        userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
        fillUpArray()
        course_grade_tableview.reloadData()
        averageDisplay.text = verifAverage(dictDeNotes: intermediaire(), regleDe3:{ $0 * 100.0 / $1})
        //        averageDisplay.text = this
    }
    
    //---Pour faire et montrer la note moyenne---
    @IBOutlet weak var averageDisplay: UILabel!
    
    //---Montrer des notes moyennes---
    func averageGrade(tabNotes: [Double], moyenne: (_ sum: Double, _ nombreDeNotes: Double) -> Double) ->
        Double {
            let theSum = tabNotes.reduce(0, +)
            let resultat = moyenne(theSum, Double(tabNotes.count))
            return resultat
    }
    
    //--- ---
    func verifAverage(dictDeNotes: [Double: Double], regleDe3: (_ theSum: Double, _ sur: Double) -> Double) -> String{
        let sumOfNotes = [Double](dictDeNotes.keys).reduce(0, +)
        let sumSum = [Double](dictDeNotes.values).reduce(0, +)
        let convert = regleDe3(sumOfNotes, sumSum)
        return String(format: "Average Grades = %0.1f/%0.1f or %0.1f/100", sumOfNotes, sumSum, convert)
    }
    
    //--- ---
    func intermediaire () ->  [Double: Double] {
        let average = arrOfGrades.reduce(0, +)
        let theSum = arrOfGrades.count
        let intermediaire = Double(average/Double(theSum))
        let dictNotes = [intermediaire: 10.0]
        return dictNotes
    }
    
    //---   ---
}
