//
//  AccountViewController.swift
//  PassKeep
//
//  Created by Andrés Serna on 10/27/25.
//

import UIKit
import WebKit

class AccountViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?
    
    @IBOutlet weak var lbl_websiteURL: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_password: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Load the saved login data
        loadAccountData()

        // Load the webpage if we have a URL
        //append https:// to the FRONT of the variable urlString
        urlString = "https://www." + (urlString ?? "")
        if let thisURLString = urlString, let url = URL(string: thisURLString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // Style like a link
        lbl_websiteURL.textColor = .systemBlue
        lbl_websiteURL.isUserInteractionEnabled = true
        
        // Add tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped(theURL: urlString)))
        lbl_websiteURL.addGestureRecognizer(tap)
    }
    
    func loadAccountData() {
        guard let urlString = urlString else {
            print("No URL string provided")
            return
        }
        
        var data = [SavedLogin]()
        
        do {
            data = try context.fetch(SavedLogin.fetchRequest())
            
            // Find the matching SavedLogin for this URL and active user
            for savedLogin in data {
                if savedLogin.login_websiteURL == urlString && savedLogin.user_username == activeUser {
                    // Update the labels with the saved data
                    lbl_websiteURL.text = savedLogin.login_websiteURL
                    lbl_username.text = savedLogin.login_username
                    lbl_password.text = savedLogin.login_password
                    return
                }
            }
            
            // If no matching login found
            print("No saved login found for URL: \(urlString)")
            
        } catch {
            print("Error fetching saved login: \(error)")
        }
    }
    
    @objc func linkTapped(theURL: String?){
        if let url = URL(string: theURL ?? "https://www.apple.com") {
                UIApplication.shared.open(url)
        }
    }
}
