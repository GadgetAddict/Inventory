//
//  qrScannerVC.swift
//  Inventory17
//
//  Created by Michael King on 3/10/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

enum qrScanType {
    case searchItem     //from itemFeed - scan Item QR for details
    case searchBox      //from boxFeed - scan Box QR for details
    case updateItemQR   //from itemDetails - set custom qr
    case addToBox       //from itemFeed or ItemDetails - load existing box          but warning if category mismatch
    
}



class qrScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let REF =  DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/")
    
    @IBOutlet weak var messageLabel:UILabel!
    var qrData: String!
    var scannedBox: Box!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode]

    
    
    
//    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
            view.bringSubview(toFront: messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
//        if let navController = self.navigationController {
//            navController.dismiss(animated: true, completion: nil)
//        }
        navigationController!.popToRootViewController(animated: true)

    }
    
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        print(" IN THE captureOutput")
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
            
                
                let qrString = metadataObj.stringValue
                
                print("STRING VALUE \(qrString)")
                
                
                messageLabel.text = qrString
                captureSession?.stopRunning()
                
                 let serialQueue = DispatchQueue(label: "com.queue.Serial")
                
                   serialQueue.async {

//           DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes/\(qrString!)").
                   
 
                let boxRef = self.REF.child("boxes/\(qrString!)")
                    
                    
        boxRef.observeSingleEvent(of: .value, with: { snapshot in
                     if let boxDict = snapshot.value as? Dictionary<String, AnyObject> {

      
                    self.scannedBox = Box(boxKey: qrString!, dictionary: boxDict)
                        print("scannedBox Cat VALUE \(self.scannedBox.boxCategory)")

                  
                        self.performSegue(withIdentifier: "BoxDetails_SEGUE", sender: self)

                    }
                })

            }
            }
        }

        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //    @IBAction func unwindToBoxDetailswithQRBOX(_ segue:UIStoryboardSegue) {
            //        print("Back to box from QR ")
            //        if let QrVC = segue.source as? qrScannerVC {
            //             if let selectedBox = QrVC.scannedBox  { //passed from QRVC
            //             self.box = selectedBox
            ////                boxesREF = (self.REF_BOXES.child(query.child).queryEqual(toValue: query.value))
            ////                self.query = (child: "boxNum", value: selectedBox)
            //
            //                self.boxIsNew = false
            //             }
            //         }
            //    }

        if segue.identifier == "BoxDetails_SEGUE" {
            print("Box Details from QR Segue")
            if let boxDetailsVC = segue.destination as? BoxDetails {
            boxDetailsVC.box = self.scannedBox
            boxDetailsVC.boxSegueType = .qr
            }
        }
    }
}


