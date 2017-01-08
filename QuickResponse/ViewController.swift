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
    var urls :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            let alerta = UIAlertController(title: "Codigo QR", message: " La camara no esta habilitada, favor probar en un dispositivo físico.", preferredStyle: .alert)
            let accionOk = UIAlertAction(title: "OK", style: .default, handler: {
                accion in
                
            })
            
            alerta.addAction(accionOk)
            present(alerta, animated: true, completion: nil)
            
        }else{
            direccion?.text = urls!
            let url = URL(string: urls!)
            let peticion  = URLRequest(url: url!)
            web.loadRequest(peticion)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

