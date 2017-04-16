//
//  ESPNViewController.swift
//  iHoop
//
//  Created by Eric Dowdell on 4/16/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class ESPNViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://www.espn.com/nba/")
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
        
        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    @IBAction func refreshWebView(_ sender: Any) {
        viewDidLoad()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
