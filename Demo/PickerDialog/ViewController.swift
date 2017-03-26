//
//  ViewController.swift
//  DatePickerDialogExample
//
//  Created by Thomas Hegelund on 14/09/2016.
//  Copyright © 2016 vinicius. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
import AudioToolbox
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate {
    
    

    @IBOutlet weak var ad: GADBannerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var Name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.layer.borderWidth = 1
        Name.layer.borderColor = UIColor.gray.cgColor
        Name.layer.cornerRadius = 5
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 5
        ad.adUnitID = "ca-app-pub-7877597617906353/8672925823"
        ad.rootViewController = self
        let Request = GADRequest()
        Request.testDevices = [kGADSimulatorID]
        ad.load(Request)
        
    
       timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.countUp), userInfo:nil, repeats: true)

        Name.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    var used = false
    var timer = Timer()
    var finalDate = Date()
    var date2 = Date()
    var date3 = Date()
    func textFieldDidEndEditing(_ Name: UITextField) {
       
        if(Name.text == ""){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.red.cgColor
            Name.layer.cornerRadius = 5
        }
        if((Name.text?.characters.count)! > 15){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.red.cgColor
            Name.layer.cornerRadius = 5
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        if ((Name.text?.characters.count)! > 0 && (Name.text?.characters.count)! < 15){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.gray.cgColor
            Name.layer.cornerRadius = 5
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }


    }
    
        
    func countUp() {
        if((textField.text?.characters.count)! > 0) {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.layer.cornerRadius = 5
        }
        
        if ((Name.text?.characters.count)! > 0 && (Name.text?.characters.count)! < 16){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.gray.cgColor
            Name.layer.cornerRadius = 5
        }
        if ((Name.text?.characters.count)! > 15){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.red.cgColor
            Name.layer.cornerRadius = 5
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
     
        

    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    var pickerdata = Date()


    @IBAction func datePickerTap(_ sender: Any) {
        DatePickerDialog().show("Birthday", doneButtonTitle: "Next", cancelButtonTitle: "Cancel", defaultDate: self.date2, datePickerMode: .date) {
            (date) -> Void in
            var finalcom = DateComponents()
            var calendar = Calendar(identifier: .gregorian)
            self.date2 = date
            self.finalDate = self.date2
            let units: Set<Calendar.Component> = [.day, .month, .year]
            let components = Calendar.current.dateComponents(units, from: self.date2)
            let Years = components.year!
            let Mounths = components.month!
            let Days = components.day!
            finalcom.year = Years
            finalcom.month = Mounths
            finalcom.day = Days
            DatePickerDialog().show("Time of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: self.date3,datePickerMode: .time) {
                (date) -> Void in
                var calendar = Calendar(identifier: .gregorian)
                self.date3 = date
                let units: Set<Calendar.Component> = [.hour, .second, .minute]
                let components = Calendar.current.dateComponents(units, from: self.date3)
                let hour = components.hour!
                let minutes = components.minute!
                let seconds = components.second!
                finalcom.hour = hour
                finalcom.minute = minutes
                finalcom.second = seconds
                var minString = "\(minutes)"
                if(minString.characters.count == 1){
                    minString = "0\(minutes)"
                }
                self.textField.text = "\(Days)/\(Mounths)/\(Years) - \(hour):\(minString)"
                self.pickerdata = calendar.date(from: finalcom)!
            }
            
        }

    }
    /* IBActions */
  /*  @IBAction func datePickerTapped(sender: AnyObject) {
        
    }*/
    
    @IBAction func PersonCreate(_ sender: Any) {
        
        if(textField.text == ""){
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 5
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        
        if (Name.text == ""){
            Name.layer.borderWidth = 1
            Name.layer.borderColor = UIColor.red.cgColor
            Name.layer.cornerRadius = 5
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        
        if (Name.text != "" && textField.text != ""){
            
            if((Name.text?.characters.count)! < 15){
                let moc = DataController().managedObjectContext
                let Person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: moc)
                Person.setValue(pickerdata, forKey: "age")
                Person.setValue(Name.text, forKey: "name")
                var strong_Person = Person_strong()
                strong_Person.age = pickerdata
                strong_Person.name = Name.text
                Name.text = ""
                textField.text = ""
                Name.layer.borderWidth = 1
                Name.layer.borderColor = UIColor.gray.cgColor
                Name.layer.cornerRadius = 5
                
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.gray.cgColor
                textField.layer.cornerRadius = 5
                used = false
                do{
                    try moc.save()
                } catch{
                    
                }
                
                
                var vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavViewController
                let pvc = vc.childViewControllers[0] as! PopUpViewController
                pvc.Person = strong_Person
                self.present(vc, animated: true, completion: nil)
            }
    }
    //@IBAction func CreatePerson(sender: AnyObject) {
        
      //  }
 
        

        
       
    }
}
