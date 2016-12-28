//
//  MisRutas.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/28/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import CoreData

class MisRutas: UIViewController {
    
    var contexto : NSManagedObjectContext? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        mostrarRutas()
    }
    
    func mostrarRutas(){
        print("Nuevo mostrar rutas new")
        contexto?.perform {
            let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            let rutas = try! fetchRequest.execute()
            for ruta in rutas{
                if let nombre = ruta.nombre {
                    print("Fetched Managed Object = \(nombre)")
                }
            }
        }
        print("End mostrar rutas new")
    }
    
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
