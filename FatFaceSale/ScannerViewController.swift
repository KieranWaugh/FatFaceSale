//
//  ScannerViewController.swift
//  FatFaceSale
//
//  Created by Kieran Waugh on 22/12/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import AVFoundation
import UIKit
import Firebase
import SwiftCSV

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var barcodes : [String] = []
    var saleText = false
    var index = 0
    var Firebaselink = ""
    var item : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!sharedData.shared.csvData.isEmpty){
            getBarcodes()
        }
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            
            if (sharedData.shared.csvData.isEmpty){
                displayInput()
            }else{
                getBarcodes()
            }
            
        
        
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    func found(code: String) {
        print("found \(code)")
        
        
        if barcodes.contains(code){
           print("IN SALE")
            DispatchQueue.main.async {
                self.saleText = true
                self.index = self.barcodes.firstIndex(of: code)!
                self.item = sharedData.shared.csvRows[self.index]
                self.performSegue(withIdentifier: "SaleSegue", sender: self)
            }
        }else{
            print("NOT IN SALE")
            DispatchQueue.main.async {
                self.saleText = false
                self.performSegue(withIdentifier: "SaleSegue", sender: self)
            }
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func download(link: String){
        print("the link is: \(link)")
        Firebaselink = link
        let storage = Storage.storage()
        let gsReference = storage.reference(forURL: link)
       gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("error is \(error)")
          } else {
            let dataString = String(data: data!, encoding: .utf8)
            let csv = try! CSV(string: dataString!)
            sharedData.shared.csvRows = csv.enumeratedRows
            sharedData.shared.csvData = csv.namedRows
            print(csv.namedRows)
            UserDefaults.standard.set(sharedData.shared.csvData, forKey: "dict")
            self.getBarcodes()
            
          }
        }
        
    }
    
    func getBarcodes(){
        for i in sharedData.shared.csvData {
            self.barcodes.append(i["BARCODE"]!)
        }
        print(self.barcodes)
    }
    
    func displayInput(){
        self.captureSession.stopRunning()
        let alert = UIAlertController(title: "Enter Link", message: "Paste the link for the sale sheet here\nContact if you need help", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
         let textField = alert?.textFields![0]
            self.download(link: (textField!.text)!)
            self.captureSession.startRunning()
            
        }))

        self.present(alert, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! InSaleViewController
        vc.sale = saleText
        vc.item = item
    }
}
