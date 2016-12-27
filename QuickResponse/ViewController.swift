//
//  ViewController.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/27/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var web: UIWebView!
    var urls : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        direccion?.text = urls!
        let url = NSURL(string: urls!)
        let peticion  = NSURLRequest(URL: url!)
        web.loadRequest(peticion)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

