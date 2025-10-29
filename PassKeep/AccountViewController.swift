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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the webpage if we have a URL
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    


}
