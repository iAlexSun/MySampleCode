//
//  ViewController.swift
//  CMCoreMLDetect
//
//  Created by Alex on 2017/6/10.
//  Copyright © 2017年 Alex. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import Foundation


class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate{
    var captureSession = AVCaptureSession()
    var cameraDevice:AVCaptureDevice!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var resultLabel:UILabel!
    var classLabelProbLabel:UILabel!
    var TitleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
        initResultView()
    }
    
    
    func initResultView(){
        
        TitleLabel = UILabel()
        TitleLabel.text = "Classification"
        TitleLabel.textColor = UIColor.white
        TitleLabel.font = UIFont.systemFont(ofSize: 25)
        TitleLabel.frame = CGRect.init(x: 20, y: 50, width: 200, height: 30)
        self.view.addSubview(TitleLabel)
        
        resultLabel = UILabel()
        resultLabel.textColor = UIColor.white
        resultLabel.frame = CGRect.init(x: 20, y: 100, width: UIScreen.main.bounds.width-20, height: 30)
        self.view.addSubview(resultLabel)
        
        classLabelProbLabel = UILabel()
        classLabelProbLabel.textColor = UIColor.white
        classLabelProbLabel.frame = CGRect.init(x: 20, y: 160, width:UIScreen.main.bounds.width-20, height: 30)
        self.view.addSubview(classLabelProbLabel)
    }
    
    func openCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaType.video)) {
                if (device.position == .back) {
                    cameraDevice = device
                    if cameraDevice != nil {
                        beginSession()
                    }
                }
            }
        }
    }
    
    func beginSession(){
        
        let err : NSError? = nil
        let captureDeviceInput = try? AVCaptureDeviceInput.init(device: cameraDevice)
        captureSession.addInput(captureDeviceInput!)
        let output = AVCaptureVideoDataOutput()
        let cameraQueue = DispatchQueue(label:"com.CoreMLDetect.cameraQueue")
        output.setSampleBufferDelegate(self, queue:cameraQueue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        captureSession.addOutput(output)
        if err != nil {
            print("error: \(String(describing: err?.localizedDescription))")
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
    
    override func didReceiveMemoryWarning() {
        captureSession.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        let image = UIImage(ciImage: cameraImage)
        let result = MLDetectImageModel(image: image)
        VNDetectImageModel(image:image)
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.resultLabel.text = String.init(format:"Inceptionv3:%@ %.2f", result.classLabel,result.classLabelProb)
            }
        }
    }
    
    //使用Inceptionv3转化后模型方法
    func MLDetectImageModel(image:UIImage)->(classLabel:String,classLabelProb:Double){
        let model = Inceptionv3()
        let pixelBuffer = image.convertToPixelBuffer(image: image, imageFrame: 299.0)
        guard let pb = pixelBuffer , let output = try? model.prediction(image: pb) else{
            fatalError("Unexpected runtime error.")
        }
       let classLabelProbs = output.classLabelProbs as Dictionary!
        for classLabelProb in classLabelProbs!{
            if classLabelProb.key == output.classLabel {
                 return (classLabelProb.key ,classLabelProb.value)
            }
        }
        return ("",0.00)
    }
    
    //使用vision库是进行物体识别加载GoogLeNetPlaces模型
    func VNDetectImageModel(image:UIImage) {
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
            fatalError("Couldn't init model")
        }
        let request = VNCoreMLRequest(model: model, completionHandler: ResultsMethod)
        let pixelBuffer = image.convertToPixelBuffer(image: image, imageFrame: 299.0)
        let handler = VNImageRequestHandler(cvPixelBuffer:pixelBuffer!, options: [:])
        
        guard ((try? handler.perform([request])) != nil) else {
            fatalError("Error on model")
        }
    }
    
    //请求后进行的处理方法
    func ResultsMethod(request:VNRequest,error:Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("results error")
        }
        for _ in results {
            DispatchQueue.main.async {
                self.classLabelProbLabel.text = String(format: "GoogLeNetPlaces:%@ %.2f", results.first!.identifier,results.first!.confidence)
            }
            
        }
    }
}

