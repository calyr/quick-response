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

class PuntoController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
    var ruta : Ruta?

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    private let manejador = CLLocationManager()
    @IBOutlet weak var fotoVista: UIImageView!
    private let miPicker = UIImagePickerController()
    var contexto : NSManagedObjectContext? = nil
    var myRoute : MKRoute!
    
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
        mapa.isZoomEnabled = true
        mapa.isRotateEnabled = false
        mapa.isScrollEnabled = true
        
        //print("Ingreso al manejador")
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        //manejador.distanceFilter = 10.0
        
        // Se solicita autorización del usuario para obetener su localización.
        manejador.requestWhenInUseAuthorization()
        mapa.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)

        // Centra el mapa en la posición del usuario.
        mapa.setCenter(mapa.userLocation.coordinate, animated: true)
        mapa.showsUserLocation = true
        
        
       
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
        
        contexto?.perform {
            
        
        let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
        let rutas = try! fetchRequest.execute()
        
        for ruta in rutas{
            if let nombre = ruta.nombre {
                print("Fetched Managed Object = \(nombre)")
            }
        }
        }
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
            
            self.mostrarPuntos();
            
            }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func mostrarPuntos(){
        contexto?.perform {
            
            
            var contador = 0
            let directionsRequest = MKDirectionsRequest()
            for punto in (self.ruta?.tiene)!  {
                
                let puntoData = punto as! Punto
                
                   let puntoNow = MKPlacemark(coordinate: CLLocationCoordinate2DMake(puntoData.latitud, puntoData.longitud), addressDictionary: nil)
                
                    if( contador % 2 == 0){
                        directionsRequest.source = MKMapItem(placemark: puntoNow)
                    }else{
                        directionsRequest.destination = MKMapItem(placemark: puntoNow)
                        self.crearRuta(itemOrigen: directionsRequest.source!, itemDestino:  directionsRequest.destination!)
                        print("Ingreso a dibujar")
                    }
                
                
                    contador += 1
                    self.marcarPin(latitud: puntoData.latitud, longitud: puntoData.longitud, titulo: puntoData.nombre!)
                
                
            }
        }
    }
    
    @IBAction func guardar() {
        
        savePunto()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //print("Autorizacio Okey")
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            //print("StopUpdatingLocation")
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
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
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func dibujarRuta(respuesta: MKDirectionsResponse) {
        self.mapa.add(respuesta.routes[0].polyline, level: MKOverlayLevel.aboveRoads)
    }
    
    @IBAction func drawLineBtn() {
        
    }
   
    func crearRuta(itemOrigen: MKMapItem, itemDestino: MKMapItem){
    
    let point1 = MKPointAnnotation()
    let point2 = MKPointAnnotation()
    
    point1.coordinate = CLLocationCoordinate2DMake(itemOrigen.placemark.coordinate.latitude,itemOrigen.placemark.coordinate.longitude )
    point1.title = "Taipei"
    point1.subtitle = "Taiwan"
    mapa.addAnnotation(point1)
    
    point2.coordinate = CLLocationCoordinate2DMake(itemDestino.placemark.coordinate.latitude,itemDestino.placemark.coordinate.longitude)
    point2.title = "Chungli"
    point2.subtitle = "Taiwan"
    mapa.addAnnotation(point2)
    mapa.centerCoordinate = point2.coordinate
    mapa.delegate = self
    
    //Span of the map
    mapa.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
    
    let directionsRequest = MKDirectionsRequest()
    let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
    let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
    
    directionsRequest.source = MKMapItem(placemark: markChungli)
    directionsRequest.destination = MKMapItem(placemark: markTaipei)
    
    directionsRequest.transportType = MKDirectionsTransportType.automobile
    let directions = MKDirections(request: directionsRequest)
    
    directions.calculate(completionHandler: {
        response, error in
        
        if error == nil {
            self.myRoute = response!.routes[0] as MKRoute
            self.mapa.add(self.myRoute.polyline)
        }
        
    })
    
    }
    
    func muestraRuta(respuesta: MKDirectionsResponse){
        print("ingreso a mostrar la ruta")
        for ruta in respuesta.routes{
            print("Primer elemento")
            mapa.add(ruta.polyline, level: MKOverlayLevel.aboveRoads)
            for paso in ruta.steps{
                print("Pasos")
                print("Paso \(paso.instructions)")

            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor.red
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
  
    
  
    
    
}
