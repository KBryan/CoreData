//
//  ViewController.swift
//  CD
//
//  Created by KBryan on 2015-11-18.
//  Copyright © 2015 KBryan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    var students:[Student] = []
    var context:NSManagedObjectContext!
    
    @IBAction func saveStudentButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Student", message: "Add New Student", preferredStyle: .Alert)
        let save = UIAlertAction(title: "Save", style: .Default) { (alertAction:UIAlertAction) -> Void in
            //
            let textField = alert.textFields![0]
           
            self.saveStudent(textField.text!)
            self.myTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (alertAction:UIAlertAction) -> Void in
            //
        }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
            
        }
        alert.addAction(save)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    func saveStudent(name:String) {
        let student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: context!) as! Student
        student.name = name
        // error handling
        var err:NSError?
        do {
            try context?.save()
        } catch let err1 as NSError {
            err = err1
        }
        if err != nil {
            print("We have a problem")
        }
        students.append(student)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return students.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = student.valueForKey("name") as? String
        return cell
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let request = NSFetchRequest(entityName: "Student")
        var err:NSError?
        do {
            try students = context.executeFetchRequest(request) as! [Student]
        } catch let err1 as NSError {
            err = err1
        }
        if err != nil {
            print("Could not load data \(err)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

