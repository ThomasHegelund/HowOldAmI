//
//  PersonsTableViewController2.swift
//  DatePickerDialogExample
//
//  Created by Thomas Hegelund on 14/09/2016.
//  Copyright © 2016 vinicius. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import GoogleMobileAds

class PersonsTableViewController2: UITableViewController {
   
    @IBOutlet weak var PopUpView: UIView!
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {}
    @IBOutlet weak var Ad: GADBannerView!
    var personsInList: [Person_strong] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Ad.adUnitID = "ca-app-pub-7877597617906353/8672925823"
        Ad.rootViewController = self
        let Request = GADRequest()
        Request.testDevices = [kGADSimulatorID]
        Ad.load(Request)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        personsInList = []
        let moc = DataController().managedObjectContext
        let PersonF = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do{
            let personsList = try moc.fetch(PersonF) as! [Person]
            for person in personsList{
                let strong_Person = Person_strong()
                strong_Person.age = person.age
                strong_Person.name = person.name
                personsInList.append(strong_Person)
            }
        } catch{
            
        }
        personsInList = personsInList.sorted(by: {$0.name!.lowercased() > $1.name!.lowercased()}).reversed()
        self.tableView.reloadData()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBOutlet weak var PopUpViewLabel: UILabel!
    

    @IBAction func Delete(_ sender: Any) {
        self.personsInList.remove(at: DeleteIndex)
         tableView.deleteRows(at: [DeletePath], with: .fade)
         let moc = DataController().managedObjectContext
         let PersonF = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
         
         do{
         var personsList = try moc.fetch(PersonF) as! [Person]
         personsList = personsList.sorted(by: {$0.name!.lowercased() > $1.name!.lowercased()}).reversed()
         moc.delete(personsList[DeleteIndex])
         try moc.save()
         
         } catch{
         
         }
        self.tabBarController?.tabBar.items![0].isEnabled = true
        self.tabBarController?.tabBar.items![1].isEnabled = true
        for subview in self.view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        PopUpView.isHidden = true
    }
    
    @IBAction func Cancel(_ sender: Any) {
        for subview in self.view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        self.tabBarController?.tabBar.items![0].isEnabled = true
        self.tabBarController?.tabBar.items![1].isEnabled = true
        PopUpView.isHidden = true
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personsInList.count ?? 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let person = personsInList[indexPath.row]
        
        do{
            try cell.textLabel?.text = person.name
            
        } catch{
            
        }
        

        return cell
}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavViewController
        let pvc = vc.childViewControllers[0] as! PopUpViewController
        pvc.Person = personsInList[indexPath.row]
        pvc.Index = indexPath.row
        pvc.personsInList2 = personsInList
        self.present(vc, animated: true, completion: nil)
        
        
    }
  
    var DeleteIndex = 0
    var DeletePath: IndexPath = []
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.PopUpView.isHidden = false

            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.tabBarController?.tabBar.items![0].isEnabled = false
            self.tabBarController?.tabBar.items![1].isEnabled = false
            let personname = self.personsInList[indexPath.row].name!
            self.PopUpViewLabel.text = ("Are you sure you want to delete \(personname)?")
            self.view.addSubview(self.PopUpView)
            self.DeleteIndex = indexPath.row
            self.DeletePath = indexPath
            self.tableView.reloadData()
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation2") as! Nav2ViewController
            let pvc = vc.childViewControllers[0] as! EditViewController
            pvc.Person = self.personsInList[index.row]
            pvc.personsInList3 = self.personsInList
            pvc.Index = index.row
            self.present(vc, animated: true, completion: nil) 
        }
        edit.backgroundColor = .blue
        return [delete, edit]
    }
    
}

