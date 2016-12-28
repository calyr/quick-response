//
//  MisRutas.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/28/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class MisRutas: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Mis Rutas"
        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MisRutas.newRuta));        // boton derecho
        //self.navigationItem.rightBarButtonItem = addButton
    }
    
    /*func newRuta(){
        let newRutaController = NewRuta(nibName: "NewRuta", bundle: nil)
        self.navigationController?.pushViewController(newRutaController, animated: true)
        print("Funcion el boton")
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
