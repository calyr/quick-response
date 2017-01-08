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

class PuntoController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, ARDataSource {
    
    var ruta : Ruta?

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    private let manejador = CLLocationManager()
    @IBOutlet weak var fotoVista: UIImageView!
    private let miPicker = UIImagePickerController()
    var contexto : NSManagedObjectContext? = nil
    var myRoute : MKRoute!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
       
        
        if let miruta = ruta{
            self.title = miruta.nombre!

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
            let point1 = MKPointAnnotation()
            let point2 = MKPointAnnotation()
            for punto in (self.ruta?.tiene)!  {
                
                let puntoData = punto as! Punto
                
                
                    if( contador % 2 == 0){
                        point1.coordinate = CLLocationCoordinate2DMake(puntoData.latitud,puntoData.longitud)
                        point1.title = puntoData.nombre
                        point1.subtitle = ("Latitud: \(puntoData.latitud) Longitud: \(puntoData.longitud)")
                     
                    }else{
                        point2.coordinate = CLLocationCoordinate2DMake(puntoData.latitud,puntoData.longitud)
                        point2.title = puntoData.nombre
                        point2.subtitle = ("Latitud: \(puntoData.latitud) Longitud: \(puntoData.longitud)")
                        self.crearRuta(point1: point1, point2:  point2)
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
   
    func crearRuta(point1: MKPointAnnotation, point2: MKPointAnnotation){
  
    
    
    mapa.addAnnotation(point1)
    mapa.addAnnotation(point2)
    mapa.delegate = self
    
    //Span of the map
    //mapa.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
    
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
    
    
    //Realidad Aumentada
    @IBAction func inicia(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            let alerta = UIAlertController(title: "Realidad Aumentada", message: " La camara no esta habilitada, favor probar en un dispositivo físico.", preferredStyle: .alert)
            let accionOk = UIAlertAction(title: "OK", style: .default, handler: {
                accion in
                
            })
            
            alerta.addAction(accionOk)
            present(alerta, animated: true, completion: nil)
            
        }else{
            iniciaRAG()
        }
        
    }
    
  
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        
        let vista = TestAnnotationView()
        vista.backgroundColor = UIColor.black
        vista.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        return vista
        
    }
    
    func iniciaRAG(){
        
        let latitude   = (self.manejador.location?.coordinate.latitude)!
        let longitude  = (self.manejador.location?.coordinate.longitude)!

        let delta = 0.05
        
        print("La cantidad de puntos es \(ruta?.tiene?.count)")
        let numeroDeElementos = ruta?.tiene?.count
        
        let puntosDeInteres = obtenAnotaciones(latitud: latitude, longitud: longitude, delta: delta, numeroDeElementos: numeroDeElementos!)
        let arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 50
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(puntosDeInteres)
        arViewController.uiOptions.debugEnabled = true
        arViewController.uiOptions.closeButtonEnabled = true
        //arViewController.interfaceOrientationMask = .landscape
        arViewController.onDidFailToFindLocation =
            {
                [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
                // Show alert and dismiss
        }
        self.present(arViewController, animated: true, completion: nil)
    }
    
    private func obtenAnotaciones( latitud: Double, longitud: Double, delta: Double, numeroDeElementos: Int) -> Array<ARAnnotation>{
        
        var anotaciones: [ARAnnotation] = []
     
        
        for punto in (self.ruta?.tiene)!  {
            
            let puntoData = punto as! Punto
            
            let anotacion = ARAnnotation()
            anotacion.location = self.obtenerPosiciones(latitud: puntoData.latitud, longitud: puntoData.longitud, delta: delta)
            anotacion.title = puntoData.nombre
            anotaciones.append(anotacion)
                 }
        
       
        return anotaciones
    }
    
    private func obtenerPosiciones( latitud: Double, longitud: Double, delta: Double )-> CLLocation{
        var lat = latitud
        var lon = longitud
        let latDelta = -(delta/2) + drand48() * delta
        let lonDelta = -(delta/2) + drand48() * delta
        lat = lat + latDelta
        lon = lon + lonDelta
        return CLLocation(latitude: lat, longitude: lon)    
    }
    
    //Redes sociales
    @IBOutlet weak var compartir: UIButton!
    
     
    
    @IBAction func enviarCompartir(_ sender: UIButton) {
        print("Compartiendo el button")
     
        // text to share
        let text = "Proyecto Final IOS by Calyr"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func mostrarRutaR() {
        
        mostrarPuntos()
    }
    
    
}
