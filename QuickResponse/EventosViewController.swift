//
//  EventosViewController.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 1/8/17.
//  Copyright © 2017 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit

class EventosViewController: UITableViewController {
    
    var toDoItemsEventos : [Evento] = []

    @IBOutlet var mitabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Eventos Cochabamba - Bolivia"
        buscarEventos()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func buscarEventos(){
        
        let urls = "https://secure-caverns-53516.herokuapp.com/eventos"
        let url = URL(string: urls)
                
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    
                    for dataItem in parsedData{
                        //                        if  let item as! NSObject{
                        //
                        //                        }
                        //                        print("Imprimiendo los items")
                        //                        print(dataItem)
                        //                        print(dataItem["description"])
                        let item = dataItem as! NSDictionary
                        print(item)
                        print(item["descripcion"])
                        print(item["fecha"])
                        print(item["nombre"])
                        let evento: Evento = Evento()
                        evento.nombre = item["nombre"] as! String?
                        evento.descripcion = item["descripcion"] as! String?
                        evento.fecha = item["fecha"] as! String?
                        self.toDoItemsEventos.append(evento)
                        
                        
                        
                    }
                    print(parsedData)
                    self.mitabla?.reloadData()

                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
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
        return toDoItemsEventos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellEvento", for: indexPath)

        
        // Configure the cell...
        cell.textLabel?.text = toDoItemsEventos[indexPath.row].nombre
        cell.detailTextLabel?.text = toDoItemsEventos[indexPath.row].descripcion
        
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        buscarEventos()

        
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
