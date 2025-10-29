//
//  AccountViewController.swift
//  PassKeep
//
//  Created by Andrés Serna on 10/27/25.
//

import UIKit
import WebKit

class AccountViewController: UIViewController {
    var webView: WKWebView!
    var urlString: String?
    
    @IBOutlet weak var lbl_websiteURL: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_password: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Load the saved login data
        loadAccountData()

        // Load the webpage if we have a URL
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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
}
