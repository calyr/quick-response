//
//  ListaRutas.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/28/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import CoreData
var toDoItems : [Ruta] = []

class ListaRutas: UITableViewController {
    var contexto : NSManagedObjectContext? = nil

    @IBOutlet var tablaRutas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        mostrarRutas()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func mostrarRutas2(){
        print("Nuevo mostrar rutas new")
        toDoItems = []
        contexto?.perform {
            let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            let rutas = try! fetchRequest.execute()
            for ruta in rutas{
                if let nombre = ruta.nombre {
                    print("Fetched Managed Object = \(nombre)")
                    toDoItems.append(ruta)
                }
            }
        }
        print(toDoItems)
        print("End mostrar rutas new")
    }
    
    func mostrarRutas(){
        print("Nuevo mostrar rutas new")
        toDoItems = []
        do{
            let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            let rutas = try contexto?.fetch(fetchRequest)
            for ruta in rutas! {
                print("Fetched Managed Object = \(ruta.nombre)")
                toDoItems.append(ruta)
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        /*
        contexto?.perform {
            let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            let rutas = try! fetchRequest.execute()
            for ruta in rutas{
                if let nombre = ruta.nombre {
                    print("Fetched Managed Object = \(nombre)")
                    toDoItems.append(ruta)
                }
            }
        }*/
        print(toDoItems)
        print("End mostrar rutas new")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Cantidad de filas \(toDoItems.count)")
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRuta", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = toDoItems[indexPath.row].nombre
        cell.detailTextLabel?.text = toDoItems[indexPath.row].descripcion

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mostrarRutas()
        tablaRutas?.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
