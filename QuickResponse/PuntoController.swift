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
import MapKit

class PuntoController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ruta : Ruta?

    @IBOutlet weak var mapa: MKMapView!
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
        
        //mostrarRutasNew()
        mostrarPuntos()
        miPicker.delegate = self
        
        //print("Ingreso al manejador")
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        //manejador.distanceFilter = 10.0
        
        // Se solicita autorización del usuario para obetener su localización.
        manejador.requestWhenInUseAuthorization()
        
        // Centra el mapa en la posición del usuario.
        //mapa.setCenter(mapa.userLocation.coordinate, animated: true)
        
        
        // Realiza un zoom y seguimiento del usuario
        //print("Fin de")
        
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
    
        
    func mostrarRutasNew(){
        //print("Nuevo mostrar rutas new")
        //print(ruta)
        contexto?.perform {
            
        
        let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
        let rutas = try! fetchRequest.execute()
        
        for ruta in rutas{
            if let nombre = ruta.nombre {
                print("Fetched Managed Object = \(nombre)")
            }
        }
        }
       // print("End mostrar rutas new")
    }
    
    func savePunto(){
        
        let entityDescripcion = NSEntityDescription.entity(forEntityName: "Punto", in: contexto!)
        let punto = Punto(entity: entityDescripcion!, insertInto: self.contexto!)
        print("El nombre es = " + self.nombre.text!)
        punto.nombre = self.nombre.text!
        let latitude  = String(describing: manejador.location?.coordinate.latitude)
        let longitude = String(describing: manejador.location?.coordinate.longitude)
        
        punto.posicion =  latitude + ","+longitude
        self.ruta?.addToTiene(punto)
        do{
            try contexto?.save()
        }catch let error {
            print(error.localizedDescription)
        }

    }
    
    func mostrarPuntos(){
        print("Mostrando los puntos")
        contexto?.perform {
            
            
            //let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            //let rutas = try! fetchRequest.execute()
            
            for punto in (self.ruta?.tiene)!  {
                let puntoData = punto as! Punto
                
                    print("Punto Managed Object = \(puntoData.nombre!)")
                    print("Posicion = \(puntoData.posicion!)")
                
            }
        }
        print("Mostrando los end")
    }
    
    @IBAction func guardar() {
        
        //print(ruta!.nombre)
        //print(ruta!.descripcion)
        //agregarPin((manejador.location?.coordinate)!)
        savePunto()
        mostrarPuntos()
        /*
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
        }*/
        
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
        
    
        latitud.text = String(coordenadas.latitude)
        longitud.text = String(coordenadas.longitude)
    }
    
    func agregarPin(_ coordenadas: CLLocationCoordinate2D)
    {
        let pin = MKPointAnnotation()
        pin.title = "Lat: \(coordenadas.latitude)  Long: \(coordenadas.longitude)"
        //pin.subtitle = "Total recorrido: \(distanciaRecorrida) mtrs"
        pin.coordinate = coordenadas
        mapa.addAnnotation(pin)
    }

    
  
    
    
}
