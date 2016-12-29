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
        
        
        
        if let miruta = ruta{
            self.nombre.text = miruta.nombre!
            //self.descripcion.text = miruta.descripcion!

        }
        
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
        let alert = UIAlertController(title: "Lugar Favorito", message: "Ingrese el nombre del lugar favorito", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            
            let entityDescripcion = NSEntityDescription.entity(forEntityName: "Punto", in: self.contexto!)
            let punto = Punto(entity: entityDescripcion!, insertInto: self.contexto!)
            punto.nombre = textField?.text
            
            punto.latitud = (self.manejador.location?.coordinate.latitude)!
            punto.longitud = (self.manejador.location?.coordinate.longitude)!
            //punto.posicion =  latitude + ","+longitude
            self.ruta?.addToTiene(punto)
            do{
                try self.contexto?.save()
                self.marcarPin(latitud: punto.latitud, longitud: punto.longitud, titulo : punto.nombre!)
                self.mapa.setCenter( CLLocationCoordinate2D(latitude: punto.latitud, longitude: punto.longitud), animated: true)
            }catch let error {
                print(error.localizedDescription)
            }
            
            }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func mostrarPuntos(){
        print("Mostrando los puntos")
        contexto?.perform {
            
            
            //let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            //let rutas = try! fetchRequest.execute()
            var contador = 0
            for punto in (self.ruta?.tiene)!  {
                
                let puntoData = punto as! Punto
                
                    print("Punto Managed Object = \(puntoData.nombre!)")
                    print("Posicion = \(puntoData.posicion)")
                    print("Latitud \(puntoData.latitud)")
                    print("Latitud \(puntoData.longitud)")
                    if(contador == 0 ){
                        self.mapa.setCenter(CLLocationCoordinate2D(latitude: puntoData.latitud, longitude: puntoData.longitud), animated: true)
                        contador += 1
                        let span = MKCoordinateSpanMake(0.075, 0.075)
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: puntoData.latitud, longitude: puntoData.longitud), span: span)
                        self.mapa.setRegion(region, animated: true)
                    }
                    self.marcarPin(latitud: puntoData.latitud, longitud: puntoData.longitud, titulo: puntoData.nombre!)
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
    }
    
    
    func agregarPin(_ coordenadas: CLLocationCoordinate2D)
    {
        let pin = MKPointAnnotation()
        pin.title = "Lat: \(coordenadas.latitude)  Long: \(coordenadas.longitude)"
        //pin.subtitle = "Total recorrido: \(distanciaRecorrida) mtrs"
        pin.coordinate = coordenadas
        mapa.addAnnotation(pin)
    }
    
    func marcarPin ( latitud : Double, longitud : Double, titulo : String){
        let coordenadas = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let pin = MKPointAnnotation()
        pin.title = titulo
        pin.subtitle = "Lat: \(latitud)  Long: \(longitud)"
        pin.coordinate = coordenadas
        mapa.addAnnotation(pin)
    }

    
  
    
    
}
