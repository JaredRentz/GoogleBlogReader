//
//  DetailViewController.swift
//  Blogg Reader
//
//  Created by Jared Rentz on 12/31/15.
//  Copyright © 2015 UXOThings LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let postWebview = self.webView {
                postWebview.loadHTMLString(detail.valueForKey("content")!.description, baseURL: URL_NAME)
               
            
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

