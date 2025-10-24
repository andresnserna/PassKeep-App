//
//  PasswordViewController.swift
//  PassKeep
//
//  Created by Andrés Serna on 10/24/25.
//

import UIKit

var items : [String] = []
class PasswordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = []
        var data = [Task]()
        
        do {
            data = try context.fetch(Task.fetchRequest())
            
            for existingTask in data {
                if existingTask.username == activeUser {
                    items.append(existingTask.taskItem!)
                }
            }
        }
        catch {
            print("Error fetching tasks: \(error)")
        }

    }
    @IBAction func btn_addItem(_ sender: UIButton) {
        if txt_addItemText.text != nil && txt_addItemText.text != "" {
            let newTask = Task(context: context)
            newTask.taskItem = txt_addItemText.text!
            newTask.username = activeUser
            
            do {
                try context.save()
            } catch {
                print("Error saving task: \(error)")
            }
            
            items.append(txt_addItemText.text!)
            tbl_items.reloadData()
            txt_addItemText.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var data = [Task]()
            
            do {
                data = try context.fetch(Task.fetchRequest())
                
                for existingTask in data {
                    if existingTask.taskItem == items[indexPath.row] && existingTask.username == activeUser{
                        context.delete(existingTask)
                    }
                }
            }
            catch {
                print("Error deleting tasks: \(error)")
            }
            
            appDelegate.saveContext()
            items.remove(at: indexPath.row)
            tbl_items.reloadData()
        }
    }
    
    @IBOutlet weak var tbl_items: UITableView!
    
    @IBOutlet weak var txt_addItemText: UITextField!
    
    
    
    
}
