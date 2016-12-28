//
//  Punto.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/27/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class PuntoController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var latitud: UILabel!
    @IBOutlet weak var longitud: UILabel!
    @IBOutlet weak var exaHor: UILabel!
    private let manejador = CLLocationManager()
    @IBOutlet weak var fotoVista: UIImageView!
    private let miPicker = UIImagePickerController()
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraButton.isHidden = true
        }
        mostrarRutasNew()
        
        miPicker.delegate = self
        
        print("Ingreso al manejador")
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        //manejador.distanceFilter = 10.0
        
        // Se solicita autorización del usuario para obetener su localización.
        manejador.requestWhenInUseAuthorization()
        
        // Centra el mapa en la posición del usuario.
        //mapa.setCenter(mapa.userLocation.coordinate, animated: true)
        
        // Realiza un zoom y seguimiento del usuario
        print("Fin de")
        
        // Do any additional setup after loading the view.
    }
    @IBAction func camara() {
        miPicker.sourceType = UIImagePickerControllerSourceType.camera
        present(miPicker, animated: true, completion: nil)
    }

    @IBAction func album() {
        miPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(miPicker, animated:true, completion: nil)
    }
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            fotoVista.image = pickerImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarRutas(){
        print("Ingreso a mostrarRutas")
        
        let rutaEntity = NSEntityDescription.entity(forEntityName: "Ruta", in: self.contexto!)
        
        let rutasPeticion = rutaEntity?.managedObjectModel.fetchRequestTemplate(forName: "petRutas")
        let rutasPet : NSFetchRequest<Ruta> = Ruta.fetchRequest()
        
        
        do{
            //let rutas = try self.contexto?.execute(rutasPeticion!)
            //let rutas = try contexto?.execute(rutasPeticion!) as! Ruta // .fetch(rutasPeticion!)
            //let rutas = try contexto?.fetch(rutasPeticion!)
            //print("Cantidad de rutas \(rutas!.count)")
/*            for ruta in rutas? as [NSManagedObject] {
                print(ruta.value(forKey : "nombre"))
                print(ruta.value(forKey : "descripcion"))
            }  */
        }catch {
            print("Error with request \(error)")
        }
        
        print("End mostrarRutas")
    }
    
    func mostrarRutasNew(){
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
    
    
    @IBAction func guardar() {
        
    /*    let rutaNew = NSEntityDescription.insertNewObject(forEntityName: "Ruta", into: self.contexto!)
        
        
        rutaNew.setValue(self.nombre.text!, forKey : "nombre")
        rutaNew.setValue(self.descripcion.text!, forKey: "descripcion")
        rutaNew.setValue(UIImagePNGRepresentation(fotoVista.image!), forKey : "foto")
        do{
           try self.contexto?.save()
        }catch{
            print("Error with request \(error)")
        }
        mostrarRutas()
      */
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Ruta",
                                       in: contexto!)
        let ruta = Ruta(entity: entityDescription!, insertInto: self.contexto!)
        
        ruta.nombre =  nombre.text
        ruta.descripcion = descripcion.text
        ruta.foto = UIImagePNGRepresentation(fotoVista.image!) as NSData?
        do{
            try self.contexto?.save()
            self.nombre.text = ""
            self.descripcion.text = ""
            self.fotoVista.image = nil
        }catch let error{
            print( error.localizedDescription )
        }
        /*
        UIImageWriteToSavedPhotosAlbum(fotoVista.image!, nil, nil, nil)
        let alerta = UIAlertController(title: "Listo!", message: "Foto Guardada en el álbum", preferredStyle: .alert)
        
        let accionOk = UIAlertAction(title: "OK", style: .default, handler: {
            accion in
            //
        })
        
        alerta.addAction(accionOk)
        present(alerta, animated: true, completion: nil)
        */
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //print("Autorizacio Okey")
            manejador.startUpdatingLocation()
            //mapa.showsUserLocation = true
        } else {
            //print("StopUpdatingLocation")
            manejador.stopUpdatingLocation()
            //mapa.showsUserLocation = false
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //print("Actualizando la localización")
        marcar((manejador.location?.coordinate)!)
    }
    
    func marcar(_ coordenadas: CLLocationCoordinate2D)
    {
        //print("Marcando los puntos la localización")
        //print(coordenadas.latitude)
        //print(coordenadas.longitude)
    
        latitud.text = String(coordenadas.latitude)
        longitud.text = String(coordenadas.longitude)
    }
    
  
    
    
}
