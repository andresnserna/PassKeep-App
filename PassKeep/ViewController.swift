//
//  ViewController.swift
//  PassKeep
//
//  Created by Andrés Serna on 10/24/25.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
var activeUser : String? = nil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeUser = nil
        //lbl_errorMessage.isHidden = true
    }

    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var lbl_errorMessage: UILabel!
    
    @IBAction func btn_signIn(_ sender: UIButton) {
        var data = [Accounts]()
        var alertTitle : String = ""
        var alertMessage : String = ""
        var alertController : UIAlertController!
        
        do {
            data = try context.fetch(Accounts.fetchRequest())
            
            for existingUser in data {
                if (existingUser.username == txt_username.text && existingUser.password == txt_password.text) {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let destinationViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "SecurePage")
                    self.present(destinationViewController, animated: true, completion: nil)
                    activeUser = existingUser.username
                    return
                } else {
                    lbl_errorMessage.isHidden = false
                }
            }
        }
        catch {
            //preent error pop up
            alertTitle = "Error"
            alertMessage = "Error fetching data: \(error)"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            print("Error fetching data: \(error)")
        }
    }
    
    @IBAction func btn_registerNewUser(_ sender: UIButton) {
        //read that username and password are not empty or nil
        if (txt_password.text != nil && txt_username.text != nil && txt_password.text != "" && txt_username.text != ""){
            addNewUser(newUsername: txt_username.text!, newPassword: txt_password.text!)
        }
    }
    
    func addNewUser(newUsername: String, newPassword: String) {
        let newAccount = Accounts (context: context)
        newAccount.username = newUsername
        newAccount.password = newPassword
        
        //alert setup
        var alertTitle : String = ""
        var alertMessage : String = ""
        var alertController : UIAlertController!
        
        do {
            try context.save()
            //present successful pop up
            alertTitle = "Success!"
            alertMessage = "User " + newUsername + " added successfully!"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            print("User added successfully")
            
        } catch {
            //preent error pop up
            alertTitle = "Error"
            alertMessage = "Error adding user: \(error)"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            print("Error adding user: \(error)")
        }
    }
    
}

