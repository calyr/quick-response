//
//  NewRuta.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/28/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class NewRuta: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnAlbum: UIButton!
    @IBOutlet weak var btnCamara: UIButton!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var foto: UIImageView!
    private let manejador = CLLocationManager()
    private let miPicker = UIImagePickerController()
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        //verificamos si la camara esta disponible
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            btnCamara.isEnabled = false
        }
        
        //iniciamos la camara
        miPicker.delegate = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func aCamara() {
        miPicker.sourceType = UIImagePickerControllerSourceType.camera
        present(miPicker, animated: true, completion: nil)
    }
    
    @IBAction func aAlbum() {
        miPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(miPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            foto.image = pickerImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func guardar(_ sender: UIBarButtonItem) {
        var error : Bool = false
        
        // validacion del campo nombre
        
        if (self.nombre.text?.isEmpty)! {
            showAlert(title: "Campo Nombre", mensaje: "Este campo no puede estar vacio")
            error = true
         }

        // validacion del campo descripcion
        if (self.descripcion.text?.isEmpty)! {
            showAlert(title: "Campo descripcion", mensaje: "Este campo no puede estar vacio")
            error = true
        }
        
        if( !error){
            print("Guardar en base de datos")
            guardarRuta()
        }
    }
    
    func guardarRuta(){
        let entityDescripcion = NSEntityDescription.entity(forEntityName: "Ruta", in: contexto!)
        let ruta = Ruta(entity: entityDescripcion!, insertInto: self.contexto!)
        
        ruta.nombre = nombre.text
        ruta.descripcion = descripcion.text
        if foto.image != nil{
            ruta.foto = UIImagePNGRepresentation(foto.image!) as NSData?
        }
        do{
            try self.contexto?.save()
            clearForm()
            let alerta = UIAlertController(title: "Ruta", message: " Se guardo la ruta exitosamente.", preferredStyle: .alert)
            let accionOk = UIAlertAction(title: "OK", style: .default, handler: {
                accion in
                self.navigationController?.popViewController(animated: true)
            })
            
            alerta.addAction(accionOk)
            present(alerta, animated: true, completion: nil)
           
            
        }catch let error{
            print( error.localizedDescription)
        }
    }
    
    func clearForm(){
        self.nombre.text = ""
        self.descripcion.text = ""
               
        
        
    }
    
    
    func showAlert(title: String, mensaje:String){
        let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "OK", style: .default, handler: {
            accion in
            //
        })
        
        alerta.addAction(accionOk)
        present(alerta, animated: true, completion: nil)
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
