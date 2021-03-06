//
//  View.swift
//  QuickResponse
//
//  Created by Roberto Carlos Callisaya Mamani on 12/27/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import AVFoundation

class View: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var sesion : AVCaptureSession?
    var capa   : AVCaptureVideoPreviewLayer?
    var marcoQR : UIView?
    var urls : String?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        marcoQR?.frame = CGRect.zero
        sesion?.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QR Principal";
        let dispositivo = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        // Do any additional setup after loading the view.
        do{
            let entrada = try AVCaptureDeviceInput(device: dispositivo)
            sesion = AVCaptureSession()
            sesion?.addInput(entrada)
            let metaDatos = AVCaptureMetadataOutput()
            sesion?.addOutput(metaDatos)
            metaDatos.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDatos.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            capa = AVCaptureVideoPreviewLayer(session: sesion!)
            capa?.videoGravity = AVLayerVideoGravityResizeAspectFill
            capa?.frame = view.layer.bounds
            view.layer.addSublayer(capa!)
            marcoQR = UIView()
            marcoQR?.layer.borderWidth = 3
            marcoQR?.layer.borderColor = UIColor.red.cgColor
            
            view.addSubview(marcoQR!)
            sesion?.startRunning()
            
        }catch{
            
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        marcoQR?.frame = CGRect.zero
        if(metadataObjects == nil || metadataObjects.count == 0){
            return
        }
        let objMetadato = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if (objMetadato.type == AVMetadataObjectTypeQRCode){
            let objBorder = capa?.transformedMetadataObject(for: objMetadato as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            marcoQR?.frame = objBorder.bounds
            
            if objMetadato.stringValue != nil {
                self.urls = objMetadato.stringValue
                let navc = self.navigationController
                navc?.performSegue(withIdentifier: "detalle", sender: self)
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
