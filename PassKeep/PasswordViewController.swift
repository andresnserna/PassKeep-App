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
        var data = [SavedLogin]()
        
        do {
            data = try context.fetch(SavedLogin.fetchRequest())
            
            for existingLogin in data {
                if existingLogin.user_username == activeUser {
                    items.append(existingLogin.login_websiteURL!)
                }
            }
        }
        catch {
            print("Error fetching tasks: \(error)")
        }

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var data = [SavedLogin]()
            
            do {
                data = try context.fetch(SavedLogin.fetchRequest())
                
                for existingLogin in data {
                    if existingLogin.login_websiteURL == items[indexPath.row] && existingLogin.user_username == activeUser{
                        context.delete(existingLogin)
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
    
    @IBOutlet weak var txt_websiteURL: UITextField!
    
    @IBOutlet weak var txt_usernameField: UITextField!
    
    @IBAction func btn_addAccount(_ sender: UIButton) {
        if (txt_websiteURL.text != nil && txt_websiteURL.text != "") &&
            (txt_usernameField.text != nil && txt_usernameField.text != "") &&
             (txt_passwordField.text != nil && txt_passwordField.text != "") {
            
            let savedLogin = SavedLogin(context: context)
            savedLogin.login_websiteURL = txt_websiteURL.text!
            savedLogin.login_username = txt_usernameField.text!
            savedLogin.login_password = txt_passwordField.text!
            savedLogin.user_username = activeUser
            
            do {
                try context.save()
            } catch {
                print("Error saving task: \(error)")
            }
            
            items.append(txt_websiteURL.text!)
            tbl_items.reloadData()
            txt_websiteURL.text = ""
            txt_usernameField.text = ""
            txt_passwordField.text = ""
        }
    }
    
    @IBOutlet weak var txt_passwordField: UITextField!
    
    @IBAction func btn_generatePassword(_ sender: UIButton) {
    }
    
}
