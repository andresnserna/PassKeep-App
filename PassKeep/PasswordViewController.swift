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
        print("1")
        
        do {
            data = try context.fetch(SavedLogin.fetchRequest())
            print("2")

            for existingLogin in data {
                print("3")
                print(existingLogin.user_username!)
                print(activeUser!)

                if existingLogin.user_username == activeUser {
                    items.append(existingLogin.login_websiteURL!)
                    print("4")
                    print(items)

                }
            }
        }
        catch {
            print("Error loading saved accounts: \(error)")
        }
        
        tbl_items.reloadData()

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AccountViewController,
           let indexPath = tbl_items.indexPathForSelectedRow {
            // Pass the selected URL to the AccountViewController
            destinationVC.urlString = items[indexPath.row]
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
        } else {
            let alertview = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertview, animated: true)
        }
    }
    
    @IBOutlet weak var txt_passwordField: UITextField!
    
    @IBAction func btn_generatePassword(_ sender: UIButton) {
        var randomPassword = ""
        let length = 12
        
        for _ in 0..<length {
            // ASCII range 33...126 gives you all printable characters except space
            let randomAscii = Int.random(in: 33...126)
            
            if let scalar = UnicodeScalar(randomAscii) {
                randomPassword.append(Character(scalar))
            }
        }
        
        txt_passwordField.text = randomPassword
    }
    
    @IBAction func btn_signOut(_ sender: UIButton) {
        //do we need to delete this?
    }
}
