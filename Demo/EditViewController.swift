//
//  EditViewController.swift
//  DatePickerDialogExample
//
//  Created by Thomas Hegelund on 30/11/2016.
//  Copyright © 2016 vinicius. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import GoogleMobileAds

class EditViewController: UIViewController, UITextFieldDelegate {
    var personsInList: [Person_strong] = []
    var dismiss = false
    var Edited = false
    var væk = 0
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var textField: UITextField!
    
    var pickerdata = Date()
    var Person: Person_strong?
    var Index: Int?
    var personsInList3: [Person_strong] = []
    var Person5: Person_strong?
    @IBAction func Back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var date4 = Date()
    var date5 = Date()
    

    @IBAction func DatePickerButton(_ sender: Any) {
        DatePickerDialog().show("Birthday", doneButtonTitle: "Next", cancelButtonTitle: "Cancel", defaultDate: date4, datePickerMode: .date) {
            (date) -> Void in
            self.date4 = date
            var finalcom = DateComponents()
            var calendar = Calendar(identifier: .gregorian)
            let date2 = date
            let units: Set<Calendar.Component> = [.day, .month, .year]
            let components = Calendar.current.dateComponents(units, from: date2)
            let Years = components.year!
            let Mounths = components.month!
            let Days = components.day!
            finalcom.year = Years
            finalcom.month = Mounths
            finalcom.day = Days
            DatePickerDialog().show("Time of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.date5, datePickerMode: .time) {
                (date) -> Void in
                self.date5 = date
                var calendar = Calendar(identifier: .gregorian)
                let date3 = date
                let units: Set<Calendar.Component> = [.hour, .second, .minute]
                let components = Calendar.current.dateComponents(units, from: date3)

                let hour = components.hour!
                let minutes = components.minute!
                let seconds = components.second!
                var minString = "\(minutes)"
                if(minString.characters.count == 1){
                    minString = "0\(minutes)"
                }
                finalcom.hour = hour
                finalcom.minute = minutes
                
                finalcom.second = seconds
                self.textField.text = "\(Days)/\(Mounths)/\(Years) - \(hour):\(minString)"
                self.pickerdata = calendar.date(from: finalcom)!

            }
            
        }
        
    }

    @IBAction func Save(_ sender: Any) {
        if(textField.text == ""){
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 5
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        
        if (Name.text == ""){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.red.cgColor
            Name.layer.cornerRadius = 5
            //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        var personInList5 = personsInList3
        if (Name.text != "" && textField.text != ""){
            
            if((Name.text?.characters.count)! < 15){
                
                let moc = DataController().managedObjectContext
                
                
                personsInList3.remove(at: Index!)
                let PersonF = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
                
                do{
                    var personsList = try moc.fetch(PersonF) as! [Person]
                    personsList = personsList.sorted(by: {$0.name!.lowercased() > $1.name!.lowercased()}).reversed()
                    moc.delete(personsList[Index!])
                    try moc.save()
                    
                } catch{
                    
                }
                let Person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: moc)
                Person.setValue(pickerdata, forKey: "age")
                Person.setValue(Name.text, forKey: "name")
                var strong_Person = Person_strong()
                strong_Person.age = pickerdata
                strong_Person.name = Name.text

                do{
                    try moc.save()
                } catch{
                    
                }
                
                var Edited = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavViewController
                let pvc = vc.childViewControllers[0] as! PopUpViewController
                
                pvc.fromEdit = true
                pvc.Edited = Edited
                pvc.Person = strong_Person
                self.present(vc, animated: true, completion: nil)
                
                
                }
        }

        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    var timer = Timer()
    override func viewDidLoad() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.countUp), userInfo:nil, repeats: true)
        Name.delegate = self 
        Name.layer.borderWidth = 1
        Name.layer.borderColor = UIColor.gray.cgColor
        Name.layer.cornerRadius = 5
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 5
        var age = Person?.age
        pickerdata = age!
        date4 = age!
        date5 = age!
        var name = Person?.name
        let units: Set<Calendar.Component> = [.hour, .second, .minute, .day, .month, .year]
        let components = Calendar.current.dateComponents(units, from: age!)
        let hour = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        let Years = components.year!
        let Mounths = components.month!
        let Days = components.day!
        var minString = "\(minutes)"
        if(minString.characters.count == 1){
            minString = "0\(minutes)"
        }
        self.textField.text = "\(Days)/\(Mounths)/\(Years) - \(hour):\(minString)"
        self.Name.text = name
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    func countUp(){
        if(dismiss){
            dismiss = false
            self.performSegue(withIdentifier: "unwind", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
