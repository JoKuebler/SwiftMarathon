//
//  ViewController.swift
//  04_MiniWebBrowser
//
//  Created by Jonas Kübler on 23.07.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var safeSites = ["youtube.com", "google.com"]
    
    override func loadView() {
        
        webView = WKWebView()
        // Delegate sends "messages" and by setting it to self it sends those messages to YOU
        // Crucial line often forgotten
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // Add Buttons to Toolbar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "Back",style: .plain, target: webView, action: #selector(webView!.goBack))
        let goForward = UIBarButtonItem(title: "Forward",style: .plain, target: webView, action: #selector(webView!.goForward))
        
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [goBack, goForward, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Remember that https is required here due to iOS security reasons
        let url = URL(string: "https://" + safeSites[0])!
        // Has to be URL Request with desired url
        webView.load(URLRequest(url: url))
        // Enables swipe right and left to go forward and back
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        
        for safeSite in safeSites {
            ac.addAction(UIAlertAction(title: safeSite, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath ==  "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // Allows you to decide wheter a navigation is allowed to happen or not
    // Very nice to implement the functionality to only allow certain pages
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for safeSite in safeSites {
                if host.contains(safeSite) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
        
        // Show alert if it is not allowed
        let acTwo = UIAlertController(title: "Not allowed sorry", message: nil, preferredStyle: .alert)
        acTwo.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(acTwo, animated: true)
        
    }


}

