//
//  PopUpViewController.swift
//  DatePickerDialogExample
//
//  Created by Thomas Hegelund on 21/09/2016.
//  Copyright © 2016 vinicius. All rights reserved.
//
import UIKit
import GoogleMobileAds
import CoreData
import Foundation

class PopUpViewController: UIViewController {
    @IBOutlet weak var ad: GADBannerView!
    @IBOutlet weak var add: GADBannerView!
    
    func ReturnMainMenu() {
        // save the presenting ViewController
        var presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismiss(animated: false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    var fromEdit = false
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func Backbarbutton(_ sender: AnyObject) {
        Second = true
        Hour = false
        Minute = false
        
        if(fromEdit){
            ReturnMainMenu()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func HoursButton(_ sender: AnyObject) {
        Hour = true
        Minute = false
        Second = false
    }
    @IBAction func MinutesButton(_ sender: AnyObject) {
       Minute = true
       Hour = false
       Second = false
    }
    @IBAction func SecondsButton(_ sender: AnyObject) {
        Second = true
        Hour = false
        Minute = false
    }
    var Person: Person_strong?
    var Index: Int?
    var personsInList2: [Person_strong] = []
    var Edited: Bool?
    //var Edited: Bool?
    
    var age: Int64 = 0
    var EditStarted = false
    var EditFinish = false
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var Hour = false
    var Minute = false
    var Second = true
    var timer = Timer()
    var personsInLists: [Person_strong] = []
    
    
    
    
    func buildfinalstring(_ age:String) -> String{
        var newage: Array<Character> = []
        var final = ""
        let pkantal = Int(age.characters.count / 3)
        var testage = Array(age.characters)
            if age.characters.count > 3{
            testage = testage.reversed()
            
                for i in 1...pkantal {
                    newage.append(testage[0])
                    newage.append(testage[1])
                    newage.append(testage[2])
                    testage.removeFirst()
                    testage.removeFirst()
                    testage.removeFirst()
                    if(testage.count != 0){
                            newage.append(".")
                        }
                    }
                    for test in testage{
                    newage.append(test)
                    }
                
                    newage = newage.reversed()
                    for new in newage{
                    final = "\(final)\(new)"
                    }
 
            }else {
                final = age
        
        }
        return final
    }
    func countUp(pvc:PopUpViewController){
        if Edited == true{
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavViewController
            let pvc2 = vc2.childViewControllers[0] as! PopUpViewController
            Second = true
            Hour = false
            Minute = false
            Edited = false
            pvc2.dismiss(animated: true, completion: nil)
        }
 
        age = Int64((Person?.age?.timeIntervalSinceNow)!) * -1
        if Hour == true{
            let hourage = "\(age / 60 / 60)"
            ageLabel.text = "\(buildfinalstring(hourage)) \nHours"
            }
         else if Minute == true{
            let minuteage = "\(age / 60)"
            ageLabel.text = "\(buildfinalstring(minuteage)) \nMinutes"
        }
         else if Second == true{
            let Secondage = "\(age)"
            ageLabel.text = "\(buildfinalstring(Secondage)) \nSeconds"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        add.adUnitID = "ca-app-pub-7877597617906353/8672925823"
        add.rootViewController = self
        let Request = GADRequest()
        Request.testDevices = [kGADSimulatorID]
        add.load(Request)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PopUpViewController.countUp), userInfo:nil, repeats: true)
        nameLabel.text = Person?.name
        age = Int64(((Person?.age?.timeIntervalSinceNow)! * -1))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
