//
//  InterfaceController.swift
//  QuickWatch Extension
//
//  Created by Roberto Carlos Callisaya Mamani on 1/10/17.
//  Copyright © 2017 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
import CoreLocation



class InterfaceController: WKInterfaceController,CLLocationManagerDelegate {
    private let manejador = CLLocationManager()

    @IBOutlet var mapa: WKInterfaceMap!
    @IBOutlet var hacerZoom: WKInterfaceSlider!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        //print("Ingreso al manejador")
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        //manejador.distanceFilter = 10.0
        
        // Se solicita autorización del usuario para obetener su localización.
        manejador.requestWhenInUseAuthorization()
      
       let tec=CLLocationCoordinate2D(latitude: -17.372756, longitude: -66.156793)
        agregarAnotacion(location: tec)
         mostrarRutas()
    }
    
    func agregarAnotacion(location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapa.setRegion(region)
        self.mapa.addAnnotation(location, with: .purple)
   
    }
    
    func mostrarRutas(){
        
       // toDoItems = []
       /* do{
            let fetchRequest : NSFetchRequest<Ruta> = Ruta.fetchRequest()
            let rutas = try contexto?.fetch(fetchRequest)
            for ruta in rutas! {
                //print("Fetched Managed Object = \(ruta.nombre)")
                //toDoItems.append(ruta)
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }*/
        
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
