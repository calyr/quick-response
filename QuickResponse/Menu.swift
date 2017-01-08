//
//  Menu.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/27/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit

class Menu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu Principal"
        buscarEventos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buscarEventos(){
        
        let urls = "https://secure-caverns-53516.herokuapp.com/eventos"
        let url = URL(string: urls)
        //let datos:NSData? = NSData(contentsOf: url! as URL)
        // let texto = NSString( data: datos!, encoding: NSUTF8StringEncoding)
        /*do {
            let json  = try JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            
            let dataall = json as! NSDictionary
            print(dataall)
            
        }*/
        
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
                        
                        
                        
                    }
                    //let currentConditions = parsedData["currently"] as! [String:Any]
                    
                    //print(currentConditions)
                    
                    //let currentTemperatureF = currentConditions["temperature"] as! Double
                    //print(currentTemperatureF)
                    print(parsedData)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
            /*
            if dataall.count == 0 {
                let alert = UIAlertController(title: "PARAMETROS DE BUSQUEDA INVALIDO", message: "Verificar el codigo ISBN.", preferredStyle: .Alert)
                let popup = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(popup)
                self.presentViewController(alert, animated: true, completion: nil)
                return libro
            }
            let titulo = dataall["ISBN:"+isbn]!["title"] as! NSString as String
            labelTitulo.text = titulo
            libro.setTitulo(titulo)
            let dataautores = dataall["ISBN:"+isbn]!["authors"] as! NSArray
            let keyExists = dataall["ISBN:"+isbn]!["cover"] != nil
            
            if( keyExists == true ){
                let coverpages = dataall["ISBN:"+isbn]!["cover"] as! NSDictionary
                if( coverpages.count != 0)
                {
                    let imagenurl = coverpages["medium"] as! NSString as String
                    //print(coverpages)
                    //print(dataautores)
                    
                    // titulos.text = titulo
                    
                    //let urlimage = NSURL(string: "https://covers.openlibrary.org/b/id/6890250-S.jpg")
                    let urlimage = NSURL(string: imagenurl)
                    let dataimage = NSData(contentsOfURL: urlimage!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    imgCover.image = UIImage(data: dataimage!)
                    libro.setImagenes(imgCover)
                    // libro.setImagenes(imgCover)
                    
                    
                }
                
            }
            var stringautores = ""
            for data in dataautores {
                let dataautor = data as! NSDictionary
                let dataautorname =  dataautor["name"] as! NSString as String
                //print(dataautor)
                libro.addAutor(dataautorname)
                stringautores += dataautorname + "\n"
                
            }
            labelAutores.text = stringautores;
            
        }catch _ {
            
            let alert = UIAlertController(title: "NO INTERNET ?", message: "Check Internet connection / Flight mode please.", preferredStyle: .Alert)
            let popup = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(popup)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return libro
 */
    }
    

   

}
